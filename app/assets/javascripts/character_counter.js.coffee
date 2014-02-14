$ ->
  $('#newPostTitle').keyup ->
    content_length = $(@).val().length
    $('#titleCharCount').text(content_length)
    if content_length > 249
      $('#titleCharCount').css("color", "#CD0000");
      $('#submitPost').addClass('disabled')
    else
      $('#titleCharCount').css("color", "black");
      $('#submitPost').removeClass('disabled')
      
    # if content_length > 229
    #   $('#newPostTitle').keydown (e) ->
    #     e.preventDefault();
    #     return false;
    # else
    #   $('#newPostTitle').keydown(true)