ReflowLayout = require 'layouts/ReflowLayout'


# Float items in a responsive layout
class FloatLayout extends ReflowLayout
  @DEFAULT_OPTIONS:
    resizeDelay: 200
    defaultItemSize: [50, 50]
    transition:
      duration: 200

  constructor: ->
    super

  getSize: ->
    [500, 10000]

  reflow: (size) ->
    sequence = @getSequence()
    i = 0
    col = 0
    row = 0
    len = @getSequenceLength()
    # assume items are all the same size for now
    itemSize = sequence.getSize()
    # todo: use "while sequence" once Felix fixes sequence.getNext
    while i < len
      # todo: use Array.push in @_createModifier and @_animateModifier
      @_createModifier i unless @_modifiers[i]
      x = col * itemSize[0]
      col++
      if x + itemSize[0] > size[0]
        x = 0
        col = 1
        row++
      y = row * itemSize[1]
      @_animateModifier i, itemSize, [x, y, 0], 1
      sequence = sequence.getNext()
      i++

    # todo: update size here
    # see getSize


module.exports = FloatLayout

