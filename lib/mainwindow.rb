# coding: utf-8
require 've'

module Eiwaji
  class MainWindow < Qt::MainWindow

    POS_IGNORE = [Ve::PartOfSpeech::Postposition, Ve::PartOfSpeech::Symbol, Ve::PartOfSpeech::Number]

    slots 'veIt()', 'handleUrl(QUrl)'

    def initialize(parent = nil)
      super(parent)

      @bigEdit = Qt::TextEdit.new

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

      html = words.map {|word| convWord(word)}.join(' ')
      p html

      @results.setText(html)
    end

    def convWord(word)
      raw = word.word
      pos = word.part_of_speech
      if POS_IGNORE.include? pos
        raw = raw
      else
        raw = "<a href=\'dood\'><b><u>" + raw + "</u></b></a>"
      end
    end

    def handleUrl(url)
      p url
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
      dock = Qt::DockWidget.new(tr("Customers"), self)
      dock.allowedAreas = Qt::LeftDockWidgetArea | Qt::RightDockWidgetArea

      @results = Qt::TextBrowser.new

      font = Qt::Font.new("MS Gothic")
      font.setPixelSize(18)
      @results.setFont(font)
      @results.openLinks = false
      connect(@results, SIGNAL('anchorClicked(QUrl)'),
              self, SLOT('handleUrl(QUrl)'))

      dock.widget = @results
      addDockWidget(Qt::BottomDockWidgetArea, dock)
    end

  end
end
