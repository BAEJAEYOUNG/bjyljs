/****************************************************************
    설명:  문자, 문자열 관련 함수

    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성
    ------------------------------------------------------
****************************************************************/


ksid.string = {};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 10:55:17
 * @method : ksid.string.left	: inputStr 문자열의 왼쪽에서 size 크기만큼 가져온다.
 * @param inputStr	: 입력문자열
 * @param size		: left 에서 자를 size
 * @returns string
 * @사용법 : ksid.string.left('가나다라마바사', 3) >>> 결과 : '가나다'
 */
ksid.string.left = function(inputStr, size) {
    try {
        if (inputStr.length < size) {
            return inputStr;
        } else {
            return inputStr.substring(0, size);
        }
    } catch(e) {
        return "";
    }
};

/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:06:39
 * @method : inputStr 문자열의 오른쪽에서 size 크기만큼 가져온다.
 * @param inputStr	: 입력문자열
 * @param size		: left 에서 자를 size
 * @returns string
 * @사용법 : ksid.string.right('가나다라마바사', 3) >>> 결과 : '마바사'
 */
ksid.string.right = function(inputStr, size) {
    try {
        if (inputStr.length < size) {
            return inputStr;
        } else {
            return inputStr.substring(inputStr.length - size);
        }
    } catch(e) {
        return "";
    }
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:08:09
 * @method : 왼쪽 공백 또는 특정 문자열을 제거한다.
 * @param inputStr	: 대상 문자열
 * @param removeStr	: 제거 문자열
 * @returns string
 * @사용법 : ksid.string.ltrim('   가나다') >>> result = '가나다'
 *           ksid.string.ltrim(' $$$$  가나다', '$') >>> 결과 : '가나다'
 */
ksid.string.ltrim = function(inputStr, removeStr) {
    inputStr = inputStr + "";
    if(inputStr) {
        var returnStr = inputStr.replace(/\s+$/g, "");
        if(removeStr) {
            while( ksid.string.left(returnStr, removeStr.length) == removeStr ) {
                if( returnStr.length < removeStr.length || ksid.string.left(returnStr, removeStr.length) != removeStr ) break;
                returnStr = returnStr.substring(removeStr.length);
            }
        }
        return returnStr;
    } else {
        return "";
    }
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:16:00
 * @method : 오른쪽 공백 또는 특정 문자열을 제거한다.
 * @param inputStr	: 대상 문자열
 * @param removeStr	: 제거 문자열
 * @returns string
 * @사용법 : ksid.string.rtrim('가나다    ') >>> result = '가나다'
 *           ksid.string.rtrim('가나다  $$$$  ', '$') >>> 결과 : '가나다'
 */
ksid.string.rtrim = function(inputStr, removeStr) {
    inputStr = inputStr + "";
    if(inputStr) {
        var returnStr = inputStr.replace(/^\s+/g, "");
        if(removeStr) {
            while( ksid.string.right(returnStr, removeStr.length) == removeStr ) {
                if( returnStr.length < removeStr.length || ksid.string.right(returnStr, removeStr.length) != removeStr ) break;
                returnStr = returnStr.substring(0, returnStr.length - removeStr.length);
            }
        }
        return returnStr;
    } else {
        return "";
    }
};

/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:17:56
 * @method : 양쪽 공백 또는 특정 문자열을 제거한다.
 * @param inputStr	: 대상 문자열
 * @param removeStr	: 제거 문자열
 * @returns string
  * @사용법 : ksid.string.trim('    가나다    ') >>> result = '가나다'
 *            ksid.string.trim('  $$$$$   가나다  $$$$  ', '$') >>> 결과 : '가나다'
 */
ksid.string.trim = function(inputStr, removeStr) {
    return ksid.string.rtrim(ksid.string.ltrim(inputStr, removeStr), removeStr);
};

/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:19:00
 * @method : 입력문자열을 전체길이만큼 왼쪽에 채울문자로 채운다
 * 주의사항 : fillStr 한자리만 사용해야함
 * @param inputStr	: 입력문자열
 * @param fillStr	: 채울문자
 * @param size		: 전체길이
 * @returns {returnStr}
 * @사용법 : ksid.string.lpad( '123', 5 ) >>> 결과 : '  123'
 * 		     ksid.string.lpad( '123', 5 , '0' ) >>> 결과 : '00123'
 */
ksid.string.lpad = function(inputStr, size, fillStr) {
    inputStr = inputStr + "";
    if( typeof(size) == "string" ) return ksid.string.lpad(inputStr, fillStr, size)
    if(!fillStr) {
        fillStr = " ";
    }

    var returnStr = ksid.string.trim(inputStr.toString());

    while (returnStr.length < size) {
        returnStr = fillStr + returnStr;
    }

    return returnStr;
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:30:10
 * @method : 입력문자열을 전체길이만큼 오른쪽에 채울문자로 채운다
 * @param inputStr	: 입력문자열
 * @param size		: 전체길이
 * @param fillStr	: 채울문자
 * @returns {returnStr}
 * @사용법 : ksid.string.rpad( '123', 5 ) >>> 결과 : '123  '
 * 		     ksid.string.rpad( '123', 5 , '0' ) >>> 결과 : '123  '
 * @주의사항 :
 */
ksid.string.rpad = function(inputStr, size, fillStr) {
    inputStr = inputStr + "";
    if( typeof(size) == "string" ) return ksid.string.rpad(inputStr, fillStr, size)
    if(!fillStr) {
        fillStr = " ";
    }

    var returnStr = ksid.string.trim(inputStr.toString());

    while (returnStr.length < size) {
        returnStr = returnStr + fillStr;
    }

    return returnStr;
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:38:15
 * @method : 입력문자열에서 타겟문자를 대체문자로 바꾼다
 * @param inputStr	: 입력문자열
 * @param targetStr	: 타겟문자
 * @param replaceStr: 대체문자
 * @returns
 * @사용법 : ksid.string.replace( '가나다가나다', '가' , '0' ) >>> 결과 : '0나다0나다'
 * @주의사항 :
 */
ksid.string.replace = function(inputStr, targetStr, replaceStr) {
    return inputStr.split(targetStr).join(replaceStr);
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:40:30
 * @method : 숫자만 남기고 모두 지운다
 * @param inputStr	: 입력문자열
 * @returns string
 * @사용법 : ksid.string.forceNumber(01-234,567==89) >>> 결과 : 0123456789
 * @주의사항 :
 */
ksid.string.forceNumber = function(inputStr) {
    try {
        return inputStr.replace(/[^0-9]/g, '');
    } catch(e) {
        return "";
    }
};

/**
 * 숫자이외의 모든 값을 제거한 결과를 반환. 0000234 값이 표현된다.
 * @param sourceStr
 * @returns
 */


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 1:29:14
 * @method : 숫자 . 이외의 모든 값을 제거한 결과를 반환
 * @param inputStr
 * @returns string
 * @사용법 : ksid.string.forceDecimal("123가나다.23오") >>> 결과 : 123.23
 *           ksid.string.forceDecimal("000123가나다.23오") >>> 결과 : 000123.23
 * @주의사항 :
 */
ksid.string.forceDecimal = function(inputStr) {
    try {
        return inputStr.replace(/[^0-9\.]/g, '');
    } catch(e) {
        return "";
    }
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 1:31:22
 * @method : 전화번호 형식 표시
 * @param inputStr	: 입력번호
 * @param separator	: 구분값(default '-')
 * @사용법 : ksid.string.formatTelNo(01011112222) >>> 결과 : 010-1111-2222
 * @주의사항 :
 */
ksid.string.formatTelNo = function(inputStr, separator) {

    separator = (separator) ? separator : "-";

    var returnStr = ksid.string.forceNumber(inputStr);

    if(returnStr.length > 12 ) {
        returnStr = ksid.string.left(returnStr, 12);
    }

    if(returnStr.length >= 9 ) {
        returnStr = returnStr.replace(/(^02.{0}|^0.{2}|[0-9]{3})([0-9]{1,})([0-9]{4})/,"$1" + separator + "$2" + separator + "$3");
    } else if( returnStr.length > 5  ) {
        returnStr = returnStr.replace(/(^02.{0}|^0.{2}|[0-9]{3})([0-9]{3,4})([0-9]{0,})/,"$1" + separator + "$2" + separator + "$3");
    } else if( returnStr.length > 3  ) {
        returnStr = returnStr.replace(/(^02.{0}|^0.{2}|[0-9]{3})([0-9]{0,})/,"$1" + separator + "$2");
    }
    return ksid.string.rtrim(returnStr, separator);

};


/**
 * 사업자번호 형식 표시
 * @param inputStr
 * @param separator
 * @returns {String}
 */


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 2:25:32
 * @method : 사업자번호 형식 표시
 * @param inputVal : 입력값
 * @param separator : 구분자 ( default '-' )
 * @returns string
 * @사용법 : ksid.string.formatBizNo(1112233333) >>> 결과 : 111-22-33333
 * @주의사항 :
 */
ksid.string.formatBizNo = function( inputStr, separator ) {

    separator = (separator) ? separator : "-";

    var returnStr = ksid.string.forceNumber(inputStr);

    if(returnStr.length > 10 ) {
        returnStr = ksid.string.left(returnStr, 10);
    }

    if( returnStr.length >= 10  ) {
        returnStr = returnStr.substring(0, 3) + separator + returnStr.substring(3, 5) + separator + returnStr.substring(5, 10);
    } else if( returnStr.length >= 6  ) {
        returnStr = returnStr.substring(0, 3) + separator + returnStr.substring(3, 5) + separator + returnStr.substring(5);
    } else if( returnStr.length > 3  ) {
        returnStr = returnStr.substring(0, 3) + separator + returnStr.substring(3);
    }

    return ksid.string.rtrim(returnStr, separator);
};

/** 카드번호 포멧팅 **/
ksid.string.formatCardNo = function( inputStr, separator ) {

    separator = (separator) ? separator : "-";

    var returnStr = ksid.string.forceNumber(inputStr);

    if( returnStr.length >= 17  ) {
        returnStr = returnStr.substring(0, 4) + separator + returnStr.substring(4, 8) + separator + returnStr.substring(8, 12) + separator + returnStr.substring(12, 16) + separator + returnStr.substring(16);
    } else if( returnStr.length >= 13  ) {
        returnStr = returnStr.substring(0, 4) + separator + returnStr.substring(4, 8) + separator + returnStr.substring(8, 12) + separator + returnStr.substring(12);
    } else if( returnStr.length >= 9  ) {
        returnStr = returnStr.substring(0, 4) + separator + returnStr.substring(4, 8) + separator + returnStr.substring(8);
    } else if( returnStr.length >= 5  ) {
        returnStr = returnStr.substring(0, 4) + separator + returnStr.substring(4);
    }

    return ksid.string.rtrim(returnStr, separator);
};



/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 2:25:32
 * @method : 사업자번호 형식 표시
 * @param inputVal : 입력값
 * @param separator : 구분자 ( default '-' )
 * @returns string
 * @사용법 : ksid.string.formatBizNo(1112233333) >>> 결과 : 111-22-33333
 * @주의사항 :
 */
ksid.string.formatZipNo = function( inputStr, separator ) {

    separator = (separator) ? separator : "-";

    var returnStr = ksid.string.forceNumber(inputStr);

    if(returnStr.length > 6 ) {
        returnStr = ksid.string.left(returnStr, 6);
    }

    if( returnStr.length >= 6  ) {
        returnStr = returnStr.substring(0, 3) + separator + returnStr.substring(3, 6);
    } else if( returnStr.length > 3  ) {
        returnStr = returnStr.substring(0, 3) + separator + returnStr.substring(3);
    }

    return ksid.string.rtrim(returnStr, separator);
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 1:41:54
 * @method : 통화 형식 표시(3자리 마다 콤마 찍기)
 * @param inputVal : 입력값
 * @returns string
 * @사용법 : ksid.string.formatNumber('1234567890') >>> 결과 : 1.234.567.890
 *           ksid.string.formatNumber('1234abc567가나890') >>> 결과 : 1.234.567.890
 * @주의사항 :
 */
ksid.string.formatNumber = function(inputVal) {
    try {
        var returnStr = ksid.number.toNumber(inputVal).toString();

        return $.number(returnStr);
    } catch(e) {
        return "0";
    }
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 1:49:32
 * @method : 통화형식 표현 - 세계통화표현형식 반환
 * @param inputVal : 입력값
 * @param digit : 자리수
 * @returns
 * @사용법 : ksid.string.formatDecimal(1234567.890) >>> 결과 : 1234567.89
 *           ksid.string.formatDecimal(1234567) >>> 결과 : 1234567.00
 *           ksid.string.formatDecimal(1234567.8) >>> 결과 : 1234567.80
 *           ksid.string.formatDecimal(1234567.12, 4) >>> 결과 : 1234567.1200
 * @주의사항 :
 */
ksid.string.formatDecimal = function(inputVal, digit) {
    if(!digit) digit = 2;

    try {
        var returnStr = ksid.string.forceDecimal(inputVal.toString());
        var inputArray = returnStr.split('.');

        var str1 = ksid.string.formatNumber(inputArray[0]);


        if(inputArray.length == 0) {
            inputArray[1] = "0";
        }

        var str2 = ksid.string.rpad(inputArray[1], digit, "0");
        str2 = ksid.string.right(str2, digit);

        return str1 + "." + str2;
    } catch (e) {
        return $.number(0, digit);
    }
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 3:13:31
 * @method : 백분율등 특정자리수에 소수점이하 자리수를 fix해서 표시
 * @param inputVal : 입력값
 * @param size : 전체자리수
 * @param digit : 소수점이하자리수
 * @returns {String}
 * @사용법 : ksid.string.formatRate(15475.2358) >>> 결과 : 75.23
 * @주의사항 :
 */
ksid.string.formatRate = function( inputVal, size, digit ) {

    if(!size) size = 5;
    if(!digit) digit = 2;
    if(!inputVal) inputVal="";

//	alert("inputVal = " + inputVal);

    try {

        var inputArray = inputVal.toString().split('.');
        var returnVal = ksid.number.toDecimal(inputVal).toString();


//		alert("returnVal = " + returnVal);

        var str1 = ksid.string.formatNumber(inputArray[0]);

        if(typeof(inputArray[1]) == "undefined") {
            inputArray[1] = "0";
        }

//		alert('inputArray[1] = ' + inputArray[1]);

        var str2 = ksid.string.rpad(inputArray[1], digit, "0");
        str2 = ksid.string.left(str2, digit);

        var str1Size = size - str2.length;

        str1Num = ksid.number.toNumber(str1);

//		alert("str1Num = " + str1Num);
//        alert("str2 = " + str2);

        if( str1Num > Math.pow(10, (str1Size-1)) ) {
            str1Num = str1Num % Math.pow(10, (str1Size-1));
        }

        return str1Num + "." + str2;

    } catch (e) {
        alert(e);
        return "";

    }



};

/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 2:03:07
 * @method : 날짜 형식 변환
 * @param inputStr	: 입력문자열
 * @param separator : 구분자
 * @returns string
 * @사용법 : ksid.string.formatDate('20150710') >>> 결과 : 2015-07-10
 * @주의사항 :
 */
ksid.string.formatDate = function(inputStr, separator) {
    if(!separator) separator = "-";
    try {
//	    alert('inputStr = ' + inputStr + " : inputStr.length = " + inputStr.length);
        if(inputStr.length < 8) return inputStr;
        inputStr = ksid.string.replace(inputStr, separator, '' );
        return ksid.string.left(inputStr, 4) + separator + inputStr.substring(4, 6) + separator + inputStr.substring(6);
    } catch (e) {
        if( !inputStr ) {
            return "";
        } else {
            return inputStr;
        }
    }
};

/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 2:03:07
 * @method : 날짜 형식 변환
 * @param inputStr  : 입력문자열
 * @param separator : 구분자
 * @returns string
 * @사용법 : ksid.string.formatDate('20150710') >>> 결과 : 2015-07-10
 * @주의사항 :
 */
ksid.string.formatYm = function(inputStr, separator) {
    if(!separator) separator = "-";
    var numStr = inputStr.replace(/[^0-9\.]/g, '');
    var rtnStr;
    if(numStr.length <= 4) {
        rtnStr = inputStr;
    } else if(numStr.length <= 6) {
        rtnStr = ksid.string.left(numStr, 4) + separator + numStr.substring(4);
    } else {
        rtnStr = ksid.string.left(numStr, 4) + separator + numStr.substring(4, 6);
    }
    return rtnStr;
};



/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-jiyun
 * @dage : 2015. 7. 10. 오후 2:03:07
 * @method : 날짜 형식 변환
 * @param inputStr  : 입력문자열
 * @param separator : 구분자
 * @returns string
 * @사용법 : ksid.string.formatDate('20150710') >>> 결과 : 2015-07-10
 * @주의사항 :
 */
ksid.string.formatYmdh = function(inputStr, separator) {
    if(!separator) separator = "-";
    try {
        if(inputStr.length == 6) {
            inputStr = ksid.string.replace(inputStr, separator, '' );
            return ksid.string.left(inputStr, 4) + separator + inputStr.substring(4, 6);
        } else if(inputStr.length == 8) {
            inputStr = ksid.string.replace(inputStr, separator, '' );
            return ksid.string.left(inputStr, 4) + separator + inputStr.substring(4, 6) + separator + inputStr.substring(6);
        } else if(inputStr.length == 10) {
            inputStr = ksid.string.replace(inputStr, separator, '' );
            return ksid.string.left(inputStr, 4) + separator + inputStr.substring(4, 6) + separator + inputStr.substring(6, 8) + " " + inputStr.substring(8);
        } else {
            return inputStr;
        }

    } catch (e) {
        if( !inputStr ) {
            return "";
        } else {
            return inputStr;
        }
    }
};

/**
 * 시간 형식 변환
 * @param inputStr
 * @param separator
 * @returns {String}
 */


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 2:05:14
 * @method : 시간 형식 변환
 * @param inputStr	: 입력문자열
 * @param separator : 구분자
 * @returns
 * @사용법 : ksid.string.formatTime('0820') >>> 결과 : 08:20
 *           ksid.string.formatTime('082011') >>> 결과 : 08:20:11
 * @주의사항 :
 */
ksid.string.formatTime = function( inputStr, separator ) {
    if(!separator) separator = ":";
    if(!inputStr) inputStr = "";
    var thisStr = "";

    if(isNaN(inputStr)){
        thisStr = inputStr;
    }else{
        thisStr = inputStr.toString();
    }

    try {
        if (thisStr.length == 6) {
            return ksid.string.left(thisStr, 2) + separator + thisStr.substring(2, 4) + separator + thisStr.substring(4);
        } else if( thisStr.length == 4 ) {
            return ksid.string.left(thisStr, 2) + separator + thisStr.substring(2);
        } else {
            return "";
        }
    } catch (e) {
        return "";
    }
};

ksid.string.formatDttm = function(inputStr, separatorDate, separatorTime) {
    if(!separatorDate) separatorDate = "-";
    if(!separatorTime) separatorTime = ":";
    var rtnStr = "";
    try {
        inputStr = ksid.string.forceNumber(inputStr);
        if(inputStr.length == 10) {
            inputStr = ksid.string.trim(inputStr);
            rtnStr = ksid.string.left(inputStr, 4) + separatorDate + inputStr.substring(4, 6) + separatorDate + inputStr.substring(6, 8) + " " + inputStr.substring(8, 10);
        } else if(inputStr.length == 12) {
            inputStr = ksid.string.trim(inputStr);
            rtnStr = ksid.string.left(inputStr, 4) + separatorDate + inputStr.substring(4, 6) + separatorDate + inputStr.substring(6, 8) + " " + inputStr.substring(8, 10) + separatorTime + inputStr.substring(10) ;
        } else if(inputStr.length == 14) {
            inputStr = ksid.string.trim(inputStr);
            rtnStr = ksid.string.left(inputStr, 4) + separatorDate + inputStr.substring(4, 6) + separatorDate + inputStr.substring(6, 8) + " " + inputStr.substring(8, 10) + separatorTime + inputStr.substring(10, 12) + separatorTime + inputStr.substring(12);
        } else {
            return "";
        }
    } catch (e) {

    }
    return rtnStr;
};


/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오후 2:15:07
 * @method : 파일크를 형식표기
 * @param inputVal : 입력값
 * @returns {String}
 * @사용법 : ksid.string.formatBitUnit('1234567890') >>> 결과 : 1.15 GB
 * @주의사항 :
 */
ksid.string.formatBitUnit = function(inputVal) {
    var returnStr = "";

    var size = ksid.number.toNumber(inputVal);

    if (size < 1024) {
        returnStr = size + " Bytes";
    } else {
        size /= 1024;
        if (size < 1024) {
            returnStr = size.toNumberFixed(2) + " KB";
        } else {
            size /= 1024;
            if (size < 1024) {
                returnStr = size.toNumberFixed(2) + " MB";
            } else {
                size /= 1024;
                returnStr = size.toNumberFixed(2) + " GB";
            }
        }
    }

    return returnStr;
};

/**
 * @package : resources/js/ksid/ksid.string.js
 * @author : ksid-KJH
 * @dage : 2016. 1. 27. 오후 11:40:07
 * @method : 섭씨온도 단위 표기
 * @param inputStr	: 입력문자열
 * @returns string
 * @사용법 : ksid.string.formatCtemp('34.12') >>> 결과 : 34.12℃
 * @주의사항 :
 */
ksid.string.formatCtemp = function(inputStr) {
    var returnStr = "";

    if(inputStr){
        returnStr = inputStr + "℃";
    }

    return returnStr;
};

/***************************************************************************
 * Name     : CommonJs.isEmail
 * Desc     : Email 검증
 * @param   : str - email
 * @returns : true/false
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.string.isEmail = function(str) {
    //하나이상의문자열@하나이상의문자열.하나이상의문자열 의 패턴
    var regexp = /^(\w+)@(\w+)[.](\w+)$/;
    //하나이상의문자열@하나이상의문자열.하나이상의문자열 .하나이상의문자열 의 패턴
    var regexp2 = /^(\w+)@(\w+)[.](\w+)[.](\w+)$/;
    return regexp.test(str) || regexp2.test(str);
};

/***************************************************************************
 * Function Name : checkBusiNo
 * Description : 파라미터로 입력받은 10자리 사업자 번호를 검증
 * parameters :  사업자번호
 * return : XMLHttpRequest
 ***************************************************************************/
ksid.string.isBizNo = function (busiNo){
    var sum = 0;
    var getlist = new Array(10);
    var chkvalue = new Array("1","3","7","1","3","7","1","3","5");
    for(var i=0;i<10;i++){getlist[i] = busiNo.substring(i,i+1);}
    for(var i=0;i<9;i++){sum += getlist[i]*chkvalue[i];}
    sum = sum + parseInt((getlist[8]*5)/10);
    sidliy = sum % 10;
    sidchk = 0;
    if(sidliy !=0){sidchk = 10 - sidliy;}
    else{sidchk = 0;}
    if(sidchk != getlist[9]){return false;}

    return true;
};

/***************************************************************************
 * Function Name : getSplitData
 * Description : 특정 부호로 split하여 index로 반환
 * parameters : data: 문자열
 * 				mark: 기준 부호
 * 				idx: 순서
 * return :     문자열
 ***************************************************************************/
ksid.string.getSplitData = function(data, mark, idx) {
    var val = "";

    if(!data) {
        return "";
    }

    val = data.split(mark);

    if(val.length == 0 || val.length-1 < idx) {
        return "";
    }

    return val[idx];
};

ksid.string.htmlEnc = function(val) {
    return ksid.string.replace(
               ksid.string.replace(
                   ksid.string.replace(
                       ksid.string.replace(val, '<', '＜')
                   , '>', '＞')
               , "'", '′')
           , '"', '″');
};

ksid.string.htmlDec = function(val) {
    return ksid.string.replace(
               ksid.string.replace(
                   ksid.string.replace(
                       ksid.string.replace(val, '＜', '<')
                   , '＞', '>')
               , '′', "'")
           , '″', '"');
};
