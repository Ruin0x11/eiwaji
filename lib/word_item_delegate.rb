module Eiwaji
  class WordItemDelegate < Qt::StyledItemDelegate
    def initialize(parent)
      super(parent)
    end

    def sizeHint(option, index)
      if !index.isValid
        return Qt::QSize.new
      end

      data = index.data(Qt::DisplayRole)

      label.setText(data.toString)
      label.resize(label.sizeHint)
      return Qt::QSize.new(option.rect.width, label.height)
    end

    def paint(painter, option, index)
      if !index.isValid
        return
      end

      data = index.data(Qt::DisplayRole)

      # Not necessary to do it here, as it's been already done in sizeHint(), but anyway.
      label.setText(data.toString)

      painter.save

      rect = option.rect

      # This will draw a label for you. You can draw a pushbutton the same way.
      label.render(painter, Qt::QPoint.new(rect.topLeft.x, rect.center.y - label.height / 2),
        Qt::QRegion.new(label.rect), QWidget::RenderFlags.new)

      painter.restore
    end
    
  end
end
