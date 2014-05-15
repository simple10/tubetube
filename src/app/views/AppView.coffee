# AppView
#
# Main entry point of the app. Manages global views and events.


View = require 'famous/core/View'
Utility = require 'famous/utilities/Utility'
HeaderFooterLayout = require 'famous/views/HeaderFooterLayout'
Surface = require 'famous/core/Surface'
Transform = require 'famous/core/Transform'
Transitionable  = require 'famous/transitions/Transitionable'
Modifier = require 'famous/core/Modifier'


# Views
VideoWall = require 'views/VideoWall'


class AppView extends View
  @DEFAULT_OPTIONS:
    none: true

  constructor: ->
    super
    @wall = new VideoWall


module.exports = AppView
