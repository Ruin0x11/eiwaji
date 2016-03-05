module Eiwaji
  class TableView < Qt::TableView
    def initialize
      super
      vertical_header.hide
    end
  end
end
