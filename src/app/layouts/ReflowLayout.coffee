ViewSequence = require 'famous/core/ViewSequence'
Entity = require 'famous/core/Entity'
OptionsManager = require 'famous/core/OptionsManager'
Modifier = require 'famous/core/Modifier'
Transform = require 'famous/core/Transform'
Transitionable = require 'famous/transitions/Transitionable'
TransitionableTransform = require 'famous/transitions/TransitionableTransform'
Timer = require 'famous/utilities/Timer'


class ReflowLayout
  @DEFAULT_OPTIONS:
    resizeDelay: 200

  _items: null
  _modifiers: []
  _states: []
  _contextSizeCache: [undefined, undefined]
  _size: null

  constructor: (options) ->
    @options = Object.create( @constructor.DEFAULT_OPTIONS or ReflowLayout.DEFAULT_OPTIONS )
    @optionsManager = new OptionsManager @options
    @setOptions options  if options
    @id = Entity.register @
    # TODO: make sure pull request is in master https://github.com/Famous/core/pull/32
    @_debouncedReflow = Timer.debounce @reflow, @options.resizeDelay or 200


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
  # Felix is fixing this.
  getSequenceLength: ->
    @_items._.array.length


  ###
  # Recalculate layout.
  #
  # Do reflow math here in subclass.
  # See GridLayout for example.
  ###
  reflow: (size) ->
    # Override in subclass


  _reflow: (size) ->
    return false if size[0] is @_contextSizeCache[0] and size[1] is @_contextSizeCache[1]
    # reflow immediately the first time
    if @_contextSizeCache[0] == undefined
      @reflow size
    else
      @_debouncedReflow size
    @_contextSizeCache = [ size[0], size[1] ]


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

    @_reflow size  if @getSequenceLength()

    sequence = @getSequence()
    result = []
    i = 0
    len = @_modifiers.length
    while sequence and i < len
      item = sequence.get()
      modifier = @_modifiers[i]
      result.push modifier.modify
        origin: origin
        target: item.render()
      sequence = sequence.getNext()
      i++
    transform = Transform.moveThen [ -size[0] * origin[0], -size[1] * origin[1], 0 ], transform  if size

    {
      transform: transform
      opacity: opacity
      size: size
      target: result
    }


  ###
  # Call from reflow.
  # See GridLayout for example.
  ###
  _createModifier: (index) ->
    trans =
      transform: new TransitionableTransform Transform.identity
      opacity: new Transitionable 0
      size: new Transitionable [0, 0]
    @_states[index] = trans
    @_modifiers[index] = new Modifier trans


  ###
  # Call from reflow.
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
