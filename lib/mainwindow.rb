# coding: utf-8
require 'jdict'
require 'jmdict'
require 've'
require 'pp'
require 'text'

require_relative 'tableview'
require_relative 'lexer_widget'
require_relative 'dictionary_widget'

module Eiwaji
  class MainWindow < Qt::MainWindow

    POS_IGNORE = [Ve::PartOfSpeech::Symbol, Ve::PartOfSpeech::Number]

    slots 'lexEditorText()', 'wordClicked(QUrl)', 'queryEntered()', 'updateSortIndex(int)', 'clipboardChanged(QClipboard::Mode)', 'getWordDetails(QModelIndex)'

    def initialize(parent = nil)
      super(parent)

      @ui = Ui_MainWindow.new
      @ui.setupUi(self)

      initLibraries()
      createActions()
      createMenus()
      createStatusBar()
      createDockWindows()

      lexEditorText()
    end

    def initLibraries
      JDict.configure do |config|
        config.dictionary_path = '/home/ruin'
        config.index_path = '/home/ruin/build/index_eiwaji'
        config.lazy_index_loading = false
      end

      part_of_speech_colors()

      clipboard = Qt::Application.clipboard
      connect(clipboard, SIGNAL('changed(QClipboard::Mode)'), self, SLOT('clipboardChanged(QClipboard::Mode)'))

      @white = Text::WhiteSimilarity.new
    end
    
    def lexEditorText
      text = @lexer_widget.textBrowser.toPlainText
      lexText(text)
    end

    def lexText(text)
      text = text.force_encoding("UTF-8")

      words = Ve.in(:ja).words(text)

      @lexerResults = Hash.new
      words.map.with_index {|word, i| @lexerResults[i] = word }

      html = words.map.with_index {|word, i| text = convWord(word, i)}.join(' ')

      @lexer_widget.textBrowser.setText(html)
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

    def convWord(word, index)
      raw = word.word
      pos = word.part_of_speech
      color = @part_of_speech_colors[pos.name.gsub(' ', '_').underscore.to_sym] || @part_of_speech_colors[:default]
      
      if POS_IGNORE.include? pos
        raw = "<font style='color: #{color}'>" + raw + "</font>"
      else
        raw = "<a href=\'#{index}\' style='color: #{color}'>" + raw + "</a>"
      end
    end

    def clipboardChanged(mode)
      clipboard = Qt::Application.clipboard
      
      if clipboard.mimeData.hasText && mode == Qt::Clipboard::Clipboard && @clipboardCaptureAct.isChecked
        lexText(clipboard.text)
      end
    end


    def createStatusBar()
      statusBar().showMessage(tr("Ready"))
    end

    def createActions()
      @veAct = Qt::Action.new(tr("LexIt"), self)
      @veAct.statusTip = tr("Lexify text")
      connect(@veAct, SIGNAL('triggered()'), self, SLOT('lexEditorText()'))

      @clipboardCaptureAct = Qt::Action.new(tr("&Capture Clipboard"), self)
      @clipboardCaptureAct.statusTip = tr("Send copied text to the lexer")
      @clipboardCaptureAct.setCheckable(true)
    end

    def createMenus()
      @fileMenu = menuBar().addMenu(tr("&File"))
      @fileMenu.addAction(@veAct)

      @editMenu = menuBar().addMenu(tr("&Edit"))
      @editMenu.addAction(@clipboardCaptureAct)
    end

    def createDockWindows()
      # color = Qt::Color.new(@part_of_speech_colors[:background])

      # palette = @lexerView.palette
      # palette.setColor(Qt::Palette::Base, color)
      # @lexerView.setPalette(palette)

      @lexer_widget = LexerWidget.new(self)

      addDockWidget(Qt::BottomDockWidgetArea, @lexer_widget)

      @dictionary_widget = DictionaryWidget.new(self)
      
      addDockWidget(Qt::RightDockWidgetArea, @dictionary_widget)
    end

  end
  module Underscore
    def underscore
      word = self.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
  String.send(:include, Underscore)
end
