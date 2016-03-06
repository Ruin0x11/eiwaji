=begin
** Form generated from reading ui file 'vocab_list.ui'
**
** Created: 土 3月 5 23:13:26 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_VocabListWidget
    attr_reader :dockWidgetContents
    attr_reader :verticalLayout_2
    attr_reader :verticalLayout
    attr_reader :vocabList

    def setupUi(vocabListWidget)
    if vocabListWidget.objectName.nil?
        vocabListWidget.objectName = "vocabListWidget"
    end
    vocabListWidget.resize(400, 300)
    @dockWidgetContents = Qt::Widget.new(vocabListWidget)
    @dockWidgetContents.objectName = "dockWidgetContents"
    @verticalLayout_2 = Qt::VBoxLayout.new(@dockWidgetContents)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @verticalLayout_2.setContentsMargins(0, 0, 0, 0)
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @vocabList = Qt::TreeView.new(@dockWidgetContents)
    @vocabList.objectName = "vocabList"

    @verticalLayout.addWidget(@vocabList)


    @verticalLayout_2.addLayout(@verticalLayout)

    vocabListWidget.setWidget(@dockWidgetContents)

    retranslateUi(vocabListWidget)

    Qt::MetaObject.connectSlotsByName(vocabListWidget)
    end # setupUi

    def setup_ui(vocabListWidget)
        setupUi(vocabListWidget)
    end

    def retranslateUi(vocabListWidget)
    vocabListWidget.windowTitle = Qt::Application.translate("VocabListWidget", "DockWidget", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(vocabListWidget)
        retranslateUi(vocabListWidget)
    end

end

module Ui
    class VocabListWidget < Ui_VocabListWidget
    end
end  # module Ui

