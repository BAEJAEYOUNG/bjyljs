/***************************************************************************
 * Name     : ksid.date.parseDate
 * Desc     : 
 * @param   : 
 * @returns : 
 * @author  : 
 * @since   : 
 ***************************************************************************/

ksid.date = {};

ksid.date.parseDate = function(input) {
	  var parts = input.split('-');
	  // new Date(year, month [, day [, hours[, minutes[, seconds[, ms]]]]])
	  return new Date(parts[0], parts[1]-1, parts[2]); // Note: months are 0-based
};

/***************************************************************************
 * Name     : ksid.date.isDate
 * Desc     : 문자열이 날자형인지 판단한다. 문자열이 비어있으면 false
 * @param   : str - 문자열
 * @returns : true/false
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.date.isDate = function(str, separator) {
	var sep = separator ? separator : "-";
	var ns = str.split(sep);
	//포맷이  yyyyMMdd or yyyy-MM-dd 인지 확인
	if(ns.length == 1) {
	} else if(ns.length == 3) {
		if(ns[0].length != 4 || ns[1].length !=2 || ns[2].length !=2) {
			return false;
		}
		str = str.split(sep).join("");
	} else { 
		return false;
	}
	if(str.length != 8) {
		return false;
	}
	if(!this.isNumeric(str)) {
		return false;
	}
	var year = Number(str.substring(0, 4));
	var month = Number(str.substring(4, 6));
	var day = Number(str.substring(6, 8));
	if(month < 1 || month > 12) {
		return false;
	}
	var daysOfMonth = [31, ((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; //4,6,9,11=>30
	if(day < 1 || day > daysOfMonth[month-1]) {
		return false;
	}
	return true;
};