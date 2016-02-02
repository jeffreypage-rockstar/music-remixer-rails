uploadable = []
paramNames = []
uploadProgressBox = null

@songFormReady = ->
  $('#song_image').filestyle
    icon: false
    badge: false
    input: false
    buttonText: 'Update Image'
    buttonName: 'btn-primary btn-round'

  $('#song_zipfile').filestyle
    icon: false
    badge: false
    input: false
    buttonText: 'Update Zipfile'
    buttonName: 'btn-primary btn-round'

  $('#song_genre_list').tagsinput()

  $('#songForm').fileupload(
    autoUpload: false
    singleFileUploads: false
    add: (event, data) ->
      uploadable.push data.files[0]
      paramNames.push(event.delegatedEvent.target.name);
      false
    send: ->
      submitSong = $('#songForm [type="submit"]')
      submitSong.attr('data-loading', true)
      submitSong.attr('disabled', true)

      uploadProgressBox = Lobibox.progress(
        title: 'Please wait'
        label: 'Uploading files...'
      )
      return
    done: (event, data) ->
      location.href = data.result.redirect_url
      return
    fail: (event, data) ->
      $('#newArtistSongPage .song').html(data.jqXHR.responseText)
      songFormReady()
      return
    always: ->
      submitSong = $('#songForm [type="submit"]')
      submitSong.attr('data-loading', false)
      submitSong.attr('disabled', false)
      uploadProgressBox.hide()
      return
    progress: (event, data) ->
      uploadProgressBox.setProgress(data.loaded / data.total * 100)
      return
  )

  $('#songForm').submit (event) ->
    event.preventDefault()
    $('#songForm').fileupload 'send',
      files: uploadable
      paramName: paramNames
#      formData: [
#        { name: 'authenticity_token', value: $('meta[name="csrf-token"]').attr('content') }
#      ]
    return

  showSelectedFileName = (input) ->
    fullPath = $(input).val()
    if fullPath
      startIndex = if fullPath.indexOf('\\') >= 0 then fullPath.lastIndexOf('\\') else fullPath.lastIndexOf('/')
      filename = fullPath.substring(startIndex)
      if filename.indexOf('\\') == 0 or filename.indexOf('/') == 0
        filename = filename.substring(1)
      $('.song_zipfile_filename').html(filename)
    return

  $('input#song_zipfile').change ->
    showSelectedFileName(this)
    return

  return

$(document).on 'ready page:load', ->
  if $('#songForm').length > 0
    songFormReady() 

  return

$ ->
  $('[rel="popover"]').popover(
    container: 'body'
    html: true
    content: ->
      clone = $($(this).data('popover-content')).clone(true).removeClass('hide')
      clone
  ).click (e) ->
    $(".missing_file_pop").attr 'data-id', @id
    e.preventDefault();
    $(this).focus();
    return
  return

$(document).on 'ready page:load', ->
  $('.missing_file_pop li').click ->
    $('.alert-custom').css display: 'none'
    bad_clip_id = @id
    blank_id = $(this).parent().attr 'data-id'
    row = $('#' + blank_id).attr('data-row')
    col = $('#' + blank_id).attr('data-col')
    blank_duration = $('#' + blank_id).attr('data-duration')
    file_duration = $(this).attr('data-duration')
    song_id = $('#song-clips').attr('data-id')
    if blank_duration == file_duration
      $.ajax
        type: 'PUT'
        dataType: 'json'
        url: '/songs/'+song_id+'/clips/'+bad_clip_id
        contentType: 'application/json'
        data: JSON.stringify(clip: {row: row, column: col})
        error: (jqXHR, textStatus, errorThrown) ->
          alert textStatus
        success: (data, textStatus, jqXHR) ->
          $('.alert-custom').css display: 'block'
          $('.alert-custom').html("<div class='alert alert-info alert-dismissible' role='alert'><button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>×</span></button><p style='margin: 0;'>File successfully placed.</p></div>");
          location.reload()
    else
      $('.alert-custom').css display: 'block'
      $('.alert-custom').html("<div class='alert alert-info alert-dismissible' role='alert'><button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>×</span></button><p style='margin: 0;'>File cannot be placed here.</p></div>");
    return
  return