ViewSequence = require 'famous/core/ViewSequence'
Entity = require 'famous/core/Entity'
OptionsManager = require 'famous/core/OptionsManager'
Modifier = require 'famous/core/Modifier'
Transform = require 'famous/core/Transform'
Transitionable = require 'famous/transitions/Transitionable'
TransitionableTransform = require 'famous/transitions/TransitionableTransform'


class ReflowLayout
  @DEFAULT_OPTIONS:
    size: [undefined, undefined]

  _items: null
  _modifiers: []
  _states: []
  _contextSizeCache: [0, 0]
  _activeCount: 0
  _size: null

  constructor: (options) ->
    @options = Object.create @constructor.DEFAULT_OPTIONS
    @optionsManager = new OptionsManager @options
    @setOptions options  if options
    @id = Entity.register @

  render: ->
    @id

  setOptions: (options) ->
    @optionsManager.setOptions options

  getSize: ->
    @_size or @options.size

  ###
  # Sets the collection of renderables.
  #
  # @method sequenceFrom
  # @param {Array|ViewSequence} items Either an array of renderables or a Famous viewSequence.
  # @chainable
  ###
  sequenceFrom: (items) ->
    items = new ViewSequence(items) if items instanceof Array
    @_items = items
    @

  getSequence: ->
    @_items

  # TODO: ANSWER THIS ....
  # Why does ViewSequence create a new node when getNext is called on the last node?
  getSequenceLength: ->
    @_items._.array.length

  ###
  # Apply changes from this component to the corresponding document element.
  # This includes changes to classes, styles, size, content, opacity, origin,
  # and matrix transforms.
  #
  # @private
  # @method commit
  # @param {Context} context commit context
  ###
  commit: (context) ->
    transform = context.transform
    opacity = context.opacity
    origin = context.origin
    size = context.size

    @_reflow size

    sequence = @getSequence()
    result = []
    idx = 0
    while sequence and idx < @_modifiers.length
      item = sequence.get()
      modifier = @_modifiers[idx]
      if idx >= @_activeCount and @_states[idx].opacity.isActive()
        @_modifiers.splice idx, 1
        @_states.splice idx, 1
      if item
        result[idx] = modifier.modify
          origin: origin
          target: item.render()
      sequence = sequence.getNext()
      idx += 1
    transform = Transform.moveThen [ -size[0] * origin[0], -size[1] * origin[1], 0 ], transform  if size

    {
      transform: transform
      opacity: opacity
      size: size
      target: result
    }

  ###
  # Recalculate layout.
  #
  # Do reflow math here in subclass.
  # See GridLayout for example.
  ###
  _reflow: (size) ->
    # Only reflow if parent context size has changed
    if size[0] is @_contextSizeCache[0] and size[1] is @_contextSizeCache[1]
      false
    else
      @_contextSizeCache = [ size[0], size[1] ] if @getSequenceLength()
      true


  ###
  # Call from _reflow.
  # See GridLayout for example.
  ###
  _createModifier: (index) ->
    trans =
      transform: new TransitionableTransform Transform.identity
      opacity: new Transitionable 0
      size: new Transitionable [0, 0]
    @_states[index] = trans
    # todo: use new Modifier(trans) if it works; needs testing
    @_modifiers[index] = new Modifier
      transform: trans.transform
      opacity: trans.opacity
      size: trans.size

  ###
  # Call from _reflow.
  # See GridLayout for example.
  ###
  _animateModifier: (index, size, position, opacity) ->
    currState = @_states[index]
    currSize = currState.size
    currOpacity = currState.opacity
    currTransform = currState.transform

    transition = @options.transition

    currTransform.halt()
    currOpacity.halt()
    currSize.halt()

    currTransform.setTranslate position, transition
    currSize.set size, transition
    currOpacity.set opacity, transition


module.exports = ReflowLayout
