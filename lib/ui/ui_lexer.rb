=begin
** Form generated from reading ui file 'lexer.ui'
**
** Created: 日 12月 6 14:19:34 2015
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_DockWidget
    attr_reader :dockWidgetContents
    attr_reader :verticalLayout_2
    attr_reader :verticalLayout
    attr_reader :textBrowser

    def setupUi(dockWidget)
    if dockWidget.objectName.nil?
        dockWidget.objectName = "dockWidget"
    end
    dockWidget.resize(400, 300)
    dockWidget.features = Qt::DockWidget::DockWidgetFloatable|Qt::DockWidget::DockWidgetMovable
    dockWidget.allowedAreas = Qt::BottomDockWidgetArea|Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea
    @dockWidgetContents = Qt::Widget.new(dockWidget)
    @dockWidgetContents.objectName = "dockWidgetContents"
    @verticalLayout_2 = Qt::VBoxLayout.new(@dockWidgetContents)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @verticalLayout_2.setContentsMargins(0, 0, 0, 0)
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @textBrowser = Qt::TextBrowser.new(@dockWidgetContents)
    @textBrowser.objectName = "textBrowser"

    @verticalLayout.addWidget(@textBrowser)


    @verticalLayout_2.addLayout(@verticalLayout)

    dockWidget.setWidget(@dockWidgetContents)

    retranslateUi(dockWidget)

    Qt::MetaObject.connectSlotsByName(dockWidget)
    end # setupUi

    def setup_ui(dockWidget)
        setupUi(dockWidget)
    end

    def retranslateUi(dockWidget)
    dockWidget.windowTitle = Qt::Application.translate("DockWidget", "Lexer", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(dockWidget)
        retranslateUi(dockWidget)
    end

end

module Ui
    class DockWidget < Ui_DockWidget
    end
end  # module Ui

