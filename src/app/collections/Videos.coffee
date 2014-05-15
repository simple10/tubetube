Parse = require 'parse'
Video = require 'models/Video'
Utility = require 'famous/utilities/Utility'
Config = require('config').public.youtube
_ = Parse._

# todo: use Utility.loadURL to fetch youtube data and manually diff and display
# do not extend Parse.collection
class Videos
  limit: 50

  getURL: (path) ->
    url = "#{Config.base_url}#{path}"
    url += '?' unless url.indexOf('?') > 0
    "#{url}&key=#{Config.key}"

  fetch: (options) ->
    @id = options.id
    options.limit ||= @limit
    options.url = @getURL("playlistItems?part=snippet&playlistId=#{options.id}&maxResults=#{options.limit}")
    options.url += "&pageToken=#{options.pageToken}" if options.pageToken
    Utility.loadURL options.url, ->
      options
      debugger
    # super

  fetchPlaylist: (id, options = {}) ->
    @fetch(_.extend(options, id: id))

  fetchNextPage: (options = {}) ->
    return false if !@hasNextPage() || @meta._loadingNextPage
    @meta._loadingNextPage = true
    _.extend(options,
      pageToken : @meta.nextPageToken
      update    : true
      remove    : false
      id        : @id
    )
    @fetch options

  hasNextPage: ->
    @meta && !!@meta.nextPageToken


module.exports = Videos
