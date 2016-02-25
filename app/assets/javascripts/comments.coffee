$ ->
  $('.comments-tab').click ->
    target = $(this).data('target-url')
    $.get target,
      commentable_id: $(this).data('commentable-id')
      commentable_type: $(this).data('commentable-type')
    return true