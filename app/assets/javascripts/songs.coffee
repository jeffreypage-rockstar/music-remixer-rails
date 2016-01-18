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

$(document).ready ->
  $(document.body).on 'click', '.status-event', (e) ->
    status = $(e.target).attr('data-status')
    song_id = $(e.target).attr('data-attributes')
    # var song_id_temp_2=@song.id;
    if status == 'processing_for_release'
      $.ajax(
        type: 'PUT'
        dataType: 'json'
        url: '/songs/' + song_id
        contentType: 'application/json'
        data: JSON.stringify(status: 'released')).done((msg) ->
        console.log 'Data Saved: ' + msg
        $(e.target).attr 'data-status', 'released'
        $(e.target).html 'Unrelease'
        instance = $('td.status[data-attributes=\'' + song_id + '\'] i')
        instance.attr 'title', 'Released'
        instance.attr 'class', 'fa fa-check text-success'
        return
      ).fail (msg) ->
        console.log msg
        return
    else
      $.ajax(
        type: 'PUT'
        dataType: 'json'
        url: '/songs/' + song_id
        contentType: 'application/json'
        data: JSON.stringify(status: 'working')).done((msg) ->
        console.log 'Data Saved: ' + msg
        $(e.target).attr 'data-status', 'working'
        $(e.target).html 'Release'
        instance = $('td.status[data-attributes=\'' + song_id + '\'] i')
        instance.attr 'title', 'Released'
        instance.attr 'class', 'fa fa-clock-o text-warning'
        return
      ).fail (msg) ->
        console.log msg
        return
  return

$(document).ready ->
  $('#confirm-delete').on 'show.bs.modal', (e) ->
    $(this).find('.btn-ok').attr 'data-href', $(e.relatedTarget).data('href')
    $(this).find('.btn-ok').attr 'data-id', $(e.relatedTarget).data('id')
    $('.debug-url').html 'Are you sure you want to permanently delete <strong>' + $(this).find('.btn-ok').attr('data-id') + '</strong>'
    return

