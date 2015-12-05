require 'Qt'
require 'mainwindow'

module Eiwaji
  class EiwajiApp
    def initialize
      app = Qt::Application.new(ARGV)
      window = MainWindow::new
      window.resize(640, 480)
      window.show
      app.exec
    end
  end
end
