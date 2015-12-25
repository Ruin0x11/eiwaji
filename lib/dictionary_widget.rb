require 'jdict'

require_relative 'ui/ui_dictionary_dock'
require_relative 'dictionary_model'

module Eiwaji
  class DictionaryWidget < Qt::DockWidget

    slots 'updateSortIndex(int)', 'getWordDetailsAtIndex(QModelIndex)', 'queryEntered()', 'getWordDetails()'
    
    def initialize(parent)
      super(parent)

      @ui = Ui_DictionaryWidget.new
      @ui.setupUi(self)

      @dict = JDict::JMDict.new()
      @white = Text::WhiteSimilarity.new
      connect(@ui.searchResults, SIGNAL('activated(QModelIndex)'), self, SLOT('getWordDetailsAtIndex(QModelIndex)'))
      connect(@ui.searchResults, SIGNAL('clicked(QModelIndex)'), self, SLOT('getWordDetailsAtIndex(QModelIndex)'))

      connect(@ui.searchBox, SIGNAL('returnPressed()'), self, SLOT('queryEntered()'))
    end

    def reset
      @dict = JDict::JMDict.new()
    end

    def queryEntered
      query = @ui.searchBox.text.force_encoding("UTF-8")
      search(query)
    end

    def updateSortIndex(index)
      @ui.searchResults.sortByColumn(index)
    end

    def getWordDetailsAtIndex(index)
      row = index.row
      getWordDetails(row)
    end

    def getWordDetails(row)
      resultIndex = @ui.searchResults.model.index(row, 0)
      kanji = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      resultIndex = @ui.searchResults.model.index(row, 1)
      kana = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      resultIndex = @ui.searchResults.model.index(row, 2)
      sense = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      kanji = (kanji.nil? ? "" : kanji.force_encoding("UTF-8"))
      kana = (kana.nil? ? "" : kana.force_encoding("UTF-8"))
      sense = (sense.nil? ? "" : sense.force_encoding("UTF-8"))
      @ui.wordDetails.setText("Kanji: " + kanji + "\nKana: " + kana + "\nSense: " + sense)
    end

    # searches the JDict::JMDict for the given query, and sorts results by similarity to the provided lemma
    def search(query, lemma = nil)
      lemma ||= query

      @ui.searchBox.setText(query)
      
      results = @dict.search(query)

      @ui.searchResults.model = Qt::SortFilterProxyModel.new(@ui.searchResults)
      @ui.searchResults.model.source_model = DictionaryTableModel.new(self, results, lemma)

      connect(@ui.searchResults.horizontalHeader, SIGNAL('sectionClicked(int)'), self, SLOT('updateSortIndex(int)'))
      @ui.searchResults.horizontalHeader.setVisible(true)
      @ui.searchResults.verticalHeader.setVisible(false)

      
      # sort by similarity
      updateSortIndex(3)

      if results.size > 0
        getWordDetails(0)
      else
        @ui.wordDetails.clear
      end
    end
  end
end
