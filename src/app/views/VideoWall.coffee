View = require 'famous/core/View'
Timer = require 'famous/utilities/Timer'

Playlist = require 'stores/YouTubePlaylist'

# control player:
# https://developers.google.com/youtube/iframe_api_reference

# <iframe id="ytplayer" type="text/html" width="640" height="360"
# src="https://www.youtube.com/embed/M7lc1UVf-VE?autoplay=1&modestbranding=1&rel=0&showinfo=0"
# frameborder="0" allowfullscreen>

class VideoWall extends View
  scrollOffset: 100
  prevScroll: 0

  constructor: ->
    super
    @playlist = new Playlist
    @playlist.on 'reset', @onPlaylistReset
    @playlist.on 'add', @onPlaylistAdd

    # load Vice videos
    @playlist.fetchPlaylist 'C4FDC39F67466711'

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

  onPlaylistAdd: (event) =>
    @playlist.eachIn event.newIds, (video) ->
      console.log video.get 'title'


module.exports = VideoWall
