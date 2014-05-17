ReflowLayout = require 'layouts/ReflowLayout'


# Float items in a responsive layout
class FloatLayout extends ReflowLayout
  @DEFAULT_OPTIONS:
    resizeDelay: 200
    transition:
      duration: 200

  getSize: ->
    @_size

  reflow: (size) ->
    i = 0
    col = 0
    row = 0
    len = @getSequenceLength()
    # assume items are all the same size for now
    itemSize = @getSequence().getSize()
    while i < len
      x = col * itemSize[0]
      col++
      if x + itemSize[0] > size[0]
        x = 0
        col = 1
        row++
      y = row * itemSize[1]
      if @_modifiers[i] is undefined
        @_createModifier i, itemSize, [x, y, 0], 1
      else
        @_animateModifier i, itemSize, [x, y, 0], 1
      i++

    @_size = [size[0], itemSize[1]*(row+1)]


module.exports = FloatLayout

