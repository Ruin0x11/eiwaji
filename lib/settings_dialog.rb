require 'jdict'
require 'constants'

require 'ui/ui_settings'

module Eiwaji
  class SettingsDialog < Qt::Dialog
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
                           JDict::JMDictConstants::Languages::HUNGARIAN => "Hungarian",

    def loadSettings
      config = JDict.configuration
      languages = JDict::JMDictConstants::Languages.constants.map {|l| @languages_hash[l]}
      @ui.dictLanguageBox.addItems(languages)
      index = @ui.dictLanguageBox.findData(JDict.configuration.language)
      if index == -1
        index = @ui.dictLanguageBox.findData("English")
      end
      @ui.dictLanguageBox.index = index

      @ui.maxHistoryEntriesBox.value = 50
      @ui.maxResultsBox.value = JDict.configuration.num_results
  end

    def saveSettings
      JDict.configure do |config|
        config.num_results = @ui.maxHistoryEntriesBox.value
        config.language = @languages_hash.key(@ui.dictLanguageBox.index)
      end
    end

    def saveAndClose
      saveSettings()
      close()
    end
end
