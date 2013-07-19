// Labelling the content of leave column
$(document).ready(function()
{
  var row = $('tr:last');
  var cell = $(row).find('td:eq(2)');
  if(cell.text() == "No record") {
    cell.html("<span class='label label-warning'>No record</a>");
  }
});

// Labelling the content of duration column
$(document).ready(function()
{
  var row = $('tr:last');
  var cell = $(row).find('td:eq(3)');
  if(cell.text() == "No record") {
    cell.html("<span class='label label-warning'>No record</a>");
  }
});

$(document).ready(function()
{
  $('i').each(function(index){
    $(this).click(function()
    {
      var match_result = $(this).attr('id').match(/student_(\d+)_attendance_(\d+)/);
      var selected_element = this;
      var student_id = match_result[1];
      var attendance_id = match_result[2];
      var delete_url = "/students/" + student_id + "/attendances/" + attendance_id + "/delete";
      $.ajax({
        url: delete_url,
        type: 'DELETE',
        method: 'DELETE',
        success: function() {
          $(selected_element).parents().eq(2).hide('slow');
          }
        });
      });
    });
  });

// For activating datepicker
$(document).ready(function()
{
  $('#date_selection').daterangepicker();
});


$(document).ready(function()
{
  $('button#filter_button').click(function()
  {
    var date = $('#date_selection').val();
    if (date == '')
    {
      $('td.attend_date').each(function()
      {
        $(this).closest('tr').show();
      });
    }
    var match_result = date.match(/(\d+)\/(\d+)\/(\d+) - (\d+)\/(\d+)\/(\d+)/);
    var start_date = match_result[3] + '-' + match_result[1] + '-' + match_result[2];
    var j_start_date = new Date(start_date);
    var end_date = match_result[6] + '-' + match_result[4] + '-' + match_result[5];
    var j_end_date = new Date(end_date);
    $('td.attend_date').each(function()
    {
      var found = false;
      var attend_date = new Date($(this).text());
      if (attend_date >= j_start_date && attend_date <= j_end_date)
      {
        //alert($(this).closest('tr').text());
        found = true;
        //return false;
        //alert("this is within out attendance period: " + attend_date);
      }
      if (found == true)
      {
        $(this).closest('tr').show();
      } else
      {
        $(this).closest('tr').hide();
      }
    });
  });
});

// Click action on the modal of remarks for attendances (-> in views_helpers.rb)

