# coding: utf-8
require 'jdict'
require 'pp'
require 'text'
require 'mkmf'

require_relative 'tableview'
require_relative 'lexer_widget'
require_relative 'dictionary_widget'
require_relative 'settings_dialog'

module Eiwaji
  class MainWindow < Qt::MainWindow

    CONFIG_PATH = "./eiwajirc"
    DICTIONARY_PATH = "./dicts/"

    slots 'lexEditorText()', 'clipboardChanged(QClipboard::Mode)', 'toggleMainTextEditable()', 'openSettings()'

    def initialize(parent = nil)
      super(parent)

      if find_executable('mecab') == nil
        Qt::MessageBox.critical(self, tr("Mecab not installed"),
                  tr("An installation of mecab was not detected. " +
                     "Text analysis will not function properly."))
      end

      @ui = Ui_MainWindow.new
      @ui.setupUi(self)

      if not File.exists? CONFIG_PATH
        writeConfig
      end
      readConfig

      initClipboard()
      createActions()
      createMenus()
      createStatusBar()
      createDockWindows()

      setStyleSheet("QToolTip { color: #ffffff; background-color: #2a82da; border: 1px solid white; }")
    end

    def initClipboard
      clipboard = Qt::Application.clipboard

      # on Windows, it appears that the clipboard is not monitored until it is changed within the Qt application.
      # clipboard.setText(clipboard.text.force_encoding("UTF-8")) if clipboard.mimeData.hasText
      connect(clipboard, SIGNAL('changed(QClipboard::Mode)'), self, SLOT('clipboardChanged(QClipboard::Mode)'))
    end
    
    # send the text in the main editor to the lexer widget
    def lexEditorText
      text = @ui.bigEditor.toPlainText
      @lexer_widget.lexText(text, true)
    end

    def clipboardChanged(mode)
      clipboard = Qt::Application.clipboard
      
      if clipboard.mimeData.hasText && mode == Qt::Clipboard::Clipboard && @clipboardCaptureAct.isChecked
        @ui.bigEditor.setText(clipboard.text.force_encoding("UTF-8"))
        lexEditorText()
      end
    end

    def toggleMainTextEditable
      if @clipboardCaptureAct.isChecked
        @ui.bigEditor.setEnabled(false)
      else
        @ui.bigEditor.setEnabled(true)
      end
      
    end

    def search(query, lemma)
      @dictionary_widget.search(query, lemma)
    end

    def rebuild_dictionary
      @dictionary_widget.reset
    end

    def createStatusBar
      statusBar().showMessage(tr("Ready"))
    end

    def createActions
      @veAct = Qt::Action.new(tr("&Analyze Text"), self)
      @veAct.statusTip = tr("Send the text in the editor to the lexer widget.")
      connect(@veAct, SIGNAL('triggered()'), self, SLOT('lexEditorText()'))

      @clipboardCaptureAct = Qt::Action.new(tr("&Capture Clipboard"), self)
      @clipboardCaptureAct.statusTip = tr("Automatically copy text to the editor and lexer")
      @clipboardCaptureAct.setCheckable(true)
      connect(@clipboardCaptureAct, SIGNAL('triggered()'), self, SLOT('toggleMainTextEditable()'))

      @settingsAct = Qt::Action.new(tr("&Settings..."), self)
      @settingsAct.statusTip = tr("Open the settings dialog")
      connect(@settingsAct, SIGNAL('triggered()'), self, SLOT('openSettings()'))
    end

    def createMenus
      @fileMenu = menuBar().addMenu(tr("&File"))
      @fileMenu.addAction(@veAct)

      @editMenu = menuBar().addMenu(tr("&Edit"))
      @editMenu.addAction(@clipboardCaptureAct)
      @editMenu.addAction(@settingsAct)
    end

    def createDockWindows
      @lexer_widget = LexerWidget.new(self)
      addDockWidget(Qt::BottomDockWidgetArea, @lexer_widget)

      @dictionary_widget = DictionaryWidget.new(self)
      addDockWidget(Qt::RightDockWidgetArea, @dictionary_widget)
    end

    def openSettings
      settings = Eiwaji::SettingsDialog.new(self)
      settings.exec
      readConfig
      @dictionary_widget.reset
    end

    def writeConfig
      config = JDict.configuration
      @settings ||= Qt::Settings.new(CONFIG_PATH, Qt::Settings::IniFormat)
      @settings.setValue("num_results", Qt::Variant.new(config.num_results))
      @settings.setValue("language", Qt::Variant.new(config.language.to_s))
      @settings.sync
    end

    def readConfig
      return unless File.exists? CONFIG_PATH
      config = JDict.configuration
      @settings ||= Qt::Settings.new(CONFIG_PATH, Qt::Settings::IniFormat)
      JDict.reset
      JDict.configure do |config|
        config.num_results = @settings.value("num_results").toInt
        config.language = @settings.value("language").toString.to_sym
        config.dictionary_path = DICTIONARY_PATH
        config.index_path = DICTIONARY_PATH
      end
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

# Make the MakeMakefile logger write file output to null.
# Probably requires ruby >= 1.9.3
module MakeMakefile::Logging
  @logfile = File::NULL
end
