module Eiwaji
  class VocabListModel < Qt::AbstractItemModel
    def initialize(parent, entries)
      super(parent)
      @entries = entries
    end

    def flags(index)
      Qt::ItemIsSelectable | Qt::ItemIsEnabled
    end

    def index(row, column, parent)
      return Qt::ModelIndex.new if !hasIndex(row, column, parent)
      createIndex(row, column, 0)
    end

    def parent
      Qt::ModelIndex.new
    end

    def hasChildren(parent)
      return (rowCount(parent) > 0) && (columnCount(parent) > 0) if !parent.isValid
    end

    def data(index, role = Qt::DisplayRole)
      invalid = Qt::Variant.new
      return invalid unless role == Qt::DisplayRole
      return invalid if @entries.empty?
      return invalid if @entries.size <= index.row
      return invalid unless index.isValid
      entry = @entries.values[index.row]

      v = case index.column
          when 0
            unless entry.kanji.empty?
              if entry.kanji.is_a?(Array)
                entry.kanji.join(', ')
              else
                entry.kanji
              end
            end
          when 1
            entry.votes.to_s
          else
            raise "invalid column #{index.column}"
          end || ''
      Qt::Variant.new(v)
    end

    def columnCount(parent)
      return 0 if parent.valid?
      2
    end
    
    def rowCount(parent)
      return 0 if parent.valid?
      @entries.size
    end

    def headerData(section, orientation, role = Qt::DisplayRole)
      return Qt::Variant.new if role != Qt::DisplayRole
      v = case orientation
          when Qt::Horizontal
            %w(Kanji Votes)[section]
          else
            section.to_s
          end
      Qt::Variant.new(v)
    end
  end
end
