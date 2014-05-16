_ = require('parse')._
Video = require 'stores/Video'
Utility = require 'famous/utilities/Utility'
EventEmitter = require 'famous/core/EventEmitter'
Config = require('config').public.youtube

# Fetch and store YouTube playlist videos
#
# Events:
#   add: new videos were added
#   error: something went wrong
class YouTubePlaylist extends EventEmitter
  # Storage of videos indexed by video id
  videos: {}
  order: []
  limit: 50
  nextPageToken: null

  constructor: ->
    super

  getURL: (path) ->
    url = "#{Config.base_url}#{path}"
    url += '?' unless url.indexOf('?') > 0
    "#{url}&key=#{Config.key}"

  fetch: (options) ->
    @playlistId = options.playlistId
    limit = options.limit or @limit
    limit = 50 if limit > 50
    url = @getURL "playlistItems?part=snippet&playlistId=#{@playlistId}&maxResults=#{limit}"
    url = "#{url}&pageToken=#{options.pageToken}" if options.pageToken
    Utility.loadURL url, (results) =>
      if results
        res = JSON.parse results
      else
        res = error: 'Invalid response'
      return @emit 'error', res if res.error
      @nextPageToken = res.nextPageToken
      @limit = res.pageInfo.resultsPerPage
      @total = res.pageInfo.totalResults
      @emit 'add',
        playlist: @
        newIds: @setVideos res.items

  getVideo: (id) ->
    @videos[id]

  each: (func, list, idx=0) ->
    list ||= @order
    if list[idx]
      func @getVideo(list[idx])
      @each func, list, idx+1

  eachIn: (list, func) ->
    @each func, list

  fetchPlaylist: (id, options = {}) ->
    @fetch _.extend options, playlistId: id

  fetchNextPage: (options = {}) ->
    return false if !@hasNextPage() || @meta._loadingNextPage
    @meta._loadingNextPage = true
    _.extend options,
      pageToken: @nextPageToken
      playlistId: @playlistId
    @fetch options

  setVideos: (items) ->
    newIds = []
    for video in items
      id = video.snippet.resourceId.videoId
      unless @videos[id]
        @videos[id] = new Video
          id: id
          title: video.snippet.title
          thumbnail: video.snippet.thumbnails.medium
        @order.push id
        newIds.push id
    newIds

module.exports = YouTubePlaylist
