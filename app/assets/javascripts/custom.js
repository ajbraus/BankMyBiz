String.prototype.supplant = function (o) {
    return this.replace(/{([^{}]*)}/g,
        function (a, b) {
            var r = o[b];
            return typeof r === 'string' || typeof r === 'number' ? r : a;
        }
    );
};

$(document).ready(function() {
  $('.alert-disappear').delay(2000).fadeOut();
  $('.fadeInAlert').fadeIn();
  $('.comment-show').click(function() {
    $(this).next('.comment-form').toggle();
    $(this).next('.comment-form').find("#appendedInputButton").focus();
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
      
  // var a = [$('#trendingTags').data("tags")];
  // var colors = ["label-warning", "label-info", "label-success", "label-important", "label-default", "label-inverse"];
  // a.forEach(function(entry) {
  //   var color = colors[Math.floor(Math.random()*colors.length)];
  //   var style = "label " + color
  //   $('#trendingTags').prepend("<span class='" + style + "''>" + entry + "</span>")
  // });

  // $('#closeJumbotron').click(function(){
  //   $('#overview').slideUp();
  // });

  // $('.label').click(function(){
  //  $(this).appendTo('#searchTags');
  // });

  // $('#clearBtn').click(function(){
  //   $('#searchTags').children().prependTo('#topicMenu');
  // });

  // var index;

  // for (index = 0; index < a.length; ++index) {
  //   $('#topicMenu').append("<span class='label label-warning'>" + index + "</span>")
  // }
});