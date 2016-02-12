require 'jdict'

require_relative 'ui/ui_dictionary_dock'
require_relative 'dictionary_model'

module Eiwaji
  class DictionaryWidget < Qt::DockWidget

    slots 'updateSortIndex(int)', 'getWordDetailsAtIndex(QModelIndex)', 'queryEntered()', 'getWordDetails()'

    KANJI_COLUMN =      0
    KANA_COLUMN  =      1
    SENSE_COLUMN =      2
    SIMILARITY_COLUMN = 3
    
    def initialize(parent)
      super(parent)

      @ui = Ui_DictionaryWidget.new
      @ui.setupUi(self)

      if not File.exists? Eiwaji::Constants::INDEX_FILE
        Qt::MessageBox.information(self, tr("No Index"),
                    tr("No index file detected. Please wait while the index is built."))
      end

      reset()
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

    # retrieve word data from a row of the search results model
    def getWordDetails(row)
      resultIndex = @ui.searchResults.model.index(row, KANJI_COLUMN)
      kanji = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      resultIndex = @ui.searchResults.model.index(row, KANA_COLUMN)
      kana = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      resultIndex = @ui.searchResults.model.index(row, SENSE_COLUMN)
      sense = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      kanji = (kanji.nil? ? "" : kanji)
      kana = (kana.nil? ? "" : kana)
      sense = (sense.nil? ? "" : sense)
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
      @ui.searchResults.horizontalHeader.resizeSection(SENSE_COLUMN, 200)

      # sort by similarity
      updateSortIndex(SIMILARITY_COLUMN)

      if results.size > 0
        getWordDetails(0)
      else
        @ui.wordDetails.clear
      end
    end
  end
end
