require 'jdict'

require_relative 'ui/ui_dictionary_dock'
require_relative 'dictionary_model'

module Eiwaji
  class DictionaryWidget < Qt::DockWidget
    slots 'update_sort_index(int)', 'get_word_details_at(QModelIndex)',
          'query_entered()', 'get_word_details()'

    def initialize(parent)
      super(parent)

      @ui = Ui_DictionaryWidget.new
      @ui.setupUi(self)

      unless File.exist? Eiwaji::Constants::INDEX_FILE
        Qt::MessageBox.information(self, tr('No Index'),
                                   tr('No index file detected. Please' \
                                      'wait while the index is built.'))
      end

      reset

      @white = Text::WhiteSimilarity.new
      connect(@ui.searchResults, SIGNAL('activated(QModelIndex)'),
              self, SLOT('get_word_details_at(QModelIndex)'))
      connect(@ui.searchResults, SIGNAL('clicked(QModelIndex)'),
              self, SLOT('get_word_details_at(QModelIndex)'))
      connect(@ui.searchBox, SIGNAL('returnPressed()'),
              self, SLOT('query_entered()'))
    end

    def reset
      @dict = JDict::JMDict.new
    end

    def query_entered
      query = @ui.searchBox.text.force_encoding('UTF-8')
      search(query)
    end

    def update_sort_index(index)
      @ui.searchResults.sortByColumn(index)
    end

    def get_word_details_at(index)
      row = index.row
      get_word_details(row)
    end

    # retrieve word data from a row of the search results model
    def get_word_details(row)
      result_index = @ui.searchResults.model.index(row, Eiwaji::Constants::KANJI_COLUMN)
      kanji = @ui.searchResults.model.data(result_index, Qt::DisplayRole).value

      result_index = @ui.searchResults.model.index(row, Eiwaji::Constants::KANA_COLUMN)
      kana = @ui.searchResults.model.data(result_index, Qt::DisplayRole).value

      result_index = @ui.searchResults.model.index(row, Eiwaji::Constants::SENSE_COLUMN)
      sense = @ui.searchResults.model.data(result_index, Qt::DisplayRole).value

      kanji = '' if kanji.nil?
      kana = '' if kana.nil?
      sense = '' if sense.nil?
      @ui.wordDetails.setText('Kanji: ' + kanji + "\nKana: " + kana +
                              "\nSense: " + sense)
    end

    # searches the JDict::JMDict for the given query,
    # and sorts results by similarity to the provided lemma
    def search(query, lemma = nil)
      lemma ||= query

      @ui.searchBox.setText(query)

      results = @dict.search(query)

      @ui.searchResults.model = Qt::SortFilterProxyModel.new(@ui.searchResults)
      @ui.searchResults.model.source_model =
        DictionaryTableModel.new(self, results, lemma)

      connect(@ui.searchResults.horizontalHeader, SIGNAL('sectionClicked(int)'),
              self, SLOT('update_sort_index(int)'))
      @ui.searchResults.horizontalHeader.setVisible(true)
      @ui.searchResults.verticalHeader.setVisible(false)
      @ui.searchResults.horizontalHeader.resizeSection(Eiwaji::Constants::SENSE_COLUMN, 200)

      # sort by similarity
      update_sort_index(Eiwaji::Constants::SIMILARITY_COLUMN)

      if results.empty?
        get_word_details(0)
      else
        @ui.wordDetails.clear
      end
      # results
    end
  end
end
