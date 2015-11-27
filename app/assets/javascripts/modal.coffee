$ ->
  modal_holder_selector = '#modal-holder'
  modal_selector = '.modal'

  $(document).on 'click', 'a.share-song[data-modal]', ->
    location = $(this).attr('href')
    $.get location, (data)->
      $(modal_holder_selector).html(data).find(modal_selector).modal()
      clip = new ZeroClipboard($(modal_holder_selector).find('#copy-song-url'))

      initializePlayer '#jquery_jplayer', '#jp_container'

      $(modal_holder_selector).find('.social-share-link').click ->
        shareTrackUrl = $(this).closest('.social-share-links').data('shareTrackUrl')
        $.post shareTrackUrl, { channel: $(this).data('channel') }, (data) ->
          return
        return
      return
    false