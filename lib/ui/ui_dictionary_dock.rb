=begin
** Form generated from reading ui file 'dictionary_dock.ui'
**
** Created: 日 12月 6 14:19:34 2015
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Dictionary
    attr_reader :dockWidgetContents
    attr_reader :verticalLayout_2
    attr_reader :lineEdit
    attr_reader :verticalLayout
    attr_reader :tableView
    attr_reader :dockWidget
    attr_reader :dockWidgetContents_2
    attr_reader :verticalLayout_3
    attr_reader :textBrowser

    def setupUi(dictionary)
    if dictionary.objectName.nil?
        dictionary.objectName = "dictionary"
    end
    dictionary.resize(502, 541)
    dictionary.features = Qt::DockWidget::DockWidgetFloatable|Qt::DockWidget::DockWidgetMovable
    dictionary.allowedAreas = Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea
    @dockWidgetContents = Qt::Widget.new(dictionary)
    @dockWidgetContents.objectName = "dockWidgetContents"
    @verticalLayout_2 = Qt::VBoxLayout.new(@dockWidgetContents)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @verticalLayout_2.setContentsMargins(0, 0, 0, 0)
    @lineEdit = Qt::LineEdit.new(@dockWidgetContents)
    @lineEdit.objectName = "lineEdit"

    @verticalLayout_2.addWidget(@lineEdit)

    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @tableView = Qt::TableView.new(@dockWidgetContents)
    @tableView.objectName = "tableView"
    @tableView.autoScroll = false
    @tableView.selectionMode = Qt::AbstractItemView::SingleSelection
    @tableView.selectionBehavior = Qt::AbstractItemView::SelectRows
    @tableView.sortingEnabled = true

    @verticalLayout.addWidget(@tableView)

    @dockWidget = Qt::DockWidget.new(@dockWidgetContents)
    @dockWidget.objectName = "dockWidget"
    @dockWidget.features = Qt::DockWidget::DockWidgetFloatable|Qt::DockWidget::DockWidgetMovable
    @dockWidget.allowedAreas = Qt::BottomDockWidgetArea
    @dockWidgetContents_2 = Qt::Widget.new(@dockWidget)
    @dockWidgetContents_2.objectName = "dockWidgetContents_2"
    @verticalLayout_3 = Qt::VBoxLayout.new(@dockWidgetContents_2)
    @verticalLayout_3.objectName = "verticalLayout_3"
    @verticalLayout_3.setContentsMargins(0, 0, 0, 0)
    @textBrowser = Qt::TextBrowser.new(@dockWidgetContents_2)
    @textBrowser.objectName = "textBrowser"

    @verticalLayout_3.addWidget(@textBrowser)

    @dockWidget.setWidget(@dockWidgetContents_2)

    @verticalLayout.addWidget(@dockWidget)


    @verticalLayout_2.addLayout(@verticalLayout)

    dictionary.setWidget(@dockWidgetContents)

    retranslateUi(dictionary)

    Qt::MetaObject.connectSlotsByName(dictionary)
    end # setupUi

    def setup_ui(dictionary)
        setupUi(dictionary)
    end

    def retranslateUi(dictionary)
    dictionary.windowTitle = Qt::Application.translate("Dictionary", "Dictionary", nil, Qt::Application::UnicodeUTF8)
    @dockWidget.windowTitle = Qt::Application.translate("Dictionary", "Lookup", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(dictionary)
        retranslateUi(dictionary)
    end

end

module Ui
    class Dictionary < Ui_Dictionary
    end
end  # module Ui

