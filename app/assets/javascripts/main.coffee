$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
$ ->
  refVal = GetURLParameter 'ref'
  if refVal == 'confirm_email'
    modal_holder_selector = '#modal-holder';
    modal_selector = '.modal';
    $.get '/welcome_modal', (data) ->
      $(modal_holder_selector).html(data).find(modal_selector).modal()
      return

  showSelectedImage = (input) ->
    if (input.files && input.files[0])

      reader = new FileReader()
      reader.onload = (e) ->
        $('#' + input.id + '_preview').attr('src', e.target.result)
        return
      reader.readAsDataURL(input.files[0]);
    return

  $('input.image-input').change ->
    if validateImageFileInput(this)
      showSelectedImage(this)
    return
  return


_validFileExtensions = [
  '.jpg'
  '.jpeg'
  '.gif'
  '.png'
]

validateImageFileInput = (oInput) ->
  if oInput.type == 'file'
    sFileName = oInput.value
    if sFileName.length > 0
      blnValid = false
      j = 0
      while j < _validFileExtensions.length
        sCurExtension = _validFileExtensions[j]
        if sFileName.substr(sFileName.length - (sCurExtension.length), sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()
          blnValid = true
          break
        j++
      if !blnValid
        alert 'Sorry, ' + sFileName + ' is invalid, allowed extensions are: ' + _validFileExtensions.join(', ')
        oInput.value = ''
        return false
  true

GetURLParameter = (sParam) ->
  sPageURL = window.location.search.substring(1)
  sURLVariables = sPageURL.split('&')
  i = 0
  while i < sURLVariables.length
    sParameterName = sURLVariables[i].split('=')
    if sParameterName[0] == sParam
      return sParameterName[1]
    i++
  return