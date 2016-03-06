module Eiwaji
  class VocabListModel < Qt::AbstractListModel
    def initialize(parent)
      super(parent)

      @parent = parent

      @entries = {}
    end

    def read_vocab_list_file(filename)
      @entries = {}
      to_read = File.open(filename, 'r+')
      to_read.each do |line|
        seq, votes, date = line.split(':')
        entry = @parent.search("seq:#{seq}")[0]
        @entries[seq] = VocabListEntry.new(entry, votes, date)
      end
    end

    def write_vocab_list_file(filename)
      to_write = File.open(filename, 'w+')
      @entries.each do |_, entry|
        to_write.puts(entry.to_index)
      end
      to_write.close
    end

    def add_or_upvote_entry(entry)
      if @entries.key?(entry.sequence_number)
        @entries[entry.sequence_number].votes += 1
      else
        @entries[entry.sequence_number] = VocabListEntry.new(entry)
      end
    end

    def data(index, role = Qt::DisplayRole)
      invalid = Qt::Variant.new
      return invalid unless role == Qt::DisplayRole
      return invalid if @entries.empty?
      return invalid if @entries.size <= index.row
      return invalid unless index.isValid
      entry = @entries.values[index.row]

      v = case index.column
          when 0
            unless entry.kanji.empty?
              if entry.kanji.is_a?(Array)
                entry.kanji.join(', ')
              else
                entry.kanji
              end
            end
          when 1
            entry.votes
          else
            raise "invalid column #{index.column}"
          end || ''
      Qt::Variant.new(v)
    end

    def columnCount
      2
    end
    

    def rowCount
      @entries.size
    end
  end

  class VocabListEntry < JDict::Entry
    attr_accessor :votes, :date_added

    def initalize(entry, votes, date_added)
      super(entry.sequence_number, entry.kanji, entry.kana, entry.senses)
      self.votes = votes
      self.date_added = date_added
    end

    def initialize(entry)
      super(entry, 1, Time.now)
    end

    def to_index
      "#{sequence_number}:#{votes}:#{date_added.strftime('%s')}"
    end
  end
end
