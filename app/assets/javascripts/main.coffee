$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
$ ->
  refVal = GetURLParameter 'ref'
  if refVal == 'verification'
    modal_holder_selector = '#modal-holder';
    modal_selector = '.modal';
    $.get '/session/welcome_modal', (data) ->
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
    showSelectedImage(this)
    return
  return

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