# coding: utf-8
require 'jdict'
require 'jmdict'
require 've'
require 'pp'
require 'text'

require_relative 'tableview'

module Eiwaji
  class MainWindow < Qt::MainWindow

    POS_IGNORE = [Ve::PartOfSpeech::Symbol, Ve::PartOfSpeech::Number]

    slots 'lexEditorText()', 'wordClicked(QUrl)', 'queryEntered()', 'updateSortIndex(int)', 'clipboardChanged(QClipboard::Mode)'

    def initialize(parent = nil)
      super(parent)

      JDict.configure do |config|
        config.dictionary_path = '/home/ruin'
        config.index_path = '/home/ruin/build/index_eiwaji'
        config.lazy_index_loading = false
      end

      part_of_speech_colors()

      @bigEdit = Qt::TextEdit.new

      clipboard = Qt::Application.clipboard
      connect(clipboard, SIGNAL('changed(QClipboard::Mode)'), self, SLOT('clipboardChanged(QClipboard::Mode)'))

      @white = Text::WhiteSimilarity.new

      @dict = JDict::JMDict.new()

      setCentralWidget(@bigEdit)

      createActions()
      createMenus()
      createStatusBar()
      createDockWindows()

      setWindowTitle(tr("Eiwaji"))
      @bigEdit.setText("日本語（にほんご、にっぽんご）は、主に日本国内や日本人同士の間で使われている言語である。日本は法令によって「公用語」を規定していないが、法令その他の公用文は全て日本語で記述され、各種法令（裁判所法第74条、会社計算規則第57条、特許法施行規則第2条など）において日本語を用いることが定められるなど事実上の公用語となっており、学校教育の「国語」でも教えられる。")
      lexEditorText()
    end

    def lexEditorText
      text = @bigEdit.toPlainText
      lexText(text)
    end

    def lexText(text)
      text = text.force_encoding("UTF-8")

      words = Ve.in(:ja).words(text)

      @lexerResults = Hash.new
      words.map.with_index {|word, i| @lexerResults[i] = word }

      html = words.map.with_index {|word, i| text = convWord(word, i)}.join(' ')

      @lexerView.setText(html)
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

    def wordClicked(url)
      raise "No results from the lexer." if @lexerResults.empty?

      word = @lexerResults[url.path.to_i]
      pp word
      query = word.tokens[0][:lemma]
      lemma = word.lemma
      @dictQuery.setText(query)
      search(query, lemma)
    end

    def queryEntered()
      query = @dictQuery.text
      search(query)
    end

    def updateSortIndex(index)
      @entryResults.sortByColumn(index)
    end

    def search(query, lemma = nil)
      lemma ||= query
      # else
      #   query = word.lemma
      # end
      results = @dict.search(query)

      model = Qt::StandardItemModel.new(results.size, 4)
      model.setHeaderData(0, Qt::Horizontal, Qt::Variant.new(tr("Kanji")))
      model.setHeaderData(1, Qt::Horizontal, Qt::Variant.new(tr("Kana")))
      model.setHeaderData(2, Qt::Horizontal, Qt::Variant.new(tr("Sense")))
      model.setHeaderData(3, Qt::Horizontal, Qt::Variant.new(tr("Similarity")))
      @entryResults.model = model

      connect(@entryResults.horizontalHeader, SIGNAL('sectionClicked(int)'), self, SLOT('updateSortIndex(int)'))
      
      results.each_with_index do |entry, row|
        # if entry.kanji.kind_of?(Array)
        #   entry.kanji.each {|kanji| p kanji.force_encoding("UTF-8")}
        # else
        #   p entry.kanji.force_encoding("UTF-8")
        # end
        # entry.kana.each {|kana| p kana.force_encoding("UTF-8")}
        # entry.senses.each {|sense| pp sense.glosses[0] }
        if not entry.kanji.empty?
          if entry.kanji.kind_of?(Array)
            kanji = entry.kanji[0].force_encoding("UTF-8")
          else
            kanji = entry.kanji.force_encoding("UTF-8")
          end
          index = model.index(row, 0, Qt::ModelIndex.new)
          model.setData(index, Qt::Variant.new(kanji))
        end

        kana = entry.kana[0].force_encoding("UTF-8")
        index = model.index(row, 1, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(kana))

        sense = entry.senses[0].glosses.join(", ")
        pos = entry.senses[0].parts_of_speech
        # sense = pos.join(" / ") + " " + sense unless pos.nil?
        index = model.index(row, 2, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(sense))

        similarity = (@white.similarity(lemma, kana))
        similarity += (@white.similarity(lemma, kanji)) unless kanji.nil?
        index = model.index(row, 3, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(similarity))
      end
      # sort by similarity
      @entryResults.sortByColumn(3)
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
      dock = Qt::DockWidget.new(tr("Lexer"), self)
      dock.allowedAreas = Qt::LeftDockWidgetArea | Qt::RightDockWidgetArea | Qt::BottomDockWidgetArea

      @lexerView = Qt::TextBrowser.new

      sheet = "a {  text-decoration: underline; color: #000000; }"

      font = Qt::Font.new("Kochi Gothic")
      font.setPixelSize(22)

      color = Qt::Color.new(@part_of_speech_colors[:background])

      @lexerView.setFont(font)
      @lexerView.openLinks = false

      palette = @lexerView.palette
      palette.setColor(Qt::Palette::Base, color)
      @lexerView.setPalette(palette)

      @lexerView.document.setDefaultStyleSheet(sheet)
      connect(@lexerView, SIGNAL('anchorClicked(QUrl)'),
              self, SLOT('wordClicked(QUrl)'))

      dock.widget = @lexerView
      addDockWidget(Qt::BottomDockWidgetArea, dock)

      font = Qt::Font.new("Kochi Gothic")
      font.setPixelSize(12)
      @entryResults = Eiwaji::TableView.new
      @entryResults.setFont(font)
      @entryResults.setSelectionMode(Qt::AbstractItemView::NoSelection)
      connect(@entryResults, SIGNAL('sectionClicked(int)'), self, SLOT('updateSortIndex(int)'))

      @dictQuery = Qt::LineEdit.new
      connect(@dictQuery, SIGNAL('returnPressed()'), self, SLOT('queryEntered()'))

      layout = Qt::VBoxLayout.new do |m|
        m.addWidget(@dictQuery)
        m.addWidget(@entryResults)
      end

      @dictView = Qt::Widget.new
      @dictView.setLayout(layout)
      
      dock = Qt::DockWidget.new(tr("Dictionary"), self)
      dock.widget = @dictView
      addDockWidget(Qt::RightDockWidgetArea, dock)
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
