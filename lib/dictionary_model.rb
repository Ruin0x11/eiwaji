module Eiwaji
  class DictionaryTableModel < Qt::AbstractTablemodel
    def initialize(entries)
      @entries = entries
      @white = Text::WhiteSimilarity.new
      super
    end

    def entries=(entries)
      @entries = entries
      reset
    end

    def columnCount(parent)
      4
    end

    def rowCount(parent)
      @entries.size
    end

    def flags(index)
      Qt::ItemIsSelectable | Qt::ItemIsEnabled
    end

    def data(index, role=Qt::DisplayRole)
      invalid = Qt::Variant.new
      return invalid unless role == Qt::DisplayRole
      entry = @entries[index.row]
      return invalid if entry.nil?

      v = case index.column
          when 0
            if not entry.kanji.empty?
              if entry.kanji.kind_of?(Array)
                entry.kanji.map {|k| k.force_encoding("UTF-8") }.join(', ')
              else
                entry.kanji.force_encoding("UTF-8")
              end
            end
          when 1
            entry.kana.map {|k| k.force_encoding("UTF-8") }.join(', ') unless entry.kana.nil?
          when 2
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
          when 3

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
          end
      
    else 
      raise "invalid column #{index.column}"
    end || ""
    return Qt::Variant.new(v)
  end
  
  def headerData(section, orientation, role=Qt::DisplayRole)
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
