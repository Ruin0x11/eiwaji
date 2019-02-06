=begin
** Form generated from reading ui file 'lexer.ui'
**
** Created: 木 2月 11 21:45:32 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_LexerWidget
    attr_reader :dockWidgetContents
    attr_reader :verticalLayout_2
    attr_reader :horizontalLayout
    attr_reader :buttonPrev
    attr_reader :buttonNext
    attr_reader :historyBox
    attr_reader :verticalLayout
    attr_reader :lexerTextBrowser

    def setupUi(lexerWidget)
    if lexerWidget.objectName.nil?
        lexerWidget.objectName = "lexerWidget"
    end
    lexerWidget.resize(500, 500)
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::Preferred, Qt::SizePolicy::Preferred)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = lexerWidget.sizePolicy.hasHeightForWidth
    lexerWidget.sizePolicy = @sizePolicy
    lexerWidget.minimumSize = Qt::Size.new(420, 400)
    lexerWidget.features = Qt::DockWidget::DockWidgetFloatable|Qt::DockWidget::DockWidgetMovable
    lexerWidget.allowedAreas = Qt::BottomDockWidgetArea|Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea
    @dockWidgetContents = Qt::Widget.new(lexerWidget)
    @dockWidgetContents.objectName = "dockWidgetContents"
    @verticalLayout_2 = Qt::VBoxLayout.new(@dockWidgetContents)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @verticalLayout_2.setContentsMargins(0, 0, 0, 0)
    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @buttonPrev = Qt::ToolButton.new(@dockWidgetContents)
    @buttonPrev.objectName = "buttonPrev"

    @horizontalLayout.addWidget(@buttonPrev)

    @buttonNext = Qt::ToolButton.new(@dockWidgetContents)
    @buttonNext.objectName = "buttonNext"

    @horizontalLayout.addWidget(@buttonNext)

    @historyBox = Qt::ComboBox.new(@dockWidgetContents)
    @historyBox.objectName = "historyBox"
    @font = Qt::Font.new
    @font.pointSize = 11
    @historyBox.font = @font

    @horizontalLayout.addWidget(@historyBox)


    @verticalLayout_2.addLayout(@horizontalLayout)

    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @lexerTextBrowser = Qt::TextBrowser.new(@dockWidgetContents)
    @lexerTextBrowser.objectName = "lexerTextBrowser"
    @lexerTextBrowser.minimumSize = Qt::Size.new(0, 0)
    @font1 = Qt::Font.new
    @font1.pointSize = 18
    @lexerTextBrowser.font = @font1
    @lexerTextBrowser.openLinks = false

    @verticalLayout.addWidget(@lexerTextBrowser)


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
    @buttonPrev.accessibleName = ''
    @buttonPrev.text = Qt::Application.translate("LexerWidget", "...", nil, Qt::Application::UnicodeUTF8)
    @buttonNext.text = Qt::Application.translate("LexerWidget", "...", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(lexerWidget)
        retranslateUi(lexerWidget)
    end

end

module Ui
    class LexerWidget < Ui_LexerWidget
    end
end  # module Ui

