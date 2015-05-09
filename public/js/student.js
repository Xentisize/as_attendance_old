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

$(document).ready(function() {

});

$(document).ready(function() {
  // $(".checkout").css({"display": "inline", "margin-left": "10px"});
  $(".checkout_link").click(function(event) {
    current_btn = $(this);
    var attendance_id = $(this).attr('class').split(' ')[1];
    var checkout_url = "/students/checkout/" + attendance_id;
    // var attendance_name = $($(this).parent().parent()[0]).text().split(' ')[0];
    // console.log(attendance_name);
    $.ajax({
      url: checkout_url,
      type: "GET",
      method: "GET",
      success: function() {
        $(current_btn).parent().parent().hide();
        // $('<div>Checkout</div>').insertBefore($(".checkout_list")).css({"background": "pink", "padding": "20px", "margin-bottom": "20px"}).fadeOut(3000);
      }
    });
  });
});

$(document).ready(function() {
  $(".manual-in").click(function(event) {
    current_btn = $(this);
    var student_id = current_btn.attr("class").split(" ")[1];
    var checkin_url = "/students/checkin/" + student_id;
    // console.log(checkin_url);

    $.ajax({
      url: checkin_url,
      type: "GET",
      method: "GET",
      success: function() {
        $("<h3 class='flash notice text-success text-center'>Done</h3>").appendTo($(".container:first-child")).fadeOut(2000);
        setInterval(function() {
          window.location.href = "/students/show";
        }, 3000);
      }
    });
  });
});

$(function() {
  var search = $("#student_search.form-search");
  // console.log(search.size());
  // console.log($(search[0]));
  // console.log(search.size())
  if (search.size() == 2) {
    // console.log("In conditional!");
    $(search[0]).hide();
  }
});

$(function() {
  $("th").each(function() {
    $(this).css("text-align", "center");
  });
  $("td").each(function() {
    $(this).css("text-align", "center");
  });
});


// css
// $(function() {
//   google.load("visualization", "1", {packages:["corechart"]});
//   google.setOnLoadCallback(drawChart);

//   var attendance_data;

//   function getData(student_id) {
//     $.ajax({
//       url: "/students/at_json/" + student_id,
//       type: "GET",
//       method: "GET",
//       success: function() {
//         attendance_data = 
//       }
//     })
//   }

//   function drawChart() {
//     var data = google.visualization.arrayToDataTable([
//       ['Month', 'Number'],




//       ])
//   }

// })



//     $.ajax({
//       url: checkin_url,
//       type: "GET",
//       method: "GET",
//       success: function() {
//         $("<h3 class='flash notice text-success text-center'>Done</h3>").appendTo($(".container:first-child")).fadeOut(2000);
//         setInterval(function() {
//           window.location.href = "/students/show";
//         }, 3000);



// google.load("visualization", "1", {packages:["corechart"]});
//       google.setOnLoadCallback(drawChart);
//       function drawChart() {
//         var data = google.visualization.arrayToDataTable([
//           ['Year', 'Sales', 'Expenses'],
//           ['2004',  1000,      400],
//           ['2005',  1170,      460],
//           ['2006',  660,       1120],
//           ['2007',  1030,      540]
//         ]);

//         var options = {
//           title: 'Company Performance',
//           vAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
//         };

//         var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
//         chart.draw(data, options);
//       }