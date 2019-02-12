/****************************************************************
    설명:  숫자관련
        
    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성 
    ------------------------------------------------------
****************************************************************/

/**
 * ksid namespace
 */


ksid.number = {};


/**
 * 숫자 format 으로 세팅
 * 사용법 : ksid.number.int(변경값[,초기값]);
 */
ksid.number.toNumber = function(inputStr, defaultNum) {
	if(typeof(inputStr) == "number") {
		return inputStr;
	} else {
		try{
			var numStr = inputStr.replace(/[^0-9]/g, '');
			
			if(numStr == "") {
				if(defaultNum) {
					return defaultNum;
				} else {
					return 0;
				}
			} else {
				return Number(numStr);
			}
		}catch(e){return 0;}
		
	}
};


/**
 * @package : resources/js/ksid/ksid.number.js
 * @author : ksid-BJY
 * @dage : 2015. 7. 10. 오전 11:58:42
 * @method : 함수설명
 * @param inputStr		: 입력문자열
 * @param defaultNum	: 입력문자열반환갑시 숫자형이 안될때 반환할 기본값
 * @returns decimal
 * @사용법 : ksid.number.toDecimal('3432가나다라@#4.23') >>> 결과 : 34324.23
 *           ksid.number.toDecimal('가나다라마바사') >>> 결과 : 0
 *           ksid.number.toDecimal('가나다라마바사', 10) >>> 결과 : 10
 * @주의사항 : defaultNum 은 숫자형이어야 한다.
 */
ksid.number.toDecimal = function(inputStr, defaultNum) {
	if(typeof(inputStr) == "number") {
		return inputStr;
	} else {
		var numStr = inputStr.replace(/[^0-9\.]/g, '');
		
		if(numStr == "") {
			if(defaultNum) {
				return defaultNum;
			} else {
				return 0;
			}
		} else {
			try {
				return Number(numStr);
			} catch(e) {
				return 0;
			}
		}
	}	
};

/***************************************************************************
 * Name     : CommonJs.isNumeric
 * Desc     : 문자열이 숫자인지 판별한다. 문자열이 비어있으면 false
 * @param   : str - 문자열
 * @returns : true/false
 * @author  : 배재영
 * @since   : 2012.09.10
 ***************************************************************************/
ksid.number.isNumeric = function(str) {
	var regexp = /^[0-9]+$/;
	return regexp.test(str);
};
