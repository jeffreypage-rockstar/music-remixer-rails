@referralFormReady = ->
  $('#referral_emails').tagsinput()
  $('#referral_emails').on 'beforeItemAdd', (event) ->
    filter = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/
    unless event.item.match filter
      event.cancel = true
  return

$(document).on 'ready page:load', ->
  if $('#referralForm').length > 0
    referralFormReady()
  return