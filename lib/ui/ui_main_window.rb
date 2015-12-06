=begin
** Form generated from reading ui file 'main_window.ui'
**
** Created: 日 12月 6 15:32:30 2015
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_MainWindow
    attr_reader :actionAnalyse_Text
    attr_reader :actionCapture_Clipbord
    attr_reader :actionSettings
    attr_reader :centralwidget
    attr_reader :verticalLayout_2
    attr_reader :verticalLayout
    attr_reader :bigEditor
    attr_reader :menubar
    attr_reader :statusbar

    def setupUi(mainWindow)
    if mainWindow.objectName.nil?
        mainWindow.objectName = "mainWindow"
    end
    mainWindow.resize(800, 600)
    @actionAnalyse_Text = Qt::Action.new(mainWindow)
    @actionAnalyse_Text.objectName = "actionAnalyse_Text"
    @actionCapture_Clipbord = Qt::Action.new(mainWindow)
    @actionCapture_Clipbord.objectName = "actionCapture_Clipbord"
    @actionSettings = Qt::Action.new(mainWindow)
    @actionSettings.objectName = "actionSettings"
    @centralwidget = Qt::Widget.new(mainWindow)
    @centralwidget.objectName = "centralwidget"
    @verticalLayout_2 = Qt::VBoxLayout.new(@centralwidget)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @bigEditor = Qt::TextBrowser.new(@centralwidget)
    @bigEditor.objectName = "bigEditor"
    @bigEditor.readOnly = false

    @verticalLayout.addWidget(@bigEditor)


    @verticalLayout_2.addLayout(@verticalLayout)

    mainWindow.centralWidget = @centralwidget
    @menubar = Qt::MenuBar.new(mainWindow)
    @menubar.objectName = "menubar"
    @menubar.geometry = Qt::Rect.new(0, 0, 800, 19)
    mainWindow.setMenuBar(@menubar)
    @statusbar = Qt::StatusBar.new(mainWindow)
    @statusbar.objectName = "statusbar"
    mainWindow.statusBar = @statusbar

    retranslateUi(mainWindow)

    Qt::MetaObject.connectSlotsByName(mainWindow)
    end # setupUi

    def setup_ui(mainWindow)
        setupUi(mainWindow)
    end

    def retranslateUi(mainWindow)
    mainWindow.windowTitle = Qt::Application.translate("MainWindow", "Eiwaji", nil, Qt::Application::UnicodeUTF8)
    @actionAnalyse_Text.text = Qt::Application.translate("MainWindow", "Analyse Text", nil, Qt::Application::UnicodeUTF8)
    @actionCapture_Clipbord.text = Qt::Application.translate("MainWindow", "Capture Clipbord", nil, Qt::Application::UnicodeUTF8)
    @actionSettings.text = Qt::Application.translate("MainWindow", "Settings...", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(mainWindow)
        retranslateUi(mainWindow)
    end

end

module Ui
    class MainWindow < Ui_MainWindow
    end
end  # module Ui

