# -*- coding: utf-8 -*-
module Eiwaji
  class VocabListWidget < Qt::DockWidget
    def initialize(parent)
      super(parent)

      @parent = parent

      @ui = Ui_VocabListWidget.new
      @ui.setupUi(self)

      @vocab_list = VocabListModel.new(self)
      entry = search("猫")[0]
      @vocab_list.add_or_upvote_entry(entry)
      @vocab_list.add_or_upvote_entry(entry)
    end

    def search(query, lemma = nil)
      @parent.search(query, lemma)
    end
  end
end
