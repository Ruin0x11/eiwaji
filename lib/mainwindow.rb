# coding: utf-8
require 'jdict'
require 'pp'
require 'text'
require 'mkmf'

require_relative 'tableview'
require_relative 'lexer_widget'
require_relative 'dictionary_widget'
require_relative 'settings_dialog'
require_relative 'vocab_list_widget'

module Eiwaji
  class MainWindow < Qt::MainWindow
    slots 'lex_editor_text()', 'clipboard_changed(QClipboard::Mode)',
          'toggle_main_text_editable()', 'open_settings()'

    def initialize(parent = nil)
      super(parent)

      if find_executable0('mecab').nil?
        Qt::MessageBox.critical(self, tr('Mecab not installed'),
                                tr('An installation of mecab was not detected. ' \
                                    'Text analysis will not function properly.'))
      end

      @ui = Ui_MainWindow.new
      @ui.setupUi(self)

      @settings ||= Qt::Settings.new(Eiwaji::Constants::CONFIG_PATH,
                                     Qt::Settings::IniFormat)

      write_config unless File.exist? Eiwaji::Constants::CONFIG_PATH
      read_config

      init_clipboard
      create_actions
      create_menus
      create_status_bar
      create_toolbars
      create_dock_windows

      setStyleSheet('QToolTip { color: #ffffff;
                                background-color: #2a82da;
                                border: 1px solid white; }')
    end

    def init_clipboard
      clipboard = Qt::Application.clipboard

      # on Windows, it appears that the clipboard is not monitored
      # until it is changed within the Qt application.
      connect(clipboard, SIGNAL('changed(QClipboard::Mode)'),
              self, SLOT('clipboard_changed(QClipboard::Mode)'))
    end
 
    # send the text in the main editor to the lexer widget
    def lex_editor_text
      text = @ui.bigEditor.toPlainText
      @lexer_widget.lex_text(text, true)
    end

    def clipboard_changed(mode)
      clipboard = Qt::Application.clipboard
      if clipboard.mimeData.hasText && mode == Qt::Clipboard::Clipboard &&
         @clipboard_capture_act.isChecked

        @ui.bigEditor.setText(clipboard.text.force_encoding('UTF-8'))
        lex_editor_text
      end
    end

    def toggle_main_text_editable
      if @clipboard_capture_act.isChecked
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

    def create_status_bar
      statusBar.showMessage(tr('Ready'))
    end

    def show_status_message(str)
      statusBar.showMessage(str.force_encoding('UTF-8'))
    end

    def create_actions
      @ve_act = Qt::Action.new(tr('&Analyze Text'), self)
      @ve_act.shortcut = Qt::KeySequence.new(tr('Ctrl+E'))
      @ve_act.statusTip = tr('Send the text in the editor to the lexer widget.')
      connect(@ve_act, SIGNAL('triggered()'), self, SLOT('lex_editor_text()'))

      @clipboard_capture_act = Qt::Action.new(tr('&Capture Clipboard'), self)
      @clipboard_capture_act.statusTip = tr('Automatically copy text to the' \
                                            'editor and lexer')
      @clipboard_capture_act.setCheckable(true)
      connect(@clipboard_capture_act, SIGNAL('triggered()'),
              self, SLOT('toggle_main_text_editable()'))

      @settings_act = Qt::Action.new(tr('&Settings...'), self)
      @settings_act.statusTip = tr('Open the settings dialog')
      connect(@settings_act, SIGNAL('triggered()'),
              self, SLOT('open_settings()'))
    end

    def create_menus
      @file_menu = menuBar.addMenu(tr('&File'))
      @file_menu.addAction(@ve_act)

      @edit_menu = menuBar.addMenu(tr('&Edit'))
      @edit_menu.addAction(@clipboard_capture_act)
      @edit_menu.addAction(@settings_act)
    end

    def create_toolbars
      @file_toolbar = addToolBar(tr('File'))
      @file_toolbar.addAction(@ve_act)
    end

    def create_dock_windows
      @lexer_widget = LexerWidget.new(self)
      addDockWidget(Qt::BottomDockWidgetArea, @lexer_widget)

      @dictionary_widget = DictionaryWidget.new(self)
      addDockWidget(Qt::BottomDockWidgetArea, @dictionary_widget)

      @vocab_list_widget = VocabListWidget.new(self)
      addDockWidget(Qt::LeftDockWidgetArea, @vocab_list_widget)
    end

    def open_settings
      settings = Eiwaji::SettingsDialog.new(self)
      settings.exec
      read_config
      @dictionary_widget.reset
    end

    def write_config
      config = JDict.configuration
      @settings.setValue('num_results', Qt::Variant.new(config.num_results))
      @settings.setValue('language', Qt::Variant.new(config.language.to_s))
      @settings.sync
    end

    def read_config
      return unless File.exist? Eiwaji::Constants::CONFIG_PATH

      JDict.reset
      JDict.configure do |config|
        config.num_results = @settings.value('num_results').toInt
        config.language = @settings.value('language').toString.to_sym
        config.dictionary_path = Eiwaji::Constants::DICTIONARY_PATH
        config.index_path = Eiwaji::Constants::DICTIONARY_PATH
      end
    end
  end
end

# Make the MakeMakefile logger write file output to null.
# Probably requires ruby >= 1.9.3
module MakeMakefile::Logging
  @logfile = File::NULL
end
