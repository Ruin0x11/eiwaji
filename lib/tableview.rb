module Eiwaji
  class TableView < Qt::TableView
    def initialize
      super
      self.vertical_header.hide
    end
  end
end
