@initializePlayer = (jpPlayerSelector, jpAudioSelector) ->
  $(jpPlayerSelector).jPlayer
    ready: ->
      trackElement = $(this).closest('.track')
      trackElement.find('.pause').hide()
      trackElement.find('.play').show()

      audio = trackElement.data('audio')
      trackElement.find('.jp-player').jPlayer 'setMedia',
        m4a: audio.m4a
      return

    play: ->
      $(this).jPlayer('pauseOthers')
      trackElement = $(this).closest('.track')
      trackElement.find('.play').hide()
      trackElement.find('.pause').show()
      return

    pause: ->
      trackElement = $(this).closest('.track')
      trackElement.find('.pause').hide()
      trackElement.find('.play').show()
      return

    cssSelectorAncestor: jpAudioSelector
    swfPath: '/swf'
    supplied: 'm4a'
    wmode: 'window'
    smoothPlayBar: true
    keyEnabled: true
    remainingDuration: true
  return

@artistProfilePageReady = ->
  $.each $('#artistProfilePage .mix8-player'), (index, player) ->
    initializePlayer '#' + $(player).find('.jp-player').prop('id'), '#' + $(player).find('.jp-audio').prop('id')
    return

  $('#artistProfilePage .track-list .track .play').click ->
    trackElement = $(this).closest('.track')
    trackElement.find('.jp-player').jPlayer('play')
    return

  $('#artistProfilePage .track-list .track .pause').click ->
    trackElement = $(this).closest('.track')
    trackElement.find('.jp-player').jPlayer('pause')
    return

  return

$(document).on('ready pjax:success', ->
  if $('#artistProfilePage').length > 0
    artistProfilePageReady()

  return
)