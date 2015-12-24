module Eiwaji
  class DictionaryTableModel < Qt::AbstractTableModel
    def initialize(parent, entries, lemma)
      super(parent)
      @white = Text::WhiteSimilarity.new
      @entries = entries
      @lemma = lemma
      calcSimilarityForAll
    end

    def calcSimilarityForAll
      @sim = Array.new(@entries.size)
      @entries.each_with_index do |entry, i|
        similarity = 0.0
        # if there are multiple kana/kanji readings, get the highest similarity out of each
        unless entry.kana.nil?
          if entry.kana.kind_of?(Array)
            similarity += entry.kana.inject(0.0) do |max, k|
              sim = calcSimilarity(k)
              [max, sim].max
            end
          else
            similarity += calcSimilarity(entry.kana)
          end
        end

        unless entry.kanji.nil?
          if entry.kanji.kind_of?(Array)
            similarity += entry.kanji.inject(0.0) do |max, k|
              sim = calcSimilarity(k)
              [max, sim].max
            end
          else
            similarity += calcSimilarity(entry.kanji)
          end
        end
        @sim[i] = similarity
      end
    end

    def columnCount(parent)
      4
    end

    def rowCount(parent)
      if parent.valid?
        return 0
      else
        return @entries.size
      end
    end

    def flags(index)
      Qt::ItemIsSelectable | Qt::ItemIsEnabled
    end

    def data(index, role=Qt::DisplayRole)
      invalid = Qt::Variant.new
      return invalid unless role == Qt::DisplayRole
      return invalid if @entries.empty?
      return invalid if @entries.size <= index.row
      return invalid unless index.isValid
      entry = @entries[index.row]

      v = case index.column
          when 0 # kanji
            if not entry.kanji.empty?
              if entry.kanji.kind_of?(Array)
                entry.kanji.map {|k| k.force_encoding("UTF-8") }.join(', ')
              else
                entry.kanji.force_encoding("UTF-8")
              end
            end
          when 1 # kana
            entry.kana.map {|k| k.force_encoding("UTF-8") }.join(', ') unless entry.kana.nil?
          when 2 # sense
            if entry.senses.size > 1
              sense = entry.senses.map.with_index(1) do |s, i|
                pos = s.parts_of_speech.nil? ? "" : "(" + s.parts_of_speech.join(", ") + ") "
                glosses = s.glosses.join(", ")
                pos + glosses
              end
              sense.reverse.join(" \n ")
            else
              s = entry.senses.first
              pos = s.parts_of_speech.nil? ? "" : "(" + s.parts_of_speech.join(", ") + ") "
              glosses = s.glosses.join(", ")
              pos + glosses
            end
          when 3 # similarity
            @sim[index.row]
          else 
            raise "invalid column #{index.column}"
          end || ""
      return Qt::Variant.new(v)
    end

    def calcSimilarity(word)
      w = word.force_encoding("UTF-8")
      sim = @white.similarity(@lemma, w) 
      if sim.nan?
        sim = (@lemma == w ? 1.0 : 0.0)
      end
      sim
    end
    
    def headerData(section, orientation, role=Qt::DisplayRole)
      return Qt::Variant.new if role != Qt::DisplayRole
      v = case orientation
          when Qt::Horizontal
            ["Kanji","Kana","Meaning","Similarity"][section]
          else
            section.to_s
          end
      return Qt::Variant.new(v)
    end
  end
end
