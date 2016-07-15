@initializeWavePlayer = (track) ->
  track = $(track)
  track.waveforms = {}
  track.currentStyle = 'original'
  for style in ['original', 'mix2', 'mix3']
    track.waveforms[style] = Object.create(WaveSurfer)
    track.waveforms[style].init({
      container: document.querySelector('#' + track.attr('id') + ' .wave-' + style),
      waveColor: '#999',
      progressColor: '#41c7ff',
      normalize: true,
      pixelRatio: 1
    })
    url = track.data('audio-'+style)
    track.waveforms[style].load(url.m4a)
    track.waveforms[style].on "ready", (wavesurfer) ->
      console.log($(wavesurfer.container).data('style') + " is ready")
      track.find('.pause').hide()
      track.find('.play').show()

    if style != 'original'
      track.waveforms[style].toggleMute()

  track.find('.play').click ->
    for style in ['original', 'mix2', 'mix3']
      track.waveforms[style].playPause()
    track.find('.play').hide()
    track.find('.pause').show()

  track.find('.pause').click ->
    for style in ['original', 'mix2', 'mix3']
      track.waveforms[style].playPause()
    track.find('.pause').hide()
    track.find('.play').show()

  track.find('button.style').click (event) ->
    event.stopPropagation()
    style = $(event.target).data('style')
    if track.currentStyle != style
      track.find('button.style').removeClass 'selected'
      $(this).addClass 'selected'
      track.waveforms[style].toggleMute()
      track.waveforms[track.currentStyle].toggleMute()
      track.currentStyle = style


@artistProfilePageReady = ->
  $.each $('li.media.track'), (index, track) ->
    initializeWavePlayer track
    return

  $('.mixes-tab').click ->
    target = $(this).data('target-url')
    $.post target,
      id: $(this).data('song-id')
    return true
  $('.artist-bio .content').readmore({
    collapsedHeight: 150
  })

  return

@editArtistProfilePageReady = ->
  $('#user_profile_image').filestyle
    icon: false
    badge: false
    input: false
    buttonText: 'Update Profile Image'
    buttonName: 'btn-primary btn-round'

  $('#user_profile_background_image').filestyle
    icon: false
    badge: false
    input: false
    buttonText: 'Update Background Image'
    buttonName: 'btn-primary btn-round'

  $('#user_genre_list').tagsinput()

  return

$(document).on 'ready page:load', ->
  if $('#artistProfilePage').length > 0
    artistProfilePageReady()

  if $('#editArtistProfilePage').length > 0
    editArtistProfilePageReady()

