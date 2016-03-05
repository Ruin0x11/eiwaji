require 'jdict'

require_relative 'ui/ui_settings'

module Eiwaji
  class SettingsDialog < Qt::Dialog
    slots 'save_and_close()', 'rebuild_index()'

    def initialize(parent)
      super(parent)

      @ui = Ui_SettingsDialog.new
      @ui.setupUi(self)

      @parent = parent

      @settings ||= Qt::Settings.new(Eiwaji::Constants::CONFIG_PATH,
                                     Qt::Settings::IniFormat)

      ok_button = @ui.buttonBox.button(Qt::DialogButtonBox::Ok)
      close_button = @ui.buttonBox.button(Qt::DialogButtonBox::Cancel)
      connect(ok_button, SIGNAL('clicked()'), self, SLOT('save_and_close()'))
      connect(close_button, SIGNAL('clicked()'), self, SLOT('close()'))
      connect(@ui.rebuildIndexButton, SIGNAL('clicked()'),
              self, SLOT('rebuild_index()'))

      load_settings
    end

    def languages_hash
      @languages_hash ||= {
                             JDict::JMDictConstants::Languages::ENGLISH   => 'English',
                             JDict::JMDictConstants::Languages::DUTCH     => 'Dutch',
                             JDict::JMDictConstants::Languages::FRENCH    => 'French',
                             JDict::JMDictConstants::Languages::GERMAN    => 'German',
                             JDict::JMDictConstants::Languages::RUSSIAN   => 'Russian',
                             JDict::JMDictConstants::Languages::SPANISH   => 'Spanish',
                             JDict::JMDictConstants::Languages::SLOVENIAN => 'Slovenian',
                             JDict::JMDictConstants::Languages::SWEDISH   => 'Swedish',
                             JDict::JMDictConstants::Languages::HUNGARIAN => 'Hungarian' }
    end

    def load_settings
      languages = JDict::JMDictConstants::Languages.constants.for_each do |l|
        languages_hash[JDict::JMDictConstants::Languages.const_get(l)]
      end
      languages.compact!
      languages.each { |l| @ui.dictLanguageBox.addItem(l) }

      index = @ui.dictLanguageBox.findText(
        languages_hash[JDict.configuration.language])
      index = @ui.dictLanguageBox.findText('English') if index == -1

      @ui.dictLanguageBox.currentIndex = index

      @ui.maxResultsBox.value = JDict.configuration.num_results
    end

    def save_settings
      @settings.setValue('num_results', Qt::Variant.new(@ui.maxResultsBox.value))
      @settings.setValue('language', Qt::Variant.new(@languages_hash.key(@ui.dictLanguageBox.currentText).to_s))
      @settings.sync
    end

    def rebuild_index
      if File.exist? Eiwaji::Constants::INDEX_FILE
        File.unlink(Eiwaji::Constants::INDEX_FILE)
      end
      Qt::MessageBox.information(self, tr('Rebuilding Index'),
                                 tr('Please wait while the index is rebuilt.'))

      @parent.rebuild_dictionary

      Qt::MessageBox.information(self, tr('Index Built'),
                                 tr('Finished building the index.'))
    end

    def save_and_close
      save_settings
      close
    end
  end
end
