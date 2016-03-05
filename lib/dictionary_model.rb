module Eiwaji
  class DictionaryTableModel < Qt::AbstractTableModel
    def initialize(parent, entries, lemma)
      super(parent)
      @white = Text::WhiteSimilarity.new
      @entries = entries
      @lemma = lemma
      calc_all_similarities
    end

    def calc_all_similarities
      @sim = Array.new(@entries.size)
      @entries.each_with_index do |entry, i|
        similarity = 0.0
        # if there are multiple kana/kanji readings,
        #get the highest similarity out of each
        unless entry.kana.nil?
          if entry.kana.is_a?(Array)
            similarity += entry.kana.inject(0.0) do |max, k|
              sim = calc_similarity(k)
              [max, sim].max
            end
          else
            similarity += calc_similarity(entry.kana)
          end
        end

        unless entry.kanji.nil?
          if entry.kanji.is_a?(Array)
            similarity += entry.kanji.inject(0.0) do |max, k|
              sim = calc_similarity(k)
              [max, sim].max
            end
          else
            similarity += calc_similarity(entry.kanji)
          end
        end
        @sim[i] = similarity
      end
    end

    def columnCount(parent)
      4
    end

    def rowCount(parent)
      return 0 if parent.valid?
      @entries.size
    end

    def flags(index)
      Qt::ItemIsSelectable | Qt::ItemIsEnabled
    end

    def data(index, role = Qt::DisplayRole)
      invalid = Qt::Variant.new
      return invalid unless role == Qt::DisplayRole
      return invalid if @entries.empty?
      return invalid if @entries.size <= index.row
      return invalid unless index.isValid
      entry = @entries[index.row]

      v = case index.column
          when Eiwaji::Constants::KANJI_COLUMN
            unless entry.kanji.empty?
              if entry.kanji.is_a?(Array)
                entry.kanji.join(', ')
              else
                entry.kanji
              end
            end
          when Eiwaji::Constants::KANA_COLUMN
            entry.kana.join(', ') unless entry.kana.nil?
          when Eiwaji::Constants::SENSE_COLUMN
            if entry.senses.size > 1
              sense = entry.senses.map.with_index(1) do |s, _|
                pos = s.parts_of_speech.nil? ? '' : '(' + s.parts_of_speech.join(', ') + ') '
                glosses = s.glosses.join(', ')
                pos + glosses
              end
              sense.reverse.join(" \n ")
            else
              s = entry.senses.first
              pos = s.parts_of_speech.nil? ? '' : '(' + s.parts_of_speech.join(', ') + ') '
              glosses = s.glosses.join(', ')
              pos + glosses
            end
          when Eiwaji::Constants::SIMILARITY_COLUMN
            @sim[index.row]
          else
            raise "invalid column #{index.column}"
          end || ''
      Qt::Variant.new(v)
    end

    def calc_similarity(word)
      w = word.force_encoding('UTF-8')
      sim = @white.similarity(@lemma, w)
      sim = (@lemma == w ? 1.0 : 0.0) if sim.nan?
      sim
    end

    def headerData(section, orientation, role = Qt::DisplayRole)
      return Qt::Variant.new if role != Qt::DisplayRole
      v = case orientation
          when Qt::Horizontal
            %w(Kanji Kana Meaning Similarity)[section]
          else
            section.to_s
          end
      Qt::Variant.new(v)
    end
  end
end
