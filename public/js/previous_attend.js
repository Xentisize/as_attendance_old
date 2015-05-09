$(function() {
	$(".attend_dates").css("margin-left", "5px");
	$($("th")[0]).width("120");
	$($("th")[1]).width("100");
	$(".attend_number").css("text-align", "center");
	$(".attend_number").each(function() {
		if($(this).html() == 0) {
			$(this).parent().parent().hide();
		}
	});
});