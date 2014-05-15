Parse = require 'parse'


class Video extends Parse.Object
  thumbnail_url: (size = 'medium') ->
    @get('thumbnails')[size]['url']

  parse: (resp, xhr) ->
    resp = super
    resp.id = resp.resourceId.videoId if resp && resp.resourceId
    resp


module.exports = Video
