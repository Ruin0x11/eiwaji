# -*- coding: utf-8 -*-
require 've'

require_relative 'ui/ui_lexer'

module Eiwaji
  class LexerWidget < Qt::DockWidget

    # parts-of-speech to not provide hyperlinks for
    POS_IGNORE = [Ve::PartOfSpeech::Symbol]

    HISTORY_STRING_LENGTH = 30
    MAX_HISTORY_ITEMS = 50

    slots 'word_clicked(QUrl)', 'history_item_changed(int)',
          'previous_history_item()', 'next_history_item()'

    def initialize(parent)
      super(parent)

      @parent = parent
      @ui = Ui_LexerWidget.new
      @ui.setupUi(self)

      part_of_speech_colors

      connect(@ui.lexerTextBrowser, SIGNAL('anchorClicked(QUrl)'),
              self, SLOT('word_clicked(QUrl)'))

      @ui.historyBox.insertItem(0, '...')
      connect(@ui.historyBox, SIGNAL('currentIndexChanged(int)'),
              self, SLOT('history_item_changed(int)'))
      connect(@ui.buttonNext, SIGNAL('clicked()'),
              self, SLOT('next_history_item()'))
      connect(@ui.buttonPrev, SIGNAL('clicked()'),
              self, SLOT('previous_history_item()'))
    end

    def text_browser
      @ui.text_browser
    end

    def event(event)
      # provide tooltips for word part-of-speech when mousing over hrefs
      if event.type == Qt::Event::ToolTip
        cursor = @ui.lexerTextBrowser.cursorForPosition(event.pos)
        cursor.select(Qt::TextCursor::WordUnderCursor)
        fragment = cursor.selection

        # works in this case, since the input is clearly defined in word_to_html
        href_regex = /<a\s+(?:[^>]*?\s+)?href="([^"]*)"/
        results_index = href_regex.match(fragment.toHtml)

        if !results_index || results_index.size != 2
          Qt::ToolTip.hideText
        else
          word = @lexer_results[results_index[1].to_i]
          Qt::ToolTip.showText(event.globalPos, word.lemma + ' ' +
                               word.part_of_speech.name)
        end
      end
      super(event)
    end

    def history_item_changed(index)
      return if index == 0
      text = @ui.historyBox.itemData(index).value
      lex_text(text)
    end

    def previous_history_item
      index = @ui.historyBox.currentIndex + 1
      index += 1 if @ui.historyBox.currentIndex == 0
      index = @ui.historyBox.count - 1 if index >= @ui.historyBox.count - 1
      @ui.historyBox.setCurrentIndex(index)
    end

    def next_history_item
      index = @ui.historyBox.currentIndex - 1
      index = 1 if index < 1
      @ui.historyBox.setCurrentIndex(index)
    end

    def lex_text(text, append_to_history = false)
      text = text.force_encoding('UTF-8')

      if append_to_history
        @ui.historyBox.setCurrentIndex(0)
        truncated_text = text.size < HISTORY_STRING_LENGTH ? text : text[0..HISTORY_STRING_LENGTH - 1] + '...'
        @ui.historyBox.insertItem(1, truncated_text, Qt::Variant.new(text))
        if @ui.historyBox.count > MAX_HISTORY_ITEMS + 1
          @ui.historyBox.removeItem(MAX_HISTORY_ITEMS + 1)
        end
      end

      lines = text.split("\n")
      html_lines = []
      @lexer_results = {}
      i = 0

      lines.each do |line|
        words = Ve.in(:ja).words(line)
        html_words = []

        words.each do |word|
          @lexer_results[i] = word
          html_words << word_to_html(word, i)
          i += 1
        end
        html_lines << "<div style='margin-bottom: 20px'>" \
                      "#{html_words.join(' ')}<\div>"
      end

      html = html_lines.join('')

      @ui.lexerTextBrowser.setText(html)
    end

    def word_clicked(url)
      search_word(url.path.to_i)
    end

    def search_word(ref)
      raise 'No results from the lexer.' if @lexer_results.empty?
      word = @lexer_results[ref]

      # Word lemma
      # since the lemmas of Words like "1話" become "*話", remove extra '*'s
      lemma = word.lemma.tr('*', '')

      # raw token, drops "する" and other extra parts
      query = word.tokens[0][:lemma]
      query = lemma if query == '*'

      status = if word.word == query || lemma == ''
                 word.word
               elsif word.word == lemma || query == lemma
                 word.word + ' -> ' + query
               else
                 word.word + ' -> ' + lemma + ' -> ' + query
               end

      status = status + ' (' + word.part_of_speech.name + ')'

      @parent.show_status_message(status)

      p word, query, lemma if Eiwaji::DEBUG

      # search on the query and sort by the results most similar to the lemma
      parent.search(query, lemma)
    end

    def part_of_speech_colors
      # each symbol represents the class name of a Ve::PartOfSpeech
      @part_of_speech_colors ||= {
        verb:         '#808080',
        noun:         '#000000',
        propernoun:   '#000000',
        symbol:       '#000000',
        postposition: '#FF0000',
        pronoun:      '#000000',
        adjective:    '#000000',
        adverb:       '#000000',
        conjunction:  '#000000',
        determiner:   '#000000',
        background:   '#FFFFFF',
        number:       '#000000',
        prefix:       '#000000',
        suffix:       '#000000',
        default:      '#FF00FF'
      }
    end

    # converts a Ve::Word and its index in the search results
    # to a String representation
    def word_to_html(word, index)
      raw = word.word
      pos = word.part_of_speech
      color = @part_of_speech_colors[pos.name.downcase.to_sym] ||
              @part_of_speech_colors[:default]

      raw = if POS_IGNORE.include? pos
              "<font style='color: #{color}'>" + raw + '</font>'
            else
              "<a href=\'#{index}\' style='color: #{color}'>" + raw + '</a>'
            end
      raw
    end
  end
end
