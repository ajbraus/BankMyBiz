String.prototype.supplant = function (o) {
    return this.replace(/{([^{}]*)}/g,
        function (a, b) {
            var r = o[b];
            return typeof r === 'string' || typeof r === 'number' ? r : a;
        }
    );
};

$(document).ready(function() {
  $('#phone').mask('(999) 999 - 9999');
  $('#user_zip_code').mask('99999');

  $("#new_post").focusin(function() {
    $("#questionForm").slideDown();
    $("#closePost").fadeIn();
  });

  $("#closePost").click(function() {
    $("#questionForm").slideUp();
    $("#closePost").fadeOut();
  });

  // $("#new_post").blur(function() {
  //   $("#questionForm").slideUp();
  // });
  

   $("button").dblclick(function (event) {  
    preventDefault()
   });

  $('body').on('click', 'a.disabled', function(event) {
    event.preventDefault();
  });
  
  $('#new_user').validate({ 
    errorPlacement: function(error, element) {}
  });
  $(".edit_user").validate({ 
    errorPlacement: function(error, element) {} 
  });

  $('.alert-disappear').delay(2000).fadeOut();
  $('.fadeInAlert').fadeIn();
  $('.comment-show').click(function() {
    $('.comment-form').hide();
    $(this).parent().next('.comment-form').toggle();
    $(this).parent().next('.comment-form').find("#appendedInputButton").focus();
  });

  $("tr[data-link]").click(function() {
    window.location = $(this).data("link")
  })

  $("[rel=tooltip]").tooltip({ placement: 'right'});               

  $("#selectEntireUS").click(function() {
    $(".state:checked").trigger('click');
  });

  $(".state").click(function() {
    $("#EntireUS:checked").trigger('click');
  });
      
  $('.not-interested').hover(
    function() {
      $( this ).html("<i class='icon ion-ios7-bookmarks-outline'></i> Remove")
    }, function() {
      $( this ).html("<i class='icon ion-ios7-bookmarks green'></i> In Pipeline")
    }
  );
});