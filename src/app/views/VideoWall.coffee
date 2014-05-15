View = require 'famous/core/View'
Timer = require 'famous/utilities/Timer'

Videos = require 'collections/Videos'

class VideoWall extends View
  scrollOffset: 100
  prevScroll: 0

  constructor: ->
    super
    @videos = new Videos
    @videos.on 'reset', @onPlaylistReset
    @videos.on 'add', @onPlaylistAdd

    # load Vice videos
    @videos.fetchPlaylist('C4FDC39F67466711')

  onPlaylistReset: =>
    debugger
    # @render()
    Timer.setTimeout @loadMoreVideos, 1000

  loadMoreVideos: =>
    @collection.fetchNextPage() if @needMoreVideos()

  needMoreVideos: ->
    needmore = @$videos.height() - @scrollOffset < $(window).height()
    scroll = $(document).scrollTop() + $(window).height() + @scrollOffset
    scrollmore = @prevScroll < scroll && scroll > @$videos.height()
    @prevScroll = scroll
    needmore || scrollmore

  onPlaylistAdd: (video, playlist, options) =>
    debugger
    @renderChanges([video])


module.exports = VideoWall
