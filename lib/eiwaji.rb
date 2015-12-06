require 'Qt'
require 'mainwindow'

module Eiwaji
  class EiwajiApp
    def initialize
      app = Qt::Application.new(ARGV)
      window = MainWindow::new
      window.resize(1024, 768)
      window.show
      app.exec
    end
  end
end
