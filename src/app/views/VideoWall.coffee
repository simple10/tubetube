View = require 'famous/core/View'
Surface = require 'famous/core/Surface'
ImageSurface = require 'famous/surfaces/ImageSurface'
Timer = require 'famous/utilities/Timer'
ScrollView = require 'famous/views/ScrollView'
FloatLayout = require 'layouts/FloatLayout'

Playlist = require 'stores/YouTubePlaylist'

# control player:
# https://developers.google.com/youtube/iframe_api_reference

# <iframe id="ytplayer" type="text/html" width="640" height="360"
# src="https://www.youtube.com/embed/M7lc1UVf-VE?autoplay=1&modestbranding=1&rel=0&showinfo=0"
# frameborder="0" allowfullscreen>

class VideoWall extends View
  # Vice channel playlist
  playlistId: 'C4FDC39F67466711'
  scrollOffset: 100
  prevScroll: 0
  surfaces: []

  constructor: ->
    super
    @playlist = new Playlist
    @playlist.on 'add', @onPlaylistAdd
    @playlist.on 'error', @onError
    @playlist.fetchPlaylist @playlistId

    @scroll = new ScrollView
      margin: 2000

    @layout = new FloatLayout
    @layout.sequenceFrom @surfaces
    @scroll.sequenceFrom [@layout]

    @background = new Surface
      size: [undefined, undefined]
    @background.pipe @scroll

    @add @background
    @add @scroll


  addVideo: (video) ->
    thumb = video.get 'thumbnail'
    surface = new ImageSurface
      size: [thumb.width, thumb.height]
      classes: ['video__thumbnail']
      content: thumb.url
    surface.pipe @scroll
    @surfaces.push surface

  loadMoreVideos: =>
    @playlist.fetchNextPage()

  onPlaylistAdd: (event) =>
    @playlist.eachIn event.newIds, (video) =>
      @addVideo video
    #Timer.setTimeout @loadMoreVideos, 1000

  onError: (error) =>
    debugger


module.exports = VideoWall
