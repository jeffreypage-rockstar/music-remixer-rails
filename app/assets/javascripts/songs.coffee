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

  readURL = (input) ->
    if (input.files && input.files[0])

      reader = new FileReader()
      reader.onload = (e) ->
        $('.song_image_preview').attr('src', e.target.result);
        return
      reader.readAsDataURL(input.files[0]);
    return

  $('input#song_image').change ->
    readURL(this)
    return
  return

$(document).on 'ready page:load', ->
  if $('#songForm').length > 0
    songFormReady()

  return