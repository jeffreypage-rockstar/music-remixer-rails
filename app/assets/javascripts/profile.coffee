@artistProfilePageReady = ->
  $.each $('#artistProfilePage .mix8-player'), (index, player) ->
    initializePlayer '#' + $(player).find('.jp-player').prop('id'), '#' + $(player).find('.jp-audio').prop('id')
    return

  $('.mixes-tab').click ->
    target = $(this).data('target-url')
    $.post target,
      id: $(this).data('song-id')
    return true

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

