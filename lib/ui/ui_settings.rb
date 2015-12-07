=begin
** Form generated from reading ui file 'settings.ui'
**
** Created: 日 12月 6 18:07:54 2015
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_SettingsDialog
    attr_reader :verticalLayout_2
    attr_reader :verticalLayout
    attr_reader :groupBox
    attr_reader :gridLayout
    attr_reader :label
    attr_reader :maxResultsBox
    attr_reader :dictLanguageBox
    attr_reader :rebuildIndexButton
    attr_reader :label_3
    attr_reader :maxHistoryEntriesBox
    attr_reader :label_2
    attr_reader :verticalSpacer
    attr_reader :buttonBox

    def setupUi(settingsDialog)
    if settingsDialog.objectName.nil?
        settingsDialog.objectName = "settingsDialog"
    end
    settingsDialog.resize(400, 300)
    @verticalLayout_2 = Qt::VBoxLayout.new(settingsDialog)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @groupBox = Qt::GroupBox.new(settingsDialog)
    @groupBox.objectName = "groupBox"
    @gridLayout = Qt::GridLayout.new(@groupBox)
    @gridLayout.objectName = "gridLayout"
    @label = Qt::Label.new(@groupBox)
    @label.objectName = "label"

    @gridLayout.addWidget(@label, 0, 0, 1, 1)

    @maxResultsBox = Qt::SpinBox.new(@groupBox)
    @maxResultsBox.objectName = "maxResultsBox"
    @maxResultsBox.minimum = 1
    @maxResultsBox.maximum = 1000
    @maxResultsBox.value = 50

    @gridLayout.addWidget(@maxResultsBox, 0, 1, 1, 1)

    @dictLanguageBox = Qt::ComboBox.new(@groupBox)
    @dictLanguageBox.objectName = "dictLanguageBox"

    @gridLayout.addWidget(@dictLanguageBox, 3, 1, 1, 1)

    @rebuildIndexButton = Qt::PushButton.new(@groupBox)
    @rebuildIndexButton.objectName = "rebuildIndexButton"

    @gridLayout.addWidget(@rebuildIndexButton, 6, 0, 1, 1)

    @label_3 = Qt::Label.new(@groupBox)
    @label_3.objectName = "label_3"

    @gridLayout.addWidget(@label_3, 2, 0, 1, 1)

    @maxHistoryEntriesBox = Qt::SpinBox.new(@groupBox)
    @maxHistoryEntriesBox.objectName = "maxHistoryEntriesBox"

    @gridLayout.addWidget(@maxHistoryEntriesBox, 2, 1, 1, 1)

    @label_2 = Qt::Label.new(@groupBox)
    @label_2.objectName = "label_2"

    @gridLayout.addWidget(@label_2, 3, 0, 1, 1)

    @verticalSpacer = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @gridLayout.addItem(@verticalSpacer, 4, 0, 1, 2)


    @verticalLayout.addWidget(@groupBox)


    @verticalLayout_2.addLayout(@verticalLayout)

    @buttonBox = Qt::DialogButtonBox.new(settingsDialog)
    @buttonBox.objectName = "buttonBox"
    @buttonBox.orientation = Qt::Horizontal
    @buttonBox.standardButtons = Qt::DialogButtonBox::Cancel|Qt::DialogButtonBox::Ok

    @verticalLayout_2.addWidget(@buttonBox)


    retranslateUi(settingsDialog)
    Qt::Object.connect(@buttonBox, SIGNAL('accepted()'), settingsDialog, SLOT('accept()'))
    Qt::Object.connect(@buttonBox, SIGNAL('rejected()'), settingsDialog, SLOT('reject()'))

    Qt::MetaObject.connectSlotsByName(settingsDialog)
    end # setupUi

    def setup_ui(settingsDialog)
        setupUi(settingsDialog)
    end

    def retranslateUi(settingsDialog)
    settingsDialog.windowTitle = Qt::Application.translate("SettingsDialog", "Settings", nil, Qt::Application::UnicodeUTF8)
    @groupBox.title = Qt::Application.translate("SettingsDialog", "Settings", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("SettingsDialog", "Max. Results: ", nil, Qt::Application::UnicodeUTF8)
    @rebuildIndexButton.text = Qt::Application.translate("SettingsDialog", "Rebuild Index", nil, Qt::Application::UnicodeUTF8)
    @label_3.text = Qt::Application.translate("SettingsDialog", "Max. History Entries:", nil, Qt::Application::UnicodeUTF8)
    @label_2.text = Qt::Application.translate("SettingsDialog", "Dictionary Language: ", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(settingsDialog)
        retranslateUi(settingsDialog)
    end

end

module Ui
    class SettingsDialog < Ui_SettingsDialog
    end
end  # module Ui

