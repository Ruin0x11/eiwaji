=begin
** Form generated from reading ui file 'lexer.ui'
**
** Created: 日 12月 6 15:05:48 2015
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_LexerWidget
    attr_reader :dockWidgetContents
    attr_reader :verticalLayout_2
    attr_reader :verticalLayout
    attr_reader :textBrowser

    def setupUi(lexerWidget)
    if lexerWidget.objectName.nil?
        lexerWidget.objectName = "lexerWidget"
    end
    lexerWidget.resize(400, 300)
    lexerWidget.features = Qt::DockWidget::DockWidgetFloatable|Qt::DockWidget::DockWidgetMovable
    lexerWidget.allowedAreas = Qt::BottomDockWidgetArea|Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea
    @dockWidgetContents = Qt::Widget.new(lexerWidget)
    @dockWidgetContents.objectName = "dockWidgetContents"
    @verticalLayout_2 = Qt::VBoxLayout.new(@dockWidgetContents)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @verticalLayout_2.setContentsMargins(0, 0, 0, 0)
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @textBrowser = Qt::TextBrowser.new(@dockWidgetContents)
    @textBrowser.objectName = "textBrowser"
    @font = Qt::Font.new
    @font.pointSize = 18
    @textBrowser.font = @font

    @verticalLayout.addWidget(@textBrowser)


    @verticalLayout_2.addLayout(@verticalLayout)

    lexerWidget.setWidget(@dockWidgetContents)

    retranslateUi(lexerWidget)

    Qt::MetaObject.connectSlotsByName(lexerWidget)
    end # setupUi

    def setup_ui(lexerWidget)
        setupUi(lexerWidget)
    end

    def retranslateUi(lexerWidget)
    lexerWidget.windowTitle = Qt::Application.translate("LexerWidget", "Lexer", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(lexerWidget)
        retranslateUi(lexerWidget)
    end

end

module Ui
    class LexerWidget < Ui_LexerWidget
    end
end  # module Ui

