# coding: utf-8
require 'jmdict'
require 've'
require 'pp'

require_relative 'tableview'

module Eiwaji
  class MainWindow < Qt::MainWindow

    POS_IGNORE = [Ve::PartOfSpeech::Postposition, Ve::PartOfSpeech::Symbol, Ve::PartOfSpeech::Number]

    slots 'veIt()', 'handleUrl(QUrl)'

    def initialize(parent = nil)
      super(parent)

      @bigEdit = Qt::TextEdit.new

      @dict = JDict::JMDict.new(INDEX_PATH, false)

      setCentralWidget(@bigEdit)

      createActions()
      createMenus()
      createDockWindows()

      setWindowTitle(tr("jisho"))
      @bigEdit.setText("A340は長距離路線向けの大型機として開発され、エアバスA300由来の胴体を延長したワイドボディ機で、低翼に配置された主翼下に4発のターボファンエンジンを装備する。")
      veIt()
    end

    def veIt()
      text = @bigEdit.toPlainText()
      p text.force_encoding("UTF-8")

      words = Ve.in(:ja).words(text)

      @lexerResults = Hash.new
      words.map.with_index {|word, i| @lexerResults[i] = word }

      html = words.map.with_index {|word, i| convWord(word, i)}.join(' ')
      p html

      @lexerView.setText(html)
    end

    def convWord(word, index)
      raw = word.word
      pos = word.part_of_speech
      if POS_IGNORE.include? pos
        raw = raw
      else
        raw = "<a href=\'#{index}\'><b><u>" + raw + "</u></b></a>"
      end
    end

    def handleUrl(url)
      word = @lexerResults[url.path.to_i]
      results = @dict.search(word.lemma)

      pp word

      model = Qt::StandardItemModel.new(results.size, 3)
      @entryResults.model = model
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

        sense = entry.senses[0].glosses[0].force_encoding("UTF-8")
        index = model.index(row, 2, Qt::ModelIndex.new)
        model.setData(index, Qt::Variant.new(sense))
      end
    end

    def createActions()
      @veAct = Qt::Action.new(tr("LexIt"), self)
      @veAct.statusTip = tr("Lexify text")
      connect(@veAct, SIGNAL('triggered()'), self, SLOT('veIt()'))
    end

    def createMenus()
      @fileMenu = menuBar().addMenu(tr("&File"))
      @fileMenu.addAction(@veAct)
    end

    def createDockWindows()
      dock = Qt::DockWidget.new(tr("Lexer"), self)
      dock.allowedAreas = Qt::LeftDockWidgetArea | Qt::RightDockWidgetArea

      @lexerView = Qt::TextBrowser.new

      font = Qt::Font.new("MS Gothic")
      font.setPixelSize(18)
      @lexerView.setFont(font)
      @lexerView.openLinks = false
      connect(@lexerView, SIGNAL('anchorClicked(QUrl)'),
              self, SLOT('handleUrl(QUrl)'))

      dock.widget = @lexerView
      addDockWidget(Qt::BottomDockWidgetArea, dock)

      @entryResults = Eiwaji::TableView.new
      dock = Qt::DockWidget.new(tr("Results"), self)
      dock.widget = @entryResults
      addDockWidget(Qt::BottomDockWidgetArea, dock)
    end

  end
end
