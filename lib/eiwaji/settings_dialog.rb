module Eiwaji
  class SettingsDialog < Qt::Dialog
    slots 'saveAndClose()', 'rebuildIndex()'

    def initialize(parent)
      super(parent)

      @ui = Ui_SettingsDialog.new
      @ui.setupUi(self)

      @parent = parent

      @settings ||= Qt::Settings.new(Eiwaji::Constants::CONFIG_PATH, Qt::Settings::IniFormat)

      okButton = @ui.buttonBox.button(Qt::DialogButtonBox::Ok)
      closeButton = @ui.buttonBox.button(Qt::DialogButtonBox::Cancel)
      connect(okButton, SIGNAL('clicked()'), self, SLOT('saveAndClose()'))
      connect(closeButton, SIGNAL('clicked()'), self, SLOT('close()'))
      connect(@ui.rebuildIndexButton, SIGNAL('clicked()'), self, SLOT('rebuildIndex()'))

      loadSettings()
    end

    def languages_hash
      @languages_hash ||= {
                           JDict::JMDictConstants::Languages::ENGLISH   => "English",
                           JDict::JMDictConstants::Languages::DUTCH     => "Dutch",
                           JDict::JMDictConstants::Languages::FRENCH    => "French",
                           JDict::JMDictConstants::Languages::GERMAN    => "German",
                           JDict::JMDictConstants::Languages::RUSSIAN   => "Russian",
                           JDict::JMDictConstants::Languages::SPANISH   => "Spanish",
                           JDict::JMDictConstants::Languages::SLOVENIAN => "Slovenian",
                           JDict::JMDictConstants::Languages::SWEDISH   => "Swedish",
                           JDict::JMDictConstants::Languages::HUNGARIAN => "Hungarian" }
    end

    def loadSettings
      languages = JDict::JMDictConstants::Languages.constants.map {|l| languages_hash[JDict::JMDictConstants::Languages.const_get(l)]}.compact
      languages.each {|l| @ui.dictLanguageBox.addItem(l) }
      index = @ui.dictLanguageBox.findText(languages_hash[@settings.value("language").toString.to_sym])
      if index == -1
        index = @ui.dictLanguageBox.findText("English")
      end
      @ui.dictLanguageBox.currentIndex = index

      @ui.maxResultsBox.value = @settings.value("num_results").toInt
    end

    def saveSettings
      @settings.setValue("num_results", Qt::Variant.new(@ui.maxResultsBox.value))
      @settings.setValue("language", Qt::Variant.new(@languages_hash.key(@ui.dictLanguageBox.currentText).to_s))
      @settings.sync
    end

    def rebuildIndex()
      @parent.rebuild_dictionary

      Qt::MessageBox.information(self, tr("Index Built"),
                                 tr("Finished building the index."))
    end

    def saveAndClose
      saveSettings()
      close()
    end
  end
end
