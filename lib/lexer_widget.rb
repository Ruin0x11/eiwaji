# -*- coding: utf-8 -*-
require 've'

require_relative 'ui/ui_lexer'

module Eiwaji
  class LexerWidget < Qt::DockWidget

    POS_IGNORE = [Ve::PartOfSpeech::Symbol] # parts-of-speech to not provide links for
    HISTORY_STRING_LENGTH = 30
    MAX_HISTORY_ITEMS = 10

    slots 'wordClicked(QUrl)', 'historyItemChanged(int)', 'historyPrev()', 'historyNext()'

    def initialize(parent)
      super(parent)
      
      @ui = Ui_LexerWidget.new
      @ui.setupUi(self)

      part_of_speech_colors

      connect(@ui.lexerTextBrowser, SIGNAL('anchorClicked(QUrl)'),
              self, SLOT('wordClicked(QUrl)'))

      @ui.historyBox.insertItem(0, "...")
      connect(@ui.historyBox, SIGNAL('currentIndexChanged(int)'), self, SLOT('historyItemChanged(int)'))
      connect(@ui.buttonNext, SIGNAL('clicked()'), self, SLOT('historyNext()'))
      connect(@ui.buttonPrev, SIGNAL('clicked()'), self, SLOT('historyPrev()'))
    end

    def textBrowser
      @ui.textBrowser
    end

    def event(event)
      # provide tooltips for word part-of-speech when mousing over hrefs
      if event.type == Qt::Event::ToolTip
        cursor = @ui.lexerTextBrowser.cursorForPosition(event.pos)
        cursor.select(Qt::TextCursor::WordUnderCursor)
        fragment = cursor.selection()

        hrefRegex = /<a\s+(?:[^>]*?\s+)?href="([^"]*)"/
        resultsIndex = hrefRegex.match(fragment.toHtml)

        if not resultsIndex or resultsIndex.size != 2
          Qt::ToolTip.hideText
        else
          word = @lexer_results[resultsIndex[1].to_i]
          Qt::ToolTip.showText(event.globalPos(), word.lemma + " " + word.part_of_speech.name)
        end
      end
      super(event)
    end

    def historyItemChanged(index)
      return if index == 0
      text = @ui.historyBox.itemData(index).value
      lexText(text)
    end

    def historyPrev
      index = @ui.historyBox.currentIndex + 1
      index += 1 if @ui.historyBox.currentIndex == 0
      index = @ui.historyBox.count - 1 if index >= @ui.historyBox.count - 1
      @ui.historyBox.setCurrentIndex(index)
    end

    def historyNext
      index = @ui.historyBox.currentIndex - 1
      index = 1 if index < 1
      @ui.historyBox.setCurrentIndex(index)
    end

    def lexText(text, append_to_history=false)
      text = text.force_encoding("UTF-8")

      if append_to_history
        @ui.historyBox.setCurrentIndex(0)
        truncated_text = text.size < HISTORY_STRING_LENGTH ? text : text[0..HISTORY_STRING_LENGTH-1] + "..."
        @ui.historyBox.insertItem(1, truncated_text, Qt::Variant.new(text)) 
        @ui.historyBox.removeItem(MAX_HISTORY_ITEMS+1) if @ui.historyBox.count > MAX_HISTORY_ITEMS+1
      end

      words = Ve.in(:ja).words(text)

      @lexer_results = Hash.new
      words.map.with_index {|word, i| @lexer_results[i] = word }

      # associate search result indexes with HTML links
      html = words.map.with_index {|word, i| text = wordToHtml(word, i)}.join(' ')

      @ui.lexerTextBrowser.setText(html)
    end

    def wordClicked(url)
      searchWord(url.path.to_i)
    end

    def searchWord(ref)
      raise "No results from the lexer." if @lexer_results.empty?
      word = @lexer_results[ref]

      # Word lemma
      # since the lemmas of Words like "1話" become "*話", remove extra '*'s
      lemma = word.lemma.tr('*','')

      # raw token, drops "する" and other extra parts
      query = word.tokens[0][:lemma]
      query = lemma if query == "*"

      p word

      # search on the query and sort by the results most similar to the lemma
      parent.search(query, lemma)
    end
    

    # def part_of_speech_colors
    #   @part_of_speech_colors ||= {
    #                               :verb => "#B58900",
    #                               :noun => "#93A1A1",
    #                               :proper_noun => "#268BD2",
    #                               :symbol => "#839496",
    #                               :postposition => "#CB4B16",
    #                               :pronoun => "#D33682",
    #                               :background => "#002B36",
    #                               :default => "#839496"
    #                              }
    # end

    def part_of_speech_colors
      @part_of_speech_colors ||= {
        :verb => "#808080",
        :noun => "#000000",
        :proper_noun => "#0000FF",
        :symbol => "#000000",
        :postposition => "#FF0000",
        :pronoun => "#008080",
        :adjective => "#008000",
        :adverb => "#43C6DB",
        :conjunction => "#FFA500",
        :background => "#FFFFFF",
        :default => "#FF00FF"
      }
    end

    # converts a Ve::Word and its index in the search results to a String representation
    def wordToHtml(word, index)
      raw = word.word
      pos = word.part_of_speech
      color = @part_of_speech_colors[pos.name.gsub(' ', '_').underscore.to_sym] || @part_of_speech_colors[:default]
      
      if POS_IGNORE.include? pos
        raw = "<font style='color: #{color}'>" + raw + "</font>"
      else
        raw = "<a href=\'#{index}\' style='color: #{color}'>" + raw + "</a>"
      end
    end
  end
end
