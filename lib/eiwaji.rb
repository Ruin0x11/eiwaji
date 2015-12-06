require 'rubygems'
require 'bundler/setup'

require 'Qt'
require_relative 'mainwindow'
require_relative 'ui/ui_main_window'

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
