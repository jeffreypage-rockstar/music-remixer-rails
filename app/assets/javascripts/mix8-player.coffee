@initializePlayer = (jpPlayerSelector, jpAudioSelector) ->
  trackElement = $(jpPlayerSelector).closest('.track')
  mix2Player = trackElement.find('.mix2');
  mix3Player = trackElement.find('.mix3');
  if (/ipad|iphone|ipod|android(?!.*?mobile)/i.test(navigator.userAgent))
    $('.tags button.style').hide()

  trackElement.find('.play').click ->
    $.each $('.mix8-player').find('.jp-player'), (index, player) ->
      $(player).jPlayer('pause')
    trackElement.find('.jp-player').jPlayer('play')
    return

  trackElement.find('.pause').click ->
    trackElement.find('.jp-player').jPlayer('pause')
    return

  trackElement.find('button.style').click (event) ->
    event.stopPropagation()
    style = $(event.target).data('style')
    trackElement.find('button.style').removeClass 'selected'
    $(this).addClass 'selected'
    $.each trackElement.find('.jp-player'), (index, player) ->
      if $(player).hasClass(style)
        $(player).jPlayer('volume', 1)
      else
        $(player).jPlayer('volume', 0)
      return
    return


  $(jpPlayerSelector).jPlayer
    ready: ->
      trackElement.find('.pause').hide()
      trackElement.find('.play').show()
      audio = trackElement.data('audio')
      trackElement.find('.jp-player').jPlayer 'setMedia', m4a: audio.m4a
      return

    play: ->
      trackElement.find('.play').hide()
      trackElement.find('.pause').show()
      return

    pause: ->
      trackElement.find('.pause').hide()
      trackElement.find('.play').show()
      return

    seeked: (event) ->
      if (mix2Player)
        mix2Player.jPlayer 'play', event.jPlayer.status.currentTime
      if (mix3Player)
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
      if !(/ipad|iphone|ipod|android(?!.*?mobile)/i.test(navigator.userAgent))
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
      if !(/ipad|iphone|ipod|android(?!.*?mobile)/i.test(navigator.userAgent))
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

