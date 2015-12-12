require 'jdict'

require_relative 'ui/ui_dictionary_dock'

module Eiwaji
  class DictionaryWidget < Qt::DockWidget

    slots 'updateSortIndex(int)', 'queryEntered()', 'getWordDetails(QModelIndex)'
    
    def initialize(parent)
      super(parent)

      @ui = Ui_DictionaryWidget.new
      @ui.setupUi(self)

      @dict = JDict::JMDict.new()
      @white = Text::WhiteSimilarity.new
      
      connect(@ui.searchResults, SIGNAL('sectionClicked(int)'), self, SLOT('updateSortIndex(int)'))
      connect(@ui.searchResults, SIGNAL('activated(QModelIndex)'), self, SLOT('getWordDetails(QModelIndex)'))
      connect(@ui.searchResults, SIGNAL('clicked(QModelIndex)'), self, SLOT('getWordDetails(QModelIndex)'))

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

    def getWordDetails(index)
      row = index.row

      resultIndex = @ui.searchResults.model.index(row, 0)
      kanji = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      resultIndex = @ui.searchResults.model.index(row, 1)
      kana = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      resultIndex = @ui.searchResults.model.index(row, 2)
      sense = @ui.searchResults.model.data(resultIndex, Qt::DisplayRole).value
      kanji = (kanji.nil? ? "" : kanji.force_encoding("UTF-8"))
      kana = (kana.nil? ? "" : kana.force_encoding("UTF-8"))
      meaning = (meaning.nil? ? "" : meaning.force_encoding("UTF-8"))
      sense = (sense.nil? ? "" : sense.force_encoding("UTF-8"))
      @ui.wordDetails.setText("Kanji: " + kanji + "\nKana: " + kana + "\nSense: " + sense)
    end

    def search(query, lemma = nil)
      lemma ||= query

      @ui.searchBox.setText(query)
      
      results = @dict.search(query)

      model = Qt::StandardItemModel.new(results.size, 4)
      model.setHeaderData(0, Qt::Horizontal, Qt::Variant.new(tr("Kanji")))
      model.setHeaderData(1, Qt::Horizontal, Qt::Variant.new(tr("Kana")))
      model.setHeaderData(2, Qt::Horizontal, Qt::Variant.new(tr("Sense")))
      model.setHeaderData(3, Qt::Horizontal, Qt::Variant.new(tr("Similarity")))
      @ui.searchResults.model = model

      connect(@ui.searchResults.horizontalHeader, SIGNAL('sectionClicked(int)'), self, SLOT('updateSortIndex(int)'))
      
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

        kana = entry.kana.map {|k| k.force_encoding("UTF-8") }.join(', ')
        index = model.index(row, 1, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(kana))

        if entry.senses.size > 1
          sense = entry.senses.map.with_index(1) do |s, i|
            pos = s.parts_of_speech.nil? ? "" : "(" + s.parts_of_speech.join(", ") + ") "
            glosses = s.glosses.join(", ")
            pos + glosses
          end
          
          sense = sense.reverse.join(" \n ")
        else
          s = entry.senses.first
          pos = s.parts_of_speech.nil? ? "" : "(" + s.parts_of_speech.join(", ") + ") "
          glosses = s.glosses.join(", ")
          sense = pos + glosses
        end
        
        index = model.index(row, 2, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(sense))

        pos = entry.senses[0].parts_of_speech
        pos = pos.join(" / ") unless pos.nil?
        index = model.index(row, 3, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(pos))

        similarity = kana.split(",").inject(0.0) do |max, k|
          sim = @white.similarity(lemma, k) 
          if sim.nan?
            sim = (lemma == k ? 1.0 : 0.0)
          end
          [max, sim].max
        end

        # if there are multiple kanji readings, find the most similar one
        unless kanji.nil?
          similarity += kanji.split(",").inject(0.0) do |max, k|
            sim = @white.similarity(lemma, k) 
            if sim.nan?
              sim = (lemma == k ? 1.0 : 0.0)
            end
            [max, sim].max
          end
        end
        
        index = model.index(row, 3, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(similarity))
      end
      # sort by similarity
      updateSortIndex(3)
    end
  end
end
