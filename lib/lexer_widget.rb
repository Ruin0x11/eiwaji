require_relative 'ui/ui_lexer'

module Eiwaji
  class LexerWidget < Qt::DockWidget

    slots 'wordClicked(QUrl)'

    def initialize(parent)
      super(parent)
      
      @ui = Ui_Lexer.new
      @ui.setupUi(self)

      connect(@lexerView, SIGNAL('anchorClicked(QUrl)'),
              self, SLOT('wordClicked(QUrl)'))

      p getParent.methods
    end

    def textBrowser
      @ui.textBrowser
    end

    def wordClicked(url)
      raise "No results from the lexer." if @lexerResults.empty?

      word = @lexerResults[url.path.to_i]
      pp word
      query = word.tokens[0][:lemma]
      lemma = word.lemma
      @dictQuery.setText(query)
      search(query, lemma)
    end
  end
end
