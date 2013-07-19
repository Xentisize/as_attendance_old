$(document).ready(function() {
  $("input#barcode_input").focus(function() {
    setInterval(function() {
      $('.alert').fadeOut('slow');
    }, 5000);
  }).focus();
  $('button.close').click(function() {
  $('.alert').fadeOut('slow');
});
});

$(document).ready(function(){
  $('#carousel').carousel();
})


// For multiselection of subjects before taking attendance
$(document).ready(function() {
  $('.multiselect').multiselect({
    buttonClass: 'btn',
    buttonWidth: 'auto',
    buttonContainer: '<div class="btn-group" />',
    maxHeight: false,
    buttonText: function(options) {
      if (options.length == 0) {
        return 'None selected <b class="caret"></b>';
      }
      else if (options.length > 3) {
        return options.length + ' selected  <b class="caret"></b>';
      }
      else {
        var selected = '';
        options.each(function() {
          selected += $(this).text() + ', ';
        });
        return selected.substr(0, selected.length -2) + ' <b class="caret"></b>';
      }
    }
  });
});

