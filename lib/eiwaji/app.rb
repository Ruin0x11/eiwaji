module Eiwaji
  class EiwajiApp
    def initialize
      app = Qt::Application.new(ARGV)
      window = MainWindow::new
      window.resize(Eiwaji::Constants::WINDOW_WIDTH, Eiwaji::Constants::WINDOW_HEIGHT)
      window.show
      app.exec
    end
  end
end
