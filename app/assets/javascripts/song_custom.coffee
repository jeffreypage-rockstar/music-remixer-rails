$(document.body).on 'click', '.status-event', (e) ->
  status = $(e.target).attr('data-status')
  song_id = $(e.target).attr('data-attributes')
  # var song_id_temp_2=@song.id;
  if status == 'pending'
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
      data: JSON.stringify(status: 'pending')).done((msg) ->
      console.log 'Data Saved: ' + msg
      $(e.target).attr 'data-status', 'pending'
      $(e.target).html 'Release'
      instance = $('td.status[data-attributes=\'' + song_id + '\'] i')
      instance.attr 'title', 'Released'
      instance.attr 'class', 'fa fa-clock-o text-warning'
      return
    ).fail (msg) ->
      console.log msg
      return
  return