String.prototype.supplant = function (o) {
    return this.replace(/{([^{}]*)}/g,
        function (a, b) {
            var r = o[b];
            return typeof r === 'string' || typeof r === 'number' ? r : a;
        }
    );
};

$(document).ready(function() {
  $('.alert').delay(3000).fadeOut();
  $('.fadeInAlert').fadeIn();
  $('.comment-show').click(function() {
    $(this).hide();
    $(this).next('.comment-form').toggle();
  });
  $("tr[data-link]").click(function() {
    window.location = $(this).data("link")
  })

  $("[rel=tooltip]").tooltip({ placement: 'right'});

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