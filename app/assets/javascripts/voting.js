$('.vote-up').click(function(){
  $(this).addClass("green disabled").removeClass("fade-in-green");
  $(this).siblings(".vote-down").removeClass("orange disabled").addClass("fade-in-orange");
  var oldValue = $(this).siblings(".vote-count").text();
  $(this).siblings(".vote-count").text(parseFloat(oldValue) + 1);
});

$('.vote-down').click(function(){
  $(this).addClass("orange disabled").removeClass("fade-in-orange");
  $(this).siblings(".vote-up").removeClass("green disabled").addClass("fade-in-green");
  var oldValue = $(this).siblings(".vote-count").text();
  $(this).siblings(".vote-count").text(parseFloat(oldValue) - 1);
});
