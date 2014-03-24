$.fn.withPostId = (id) ->
  @filter ->
    $(this).data('post-id') == id

$.fn.withAnswerId = (iid) ->
  @filter ->
    $(this).data('answer-id') == iid

$.fn.withCommentId = (uid) ->
  @filter ->
    $(this).data('comment-id') == uid
    