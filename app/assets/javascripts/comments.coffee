$ ->
  $('.comment-reply').click ->
    $(this).closest('.comment').find('.reply-form').toggle()
    return

  $('.comments-tab').click ->
    target = $(this).data('target-url')
    $.get target,
      commentable_id: $(this).data('commentable-id')
      commentable_type: 'Song'
    return true