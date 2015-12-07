# coding: utf-8
require 'jdict'
require 'jmdict'
require 'pp'
require 'text'

require_relative 'tableview'
require_relative 'lexer_widget'
require_relative 'dictionary_widget'
require_relative 'settings_dialog'

module Eiwaji
  class MainWindow < Qt::MainWindow

    @is_editor_locked = false

    slots 'lexEditorText()', 'clipboardChanged(QClipboard::Mode)', 'toggleMainTextEditable()', 'openSettings()'

    def initialize(parent = nil)
      super(parent)

      @ui = Ui_MainWindow.new
      @ui.setupUi(self)

      initLibraries()
      createActions()
      createMenus()
      createStatusBar()
      createDockWindows()

      setStyleSheet("QToolTip { color: #ffffff; background-color: #2a82da; border: 1px solid white; }")

      @ui.bigEditor.setText("日本語（にほんご、にっぽんご）は、主に日本国内や日本人同士の間で使われている言語である。日本は法令によって「公用語」を規定していないが、法令その他の公用文は全て日本語で記述され、各種法令（裁判所法第74条、会社計算規則第57条、特許法施行規則第2条など）において日本語を用いることが定められるなど事実上の公用語となっており、学校教育の「国語」でも教えられる。")

      lexEditorText()
    end

    def initLibraries
      JDict.configure do |config|
        config.dictionary_path = ENV['HOME'] + '/.dicts'
        config.index_path = ENV['HOME'] + '/.dicts/index'
        config.lazy_index_loading = false
      end

      clipboard = Qt::Application.clipboard
      connect(clipboard, SIGNAL('changed(QClipboard::Mode)'), self, SLOT('clipboardChanged(QClipboard::Mode)'))
    end
    
    def lexEditorText
      text = @ui.bigEditor.toPlainText
      @lexer_widget.lexText(text)
    end

    def clipboardChanged(mode)
      clipboard = Qt::Application.clipboard
      
      if clipboard.mimeData.hasText && mode == Qt::Clipboard::Clipboard && @clipboardCaptureAct.isChecked
        @ui.bigEditor.setText(clipboard.text)
        lexEditorText
      end
    end

    def toggleMainTextEditable
      if @clipboardCaptureAct.isChecked
        @is_editor_locked = true
        @ui.bigEditor.setEnabled(false)
      else
        @is_editor_locked = false
        @ui.bigEditor.setEnabled(true)
      end
      
    end

    def search(query, lemma)
      @dictionary_widget.search(query, lemma)
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
      connect(@clipboardCaptureAct, SIGNAL('triggered()'), self, SLOT('toggleMainTextEditable()'))

      @settingsAct = Qt::Action.new(tr("&Settings..."), self)
      @settingsAct.statusTip = tr("Open the settings dialog")
      connect(@settingsAct, SIGNAL('triggered()'), self, SLOT('openSettings()'))
    end

    def createMenus()
      @fileMenu = menuBar().addMenu(tr("&File"))
      @fileMenu.addAction(@veAct)

      @editMenu = menuBar().addMenu(tr("&Edit"))
      @editMenu.addAction(@clipboardCaptureAct)
      @editMenu.addAction(@settingsAct)
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

    def openSettings()
      settings = Eiwaji::SettingsDialog.new(self)
      settings.exec
      @dict = JDict::JMDict.new()
      pp JDict.configuration
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
