require 'ruby-jdict'

module Eiwaji
  class DictionaryWidget < Qt::DockWidget

    slots 'updateSortIndex(int)', 'getWordDetailsAtIndex(QModelIndex)', 'queryEntered()', 'getWordDetails()'

    KANJI_COLUMN =      0
    KANA_COLUMN  =      1
    SENSE_COLUMN =      2
    SIMILARITY_COLUMN = 3

    def initialize(parent)
      super(parent)

      @settings ||= Qt::Settings.new(Eiwaji::Constants::CONFIG_PATH, Qt::Settings::IniFormat)

      @ui = Ui_DictionaryWidget.new
      @ui.setupUi(self)

      load_dictionary

      @white = Text::WhiteSimilarity.new
      connect(@ui.searchResults, SIGNAL('activated(QModelIndex)'), self, SLOT('getWordDetailsAtIndex(QModelIndex)'))
      connect(@ui.searchResults, SIGNAL('clicked(QModelIndex)'), self, SLOT('getWordDetailsAtIndex(QModelIndex)'))

      connect(@ui.searchBox, SIGNAL('returnPressed()'), self, SLOT('queryEntered()'))
    end

    def reset
      @dict.delete! if @dict
    end

    def load_dictionary
      unless File.exists? Eiwaji::Constants::DICTIONARY_PATH
        Qt::MessageBox.critical(self, tr("No Index"), tr("No dictionary was found at #{Eiwaji::Constants::DICTIONARY_PATH}"))
        return false
      end

      @dict = JDict::Dictionary.new(Eiwaji::Constants::DICTIONARY_PATH)

      if not @dict.loaded?
        Qt::MessageBox.information(self, tr("No Index"),
                    tr("No index file detected. Please wait while the index is built."))

        progress_dialog = Qt::ProgressDialog.new(self)
        progress_dialog.windowTitle = tr("Rebuilding Index")
        progress_dialog.labelText = tr("Rebuilding index...")
        progress_dialog.show
        progress_dialog.raise

        @dict.build_index! do |entries, total|
          progress_dialog.value = entries
          progress_dialog.maximum = total
        end

        progress_dialog.hide
      end

      @settings.sync

      true
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
      text = "Kanji: " + kanji + "\nKana: " + kana + "\nSense: " + sense
      @ui.wordDetails.setText(text.force_encoding("UTF-8"))
    end

    # searches the JDict::Dictionary for the given query, and sorts results by similarity to the provided lemma
    def search(query, lemma = nil)
      load_dictionary if not @dict

      lemma ||= query

      @ui.searchBox.setText(query)

      language = @settings.value("language").toString.to_sym
      max_results = @settings.value("num_results").toString.to_sym

      results = @dict.search(query, language: language, max_results: max_results)

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
