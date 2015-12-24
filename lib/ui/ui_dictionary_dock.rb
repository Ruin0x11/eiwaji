=begin
** Form generated from reading ui file 'dictionary_dock.ui'
**
** Created: 土 12 12 17:57:15 2015
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_DictionaryWidget
    attr_reader :dockWidgetContents
    attr_reader :verticalLayout_2
    attr_reader :searchBox
    attr_reader :verticalLayout
    attr_reader :searchResults
    attr_reader :dockWidget
    attr_reader :dockWidgetContents_2
    attr_reader :verticalLayout_3
    attr_reader :wordDetails

    def setupUi(dictionaryWidget)
    if dictionaryWidget.objectName.nil?
        dictionaryWidget.objectName = "dictionaryWidget"
    end
    dictionaryWidget.resize(500, 500)
    dictionaryWidget.minimumSize = Qt::Size.new(420, 400)
    dictionaryWidget.features = Qt::DockWidget::DockWidgetFloatable|Qt::DockWidget::DockWidgetMovable
    dictionaryWidget.allowedAreas = Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea
    @dockWidgetContents = Qt::Widget.new(dictionaryWidget)
    @dockWidgetContents.objectName = "dockWidgetContents"
    @verticalLayout_2 = Qt::VBoxLayout.new(@dockWidgetContents)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @verticalLayout_2.setContentsMargins(0, 0, 0, 0)
    @searchBox = Qt::LineEdit.new(@dockWidgetContents)
    @searchBox.objectName = "searchBox"
    @font = Qt::Font.new
    @font.pointSize = 11
    @searchBox.font = @font

    @verticalLayout_2.addWidget(@searchBox)

    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @searchResults = Qt::TableView.new(@dockWidgetContents)
    @searchResults.objectName = "searchResults"
    @searchResults.minimumSize = Qt::Size.new(300, 200)
    @searchResults.autoScroll = false
    @searchResults.selectionMode = Qt::AbstractItemView::SingleSelection
    @searchResults.selectionBehavior = Qt::AbstractItemView::SelectRows
    @searchResults.sortingEnabled = true

    @verticalLayout.addWidget(@searchResults)

    @dockWidget = Qt::DockWidget.new(@dockWidgetContents)
    @dockWidget.objectName = "dockWidget"
    @dockWidget.features = Qt::DockWidget::DockWidgetFloatable|Qt::DockWidget::DockWidgetMovable
    @dockWidget.allowedAreas = Qt::BottomDockWidgetArea
    @dockWidgetContents_2 = Qt::Widget.new(@dockWidget)
    @dockWidgetContents_2.objectName = "dockWidgetContents_2"
    @verticalLayout_3 = Qt::VBoxLayout.new(@dockWidgetContents_2)
    @verticalLayout_3.objectName = "verticalLayout_3"
    @verticalLayout_3.setContentsMargins(0, 0, 0, 0)
    @wordDetails = Qt::TextBrowser.new(@dockWidgetContents_2)
    @wordDetails.objectName = "wordDetails"
    @font1 = Qt::Font.new
    @font1.pointSize = 12
    @wordDetails.font = @font1

    @verticalLayout_3.addWidget(@wordDetails)

    @dockWidget.setWidget(@dockWidgetContents_2)

    @verticalLayout.addWidget(@dockWidget)


    @verticalLayout_2.addLayout(@verticalLayout)

    dictionaryWidget.setWidget(@dockWidgetContents)

    retranslateUi(dictionaryWidget)

    Qt::MetaObject.connectSlotsByName(dictionaryWidget)
    end # setupUi

    def setup_ui(dictionaryWidget)
        setupUi(dictionaryWidget)
    end

    def retranslateUi(dictionaryWidget)
    dictionaryWidget.windowTitle = Qt::Application.translate("DictionaryWidget", "Dictionary", nil, Qt::Application::UnicodeUTF8)
    @dockWidget.windowTitle = Qt::Application.translate("DictionaryWidget", "Lookup", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(dictionaryWidget)
        retranslateUi(dictionaryWidget)
    end

end

module Ui
    class DictionaryWidget < Ui_DictionaryWidget
    end
end  # module Ui

