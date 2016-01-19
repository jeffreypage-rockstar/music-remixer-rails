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
    song_bpm= $(e.target).attr('data-bpm')
    if status == 'working'
      if song_bpm != '0'
        $(e.target).attr 'data-status', 'processing_for_release'
        $(e.target).html ''
        instance_temp = $('td.status[data-attributes=\'' + song_id + '\'] i')
        instance_temp.attr 'title', 'Processing For Release'
        instance_temp.attr 'class', 'fa fa-cog text-warning'
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
        $('.alert-custom').html '<div class=\'alert alert-info alert-dismissible\' role=\'alert\'><button type=\'button\' class=\'close\' data-dismiss=\'alert\' aria-label=\'Close\'><span aria-hidden=\'true\'>×</span></button><p style=\'margin: 0;\'>Please specify a BPM.</p></div>'            
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