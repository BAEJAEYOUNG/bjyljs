/****************************************************************
    설명:  javascript object 확장 prototype 정의
        
    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-07-07     배재영        초기작성 
    ------------------------------------------------------
****************************************************************/


/*----------------------------------------------------------
 * 
 * 			-- Number 시작 --
 * 
-----------------------------------------------------------*/


/**
 * 자릿수가 n 인 숫자형으로 반환
 */

/**
 * @package : resources/js/ksid/ksid.prototype.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 1:20:33
 * @method : 자릿수가 n 인 숫자형으로 반환
 * @param n : number
 * @returns : fixed number
 * @사용법 : 1234.567.toNumberFixed(2) >>> 결과 : 1234.56
 *           1234.toNumberFixed(2) >>> 결과 : 1234
 * @주의사항 : 해당 소수점아래의 자리수만 자름
 */
Number.prototype.toNumberFixed = function (n) {
    if (!n || typeof n != "number" || n > 12) return NaN;
    var reck = 1;
    for (var i = 0; i < n; i++) reck *= 10;
    return parseInt(this * reck) / reck;
};

/**
 * 숫자를 한글로 반환 100000.read -> 일십만
 * @returns {String}
 */


/**
 * @package : resources/js/ksid/ksid.prototype.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 1:22:50
 * @method : 숫자를 한글로 반환
 * @returns {String}
 * @사용법 : 1234.read() >>> 결과 : 천이백삼십사
 * @주의사항 : 
 */
Number.prototype.read = function () {
    if (this == 0) return '영';
    var phonemic = ['', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];
    var unit = ['', '', '십', '백', '천', '만', '십만', '백만', '천만', '억', '십억', '백억', '천억', '조', '십조', '백조'];

    var ret = '';
    var part = new Array();
    for (var x = 0; x < String(this).length; x++) part[x] = String(this).substring(x, x + 1);
    for (var i = 0, cnt = String(this).length; cnt > 0; --cnt, ++i) {
        p = phonemic[part[i]];
        p += (p) ? (cnt > 4 && phonemic[part[i + 1]]) ? unit[cnt].substring(0, 1) : unit[cnt] : '';
        ret += p;
    }
    return ret;
};


/*----------------------------------------------------------
 * 
 * 			-- Number 끝 --
 * 
-----------------------------------------------------------*/



/*----------------------------------------------------------
 * 
 * 			-- Date 시작 --
 * 
-----------------------------------------------------------*/

var gsMonthNames = new Array(
	'January',
	'February',
	'March',
	'April',
	'May',
	'June',
	'July',
	'August',
	'September',
	'October',
	'November',
	'December'
);

// a global day names array
var gsDayNames = new Array(
	'Sunday',
	'Monday',
	'Tuesday',
	'Wednesday',
	'Thursday',
	'Friday',
	'Saturday'
);

Date.isLeapYear = function (year) { 
    return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0)); 
};

Date.getDaysInMonth = function (year, month) {
    return [31, (Date.isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
};

Date.prototype.isLeapYear = function () { 
    return Date.isLeapYear(this.getFullYear()); 
};

Date.prototype.getDaysInMonth = function () { 
    return Date.getDaysInMonth(this.getFullYear(), this.getMonth());
};

Date.prototype.addYears = function(value)
{
	var n = value * 12;
    return Date.prototype.addMonths(n);
};

Date.prototype.addMonths = function (value) {
    var n = this.getDate();
    this.setDate(1);
    this.setMonth(this.getMonth() + value);
    this.setDate(Math.min(n, this.getDaysInMonth()));
    return this;
};

Date.prototype.addDays = function(days)
{
    var dat = new Date(this.valueOf());
    dat.setDate(dat.getDate() + days);
    return dat;
};

// the date format prototype
Date.prototype.format = function(f)
{
    if (!this.valueOf())
        return ' ';
 
    var d = this;
 
    return f.replace(/(yyyy|mmmm|mmm|mm|dddd|ddd|dd|hh|nn|ss|a\/p)/gi,
        function($1)
        {
            switch ($1.toLowerCase())
            {
            case 'yyyy': return d.getFullYear();
            case 'mmmm': return gsMonthNames[d.getMonth()];
            case 'mmm':  return gsMonthNames[d.getMonth()].substr(0, 3);
            case 'mm':   return (d.getMonth() + 1).zf(2);
            case 'dddd': return gsDayNames[d.getDay()];
            case 'ddd':  return gsDayNames[d.getDay()].substr(0, 3);
            case 'dd':   return d.getDate().zf(2);
            case 'hh':   return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case 'nn':   return d.getMinutes().zf(2);
            case 'ss':   return d.getSeconds().zf(2);
            case 'a/p':  return d.getHours() < 12 ? 'a' : 'p';
            }
        }
    );
};

/*----------------------------------------------------------
 * 
 * 			-- Date 끝 --
 * 
-----------------------------------------------------------*/

