# -*- coding: utf-8 -*-
require_relative 'ui/ui_vocab_list'
require_relative 'vocab_list_model'

module Eiwaji
  class VocabListWidget < Qt::DockWidget
    def initialize(parent)
      super(parent)

      @ui = Ui_VocabListWidget.new
      @ui.setupUi(self)

      @parent = parent

      @entries = {}

      e = JDict::Entry.new(0, "猫", "ねこ", 'cat')
      add_or_upvote_entry(e)
      add_or_upvote_entry(e)
      e = JDict::Entry.new(1, "犬", "いぬ", 'dog')
      add_or_upvote_entry(e)
      update_model
    end

    def update_model
      @ui.vocabList.model = Qt::SortFilterProxyModel.new(@ui.vocabList)
      @ui.vocabList.model.source_model = VocabListModel.new(self, @entries)
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

    def search(query, lemma = nil)
      @parent.search(query, lemma)
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
      super(entry.sequence_number, entry.kanji, entry.kana, entry.senses)
      self.votes = 1
      self.date_added = Time.now
    end

    def to_index
      "#{sequence_number}:#{votes}:#{date_added.strftime('%s')}"
    end
  end
end
