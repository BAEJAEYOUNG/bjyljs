/****************************************************************
    설명:  ksid namespace

    수정일         수정자        수정내용
    ------------------------------------------------------
    2015-01-14     배재영        초기작성
    ------------------------------------------------------
****************************************************************/

/**
 * ksid namespace
 */

ksid = {
    language    : getLanguage()
};

if (top.ksid.language) {
    ksid.language = top.ksid.language;
}

function getLanguage() {

    var rtnLanguage = "kr";

    if ($(location).attr('search').indexOf('language') > -1) {
        rtnLanguage = $(location).attr('search').replace('?language=', '');
    }

    return rtnLanguage;
};

// ksid 전역변수 설정
var go_dialog_comm  = null;       // 공통팝업
var DialogCommGrid  = null;       // 공통팝업 grid

ksid.file = {};

$.support.cors = true;			  // jQuery 를 이용한 ajax 사용시 크로스 도메인 허용

