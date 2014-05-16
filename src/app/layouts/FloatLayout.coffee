ReflowLayout = require 'layouts/ReflowLayout'


# Float items in a responsive layout
class FloatLayout extends ReflowLayout
  @DEFAULT_OPTIONS:
    defaultItemSize: [50, 50]
    # transition:
    #   duration: 500

  constructor: ->
    super

  _reflow: (size) ->
    return false unless super

    sequence = @getSequence()
    i = 0
    col = 0
    row = 0
    len = @getSequenceLength()
    # assume items are all the same size for now
    itemSize = sequence.getSize()
    while i < len
      @_createModifier i
      x = col * itemSize[0]
      col++
      if x + itemSize[0] > size[0]
        x = 0
        col = 1
        row++
      y = row * itemSize[1]
      @_animateModifier i, itemSize, [x, y, 0], 1
      sequence = sequence.getNext()
      i += 1
    @_activeCount = i

    # width = size[0]
    # cols = (width / @options.cellSize[0]) | 0
    # rowSize = size[1] / rows
    # colSize = size[0] / cols

    # i = 0
    # while i < cols
    #   currX = Math.round(colSize * j)
    #   currIndex = i * cols + j
    #   @_createModifier currIndex  unless currIndex of @_modifiers
    #   @_animateModifier currIndex, [ Math.round(colSize * (j + 1)) - currX, Math.round(rowSize * (i + 1)) - currY ], [ currX, currY, 0 ], 1
    #   i++
    # @_dimensionsCache = [ @options.dimensions[0], @options.dimensions[1] ]
    # @_contextSizeCache = [ size[0], size[1] ]
    # @_activeCount = rows * cols
    # i = @_activeCount
    # while i < @_modifiers.length
    #   _animateModifier.call this, i, [ Math.round(colSize), Math.round(rowSize) ], [ 0, 0 ], 0
    #   i++


module.exports = FloatLayout

