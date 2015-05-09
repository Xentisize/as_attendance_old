//Tab Control

$(document).ready(function()
{
  var current_tab;
  var tabs = $('ul.nav > li');
  tabs.each(function(index)
  {
    $(this).click(function()
    {
      current_tab = $('.active');
      $(current_tab).removeClass("active");
      $(this).addClass("active");
    });
  });
  //return false;
});

