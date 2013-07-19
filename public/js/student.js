/*$("#cancel").click(function(event) {
  event.preventDefault();
  window.history.back();
  return false;
});*/

$(document).ready(function()
{
  function cancel(cancel)
  {
    if(cancel == 'cancel')
    {
      $('input').each(function()
      {
        $(this).val() = '';
      });
      window.location.href = '/students/new';
    }
  }
});


$(document).ready(function()
{
  $("#students_name_filter").keyup(function()
  {
    searchTable($(this).val());
  });
});



function searchTable(inputVal)
{
  var table = $("table#students_list_table");
  table.find('tr').each(function(index, row)
    {
      var allCells = $(row).find('td');
      if (allCells.length > 0)
      {
        var found = false;
        allCells.each(function(index, td)
        {
          var regExp = new RegExp(inputVal, 'i');
          if (regExp.test($(td).text()))
          {
            found = true;
            return false;
          }
        });

        if (found == true) {
          $(row).show();
        } else {
          $(row).hide();
        }
      }
    });
}

$(document).ready(function()
{
  $('#student_search').insertBefore('table');
  $('caption').hide();
}
);


$(document).ready(function()
{
  $('button.update_student_form').click(function()
  {
    var match_result = $(this).attr('id').match(/student_(\d+)/);
    var student_id = match_result[1];
    var update_url = "/students/show/" + student_id + "/update";
    window.location.href = update_url;
    //TODO: All cancel button utilized window.location is not okay at
  });
});



//TODO: Referer input needs to modify to make it work.
/*
$(document).ready(function()
{
  $('#student_refer_from').typeahead(
  {
    source: function(query, process)
    {
      return $.ajax(
      {
        url: 'students/names_array',
        type: 'get',
        data: { query: query}
        dataType: 'json',
        success: function(json)
        {
          return typeof json.options == 'undefined' ? false : process(json.options);
        }
      });
    }
  });
});

/*$('button:first').click(function()
{
  alert('x');
  //var match_result = $(this).attr('id').match(/student_(\d+)/);
  //var student_id = match_result[1];
  //var update_url = "/students/show/" + student_id + "/update";
  /*$.ajax(
  {
    url: update_url,
    type: 'PUT',
    method: 'PUT',
  });
});*/

