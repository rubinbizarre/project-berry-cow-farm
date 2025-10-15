function convert_to_mins_and_secs(time) {
	//390
	/// 60 = 6.5
	//round down = min = 6
	//remainder * 60 = sec = 30
	
	var time_as_decimal = time/60;
	var minutes = floor(time_as_decimal);
	var remainder = time_as_decimal - floor(time_as_decimal);
	var seconds = floor(remainder * 60);
	
	return { minutes, seconds };
}

//function convert_time_to_percentage(time) {
//	//390 / 390 = 1
//	//350 / 390 = 0.89
//}