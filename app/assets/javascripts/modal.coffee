$ ->
  modal_holder_selector = '#modal-holder'
  modal_selector = '.modal'

  $(document).on 'click', 'a.share-song[data-modal]', ->
    location = $(this).attr('href')
    $.get location, (data)->
      $(modal_holder_selector).html(data).find(modal_selector).modal()
      clip = new ZeroClipboard($(modal_holder_selector).find('#copy-song-url'))

      initializePlayer '#jquery_jplayer', '#jp_container'
    false