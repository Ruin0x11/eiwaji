require 'rubygems'
require 'bundler/setup'

require 'Qt'
require_relative 'mainwindow'
require_relative 'ui/ui_main_window'
require_relative 'constants'

module Eiwaji
  class EiwajiApp
    def initialize
      app = Qt::Application.new(ARGV)
      window = MainWindow.new
      window.resize(Eiwaji::Constants::WINDOW_WIDTH,
                    Eiwaji::Constants::WINDOW_HEIGHT)
      window.show
      app.exec
    end
  end
end
