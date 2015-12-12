require 'jdict'
require 'constants'

require_relative 'ui/ui_settings'

module Eiwaji
  class SettingsDialog < Qt::Dialog
    slots 'saveAndClose()'

    def initialize(parent)
      super(parent)

      @ui = Ui_SettingsDialog.new
      @ui.setupUi(self)

      okButton = @ui.buttonBox.button(Qt::DialogButtonBox::Ok)
      closeButton = @ui.buttonBox.button(Qt::DialogButtonBox::Cancel)
      connect(okButton, SIGNAL('clicked()'), self, SLOT('saveAndClose()'))
      connect(closeButton, SIGNAL('clicked()'), self, SLOT('close()'))

      loadSettings()
    end

    def languages_hash
      @languages_hash ||= {
                           # JDict::JMDictConstants::Languages::JAPANESE => "Japanese",
                           JDict::JMDictConstants::Languages::ENGLISH => "English",
                           JDict::JMDictConstants::Languages::DUTCH => "Dutch",
                           JDict::JMDictConstants::Languages::FRENCH => "French",
                           JDict::JMDictConstants::Languages::GERMAN => "German",
                           JDict::JMDictConstants::Languages::RUSSIAN => "Russian",
                           JDict::JMDictConstants::Languages::SPANISH => "Spanish",
                           JDict::JMDictConstants::Languages::SLOVENIAN => "Slovenian",
                           JDict::JMDictConstants::Languages::SWEDISH => "Swedish",
                           JDict::JMDictConstants::Languages::HUNGARIAN => "Hungarian" }
    end

    def loadSettings
      config = JDict.configuration
      languages = JDict::JMDictConstants::Languages.constants.map {|l| languages_hash[JDict::JMDictConstants::Languages.const_get(l)]}.compact
      languages.each {|l| @ui.dictLanguageBox.addItem(l) }
      index = @ui.dictLanguageBox.findText(languages_hash[JDict.configuration.language])
      if index == -1
        index = @ui.dictLanguageBox.findText("English")
      end
      @ui.dictLanguageBox.currentIndex = index

      @ui.maxHistoryEntriesBox.value = 50
      @ui.maxResultsBox.value = JDict.configuration.num_results
    end

    def saveSettings
      JDict.reset
      JDict.configure do |config|
        config.num_results = @ui.maxResultsBox.value
        config.language = @languages_hash.key(@ui.dictLanguageBox.currentText)
      end
    end

    def saveAndClose
      saveSettings()
      close()
    end
  end
end
