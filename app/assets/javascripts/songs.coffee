
@songPageReady = ->
  $.each $('#songPage .mix8-player'), (index, player) ->
    initializePlayer '#' + $(player).find('.jp-player').prop('id'), '#' + $(player).find('.jp-audio').prop('id')

  return


$(document).on 'ready page:load', ->
  if $('#songPage').length > 0
    songPageReady()

  return
