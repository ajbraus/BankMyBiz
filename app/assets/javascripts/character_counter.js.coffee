$ ->
  $('#newPostContent').keyup ->
    content_length = $(@).val().length
    $('#postCharCount').text(content_length)
    if content_length > 249
      $('#postCharCount').css("color", "#CD0000");
      $('#submitPost').addClass('disabled')
    else
      $('#postCharCount').css("color", "black");
      $('#submitPost').removeClass('disabled')
      
    # if content_length > 229
    #   $('#newPostContent').keydown (e) ->
    #     e.preventDefault();
    #     return false;
    # else
    #   $('#newPostContent').keydown(true)