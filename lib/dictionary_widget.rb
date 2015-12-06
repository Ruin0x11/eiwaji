require 'jdict'
require 'jmdict'

require_relative 'ui/ui_dictionary_dock'

module Eiwaji
  class DictionaryWidget < Qt::DockWidget

    slots 'updateSortIndex(int)', 'queryEntered()'
    def initialize(parent)
      super(parent)

      @ui = Ui_DictionaryWidget
      @ui.setupUi(self)

      @dict = JDict::JMDict.new()
      
      connect(@entryResults, SIGNAL('sectionClicked(int)'), self, SLOT('updateSortIndex(int)'))
      connect(@entryResults, SIGNAL('clicked(QModelIndex)'), self, SLOT('getWordDetails(QModelIndex)'))

      # @dictQuery = Qt::LineEdit.new
      # connect(@dictQuery, SIGNAL('returnPressed()'), self, SLOT('queryEntered()'))
    end

    def queryEntered()
      query = @dictQuery.text
      search(query)
    end

    def updateSortIndex(index)
      @entryResults.sortByColumn(index)
    end

    def search(query, lemma = nil)
      lemma ||= query
      # else
      #   query = word.lemma
      # end
      results = @dict.search(query)

      model = Qt::StandardItemModel.new(results.size, 4)
      model.setHeaderData(0, Qt::Horizontal, Qt::Variant.new(tr("Kanji")))
      model.setHeaderData(1, Qt::Horizontal, Qt::Variant.new(tr("Kana")))
      model.setHeaderData(2, Qt::Horizontal, Qt::Variant.new(tr("Sense")))
      model.setHeaderData(3, Qt::Horizontal, Qt::Variant.new(tr("Similarity")))
      # @entryResults.model = model

      # connect(@entryResults.horizontalHeader, SIGNAL('sectionClicked(int)'), self, SLOT('updateSortIndex(int)'))
      
      results.each_with_index do |entry, row|
        # if entry.kanji.kind_of?(Array)
        #   entry.kanji.each {|kanji| p kanji.force_encoding("UTF-8")}
        # else
        #   p entry.kanji.force_encoding("UTF-8")
        # end
        # entry.kana.each {|kana| p kana.force_encoding("UTF-8")}
        # entry.senses.each {|sense| pp sense.glosses[0] }
        if not entry.kanji.empty?
          if entry.kanji.kind_of?(Array)
            kanji = entry.kanji[0].force_encoding("UTF-8")
          else
            kanji = entry.kanji.force_encoding("UTF-8")
          end
          index = model.index(row, 0, Qt::ModelIndex.new)
          model.setData(index, Qt::Variant.new(kanji))
        end

        kana = entry.kana[0].force_encoding("UTF-8")
        index = model.index(row, 1, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(kana))

        sense = entry.senses[0].glosses.join(", ")
        pos = entry.senses[0].parts_of_speech
        # sense = pos.join(" / ") + " " + sense unless pos.nil?
        index = model.index(row, 2, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(sense))

        similarity = (@white.similarity(lemma, kana))
        similarity += (@white.similarity(lemma, kanji)) unless kanji.nil?
        index = model.index(row, 3, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(similarity))
      end
      # sort by similarity
      # @entryResults.sortByColumn(3)
    end

    
  end
end
