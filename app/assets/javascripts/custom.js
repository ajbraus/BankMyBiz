String.prototype.supplant = function (o) {
    return this.replace(/{([^{}]*)}/g,
        function (a, b) {
            var r = o[b];
            return typeof r === 'string' || typeof r === 'number' ? r : a;
        }
    );
};

$(document).ready(function() {

  $('body').on('click', 'a.disabled', function(event) {
      event.preventDefault();
  });
  
  $('#new_user').validate({ errorPlacement: function(error, element) {} });
  $(".edit_user").validate({ errorPlacement: function(error, element) {} });

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
      $( this ).html("<i class='icon ion-flask'></i> Uninterested")
    }, function() {
      $( this ).html("<i class='icon ion-flask green'></i> Interested")
    }
  );

  $('.interested').hover(
    function() {
      $( this ).html("<i class='icon ion-flask green'></i> Interested")
    }, function() {
      $( this ).html("<i class='icon ion-flask'></i> Interested")
    }
  );
});