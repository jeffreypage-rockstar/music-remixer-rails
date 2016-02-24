@initializePlayer = (jpPlayerSelector, jpAudioSelector) ->
  trackElement = $(jpPlayerSelector).closest('.track')
  mix2Player = trackElement.find('.mix2').first();
  mix3Player = trackElement.find('.mix3').first();

  trackElement.find('.play').click ->
    trackElement.find('.jp-player').first().jPlayer('play')
    return

  trackElement.find('.pause').click ->
    trackElement.find('.jp-player').first().jPlayer('pause')
    return

  trackElement.find('button.style').click (event) ->
    event.stopPropagation()
    style = $(event.target).data('style')
    trackElement.find('button.style').removeClass 'selected'
    $(this).addClass 'selected'
    $.each trackElement.find('.jp-player'), (index, player) ->
      if $(player).hasClass(style)
        console.log 'Playing index: ' + index
        $(player).jPlayer('volume', 1)
      else
        console.log 'Muting index: ' + index
        $(player).jPlayer('volume', 0)
      return
    return


  $(jpPlayerSelector).jPlayer
    ready: ->
      trackElement.find('.pause').first().hide()
      trackElement.find('.play').first().show()

      audio = trackElement.data('audio')
      trackElement.find('.jp-player').first().jPlayer 'setMedia',
        m4a: audio.m4a
      return

    play: ->
      if trackElement.find('.mix2').length == 0
        $(this).jPlayer('pauseOthers')
      trackElement.find('.play').first().hide()
      trackElement.find('.pause').first().show()
      return

    pause: ->
      trackElement.find('.pause').first().hide()
      trackElement.find('.play').first().show()
      return

    seeked: (event) ->
      mix2Player.jPlayer 'play', event.jPlayer.status.currentTime
      mix3Player.jPlayer 'play', event.jPlayer.status.currentTime
      return

    cssSelectorAncestor: jpAudioSelector
    swfPath: '/swf'
    supplied: 'm4a'
    wmode: 'window'
    smoothPlayBar: true
    keyEnabled: true
    remainingDuration: true

  mix2Player.jPlayer
    ready: ->
      audio = trackElement.data('audio-mix2')
      mix2Player.jPlayer 'setMedia', m4a: audio.m4a
      mix2Player.jPlayer 'volume', 0
      return

    swfPath: '/swf'
    supplied: 'm4a'
    wmode: 'window'
    smoothPlayBar: true
    keyEnabled: true
    remainingDuration: true

  mix3Player.jPlayer
    ready: ->
      audio = trackElement.data('audio-mix3')
      mix3Player.jPlayer 'setMedia', m4a: audio.m4a
      mix3Player.jPlayer 'volume', 0
      return

    swfPath: '/swf'
    supplied: 'm4a'
    wmode: 'window'
    smoothPlayBar: true
    keyEnabled: true
    remainingDuration: true
  return

