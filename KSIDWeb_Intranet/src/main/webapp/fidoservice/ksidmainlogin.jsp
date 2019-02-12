<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>지문 인증 서비스 샘플</title>

<script type="text/javascript" src="./jquery/jquery.min-3.1.0.js"></script>

<script type="text/javascript" src="./jsustoolkit/toolkit/util.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/jsbn.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/aes.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/des.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/desofb.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/seed.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/sha1.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/md5.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/sha256.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/prng.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/hmac.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/random.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/oids.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/asn1.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/rsa.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/pki.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/pkcs5.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/pkcs8.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/pkcs7asn1.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/pkcs7.js"></script>
<script type="text/javascript" src="./push/utils.js?v=3"></script>

<script type="text/javascript" charset="utf-8">

_FIDO_SERVICE_NAME= 'KSID';

var _RELAY_SERVER_URL = "https://fidotestserver.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(test)
var _VERIFY_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";                 // 전자서명 검증서버 URL(test)
var _FIDO_SERVER_URL    = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";


/* var _RELAY_SERVER_URL   = "https://pcsprelay3.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(real)
var _FIDO_SERVER_URL    = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";           // FIDO서버 URL(real)
var _VERIFY_SERVER_URL  = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";           // 전자서명 검증서버 URL(real) */


//Test
var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl1enV1e2tzdmZ+ZGJud2JldHl1dHcvEXFifmtic3ZicHptcmF+dwknByoqLzk3NjIcHhMiHik0Eh02BScPAGMXGz5+eA==';   // 타임라이선스(테스트)
var _APPKEY_IOS     = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl1enV1e2tzdmZ+ZGJud2JldHl1dHcvEXFifmtic3ZicHptcmF+dwknByoqLzk3NjIcHhMiHik0Eh02BScPAGMXGz5+eA==';   // 타임라이선스(테스트)

// Real
//var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuiILi+vjo7PqP7fuIk4n2ojMGHQoWGxMCZHB3emp3c2p8YWN2dn9mfHh0dXdicT8UfXdiZ3V2GCgcJjwyFh01OisFChYpGAA1MXAvBSdyACEVJG5+';
//var _APPKEY_IOS     = 'FjwmADokKwE5LTs3FSY8KyYuiILi+vjo7PqP7fuIk4n2ojMGHQoWGxMCZHVwfmF8d2p7ZGBxfH9mfHh0dXdicT8UfXdiZ3V2GCgcJjwyZnMEPBtqHis2E2YvMQJ8FBcADQd/JG5+';


//빌링서버 기본 정보
/* var mainDomainUrl = "https://bill.ksidmobile.co.kr"; */
var mainDomainUrl = "http://dev.ksidmobile.co.kr:9100";
//var mainDomainUrl = "http://192.168.2.35:8080";

//빌링서버 사용자 서비스 상태 검사 Url 정보
var userStatChkUrl = mainDomainUrl + "/devauth/mobileauth/userStatChk";

// 지문 인증 처리 결과 메시지 얻기
var fidoRstCodeUrl = mainDomainUrl + "/devauth/mobileauth/fidoCodeRst";

// 작업 이력 기록
var fidoRstHisUrl = mainDomainUrl + "/devauth/mobileauth/servicehist";



//지문 로그인에 대한 결과 코드 수신 Function. 반드시 동일 구현
function genResultValue(data) {
    var params = {};
    params.spCd       = document.form1.spCd.value;                  // 빌링서버 관리용 기본 코드 정의 필수
    params.custId     = document.form1.custId.value;                // 빌링서버 관리용 기본 코드 정의 필수
    params.servId     = document.form1.servId.value;                // 빌링서버 관리용 기본 코드 정의 필수
    params.custUserNo = document.getElementById("userID").value;    // 학생 학번 정보 정의
    params.code       = data;                                       // 이력 기록을 위해 결과 코드 정의
    params.svcType    = "FIDOAUTH";                                 // 이력 기록을 위해 서비스 타입 정의
    if( data == 200 ) {
        // 작업 이력 URL호출
        $.post(fidoRstHisUrl, params, function(rstdata) {
        }, "json");
        // OCU에 맞는 alert 적용
        alert("지문 로그인이 완료되었습니다.");

    } else {
        // 빌링서버로 지문 인증 처리 결과 메시지 얻기 호출
        $.post(fidoRstCodeUrl, params, function(rcvdata) {
            // 작업 이력 URL호출
           $.post(fidoRstHisUrl, params, function(rstdata) {
            }, "json");
            // OCU에 맞는 alert 적용
            alert(rcvdata.rstParam.codeRemark);
        }, "json");
    }
}

// 지문 로그인에 대한 응답 Function. 반드시 동일 구현
 function genFIDOResponse(data) {
    /* alert("genFIDOResponse data : " + data); */
}

//지문 로그인에 대한 인증토큰 수신 Function. 반드시 동일 구현
function genFIDOAuthToken(data) {
    /* alert("genFIDOAuthToken data : " + data); */
}

//지문 로그인에 대한 인증토큰 생성 Function. 반드시 동일 구현
function reqAuthTokenValidate(authToken) {
    iFrame_authToken_validate.location.href = _VERIFY_SERVER_URL
            + "?authToken=" + authToken;
}


//서비스 결제 Web UI 호출
function doSvcPay() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("학번을 정보가 없습니다. ");
        return;
    }

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;

    // 한국스마트아이디 서비스 결제 웹 페이지를 호출한다.
    window.open("about:blank", "payregwin", "width=550,height=350");

    var url = mainDomainUrl + "/ksid/userpay";
    document.form1.action = url;
    document.form1.target = "payregwin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


//서비스 가입 Web UI 호출
function doSvcReg() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("학번을 정보가 없습니다. ");
        return;
    }

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;

    // 한국스마트아이디 서비스 가입 웹 페이지를 호출한다.
    window.open("about:blank", "regwin", "width=550,height=530");

    var url = mainDomainUrl + "/ksid/userreg";
    document.form1.action = url;
    document.form1.target = "regwin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


// 지문 로그인 버턴 Action
function doMainFidoLogin() {
    // 한국스마트아이디 지문 로그인 웹 페이지를 호출에 필요한 Parameter 정보
    var params= {};
    params.spCd       = document.form1.spCd.value;                  // 빌링서버 관리용 기본 코드 정의 필수
    params.custId     = document.form1.custId.value;                // 빌링서버 관리용 기본 코드 정의 필수
    params.servId     = document.form1.servId.value;                // 빌링서버 관리용 기본 코드 정의 필수
    params.custUserNo = document.getElementById("userID").value;    // 학생 학번 정보 정의

    // 지문 인증 서비스 가입 및 결제 상태 확인 후 지문 인증 로그인 요청 userStatChkUrl 정의 URL 로 확인 요청
   $.post(userStatChkUrl, params, function(rcvdata) {
        if( rcvdata.rstParam.retValue == "00" ) {
            var retValue = confirm("지문 인증 서비스 미결제 상태 입니다. 지문 인증 서비스 결제를 하시겠습니까?");
            if( retValue == true ) {
                // 서비스 결제 화면 호출
                doSvcPay();
            }
        }
        else if( rcvdata.rstParam.retValue == "01" ) {
            var retValue = confirm("지문 인증 서비스 미가입 상태 입니다. 지문 인증 서비스 가입을 하시겠습니까?");
            if( retValue == true ) {
                // 서비스 가입 화면 호출
                doSvcReg();
            }
        }
        else if( rcvdata.rstParam.retValue == "10" ) {
                var retValue = confirm("지문 인증 서비스 이용기간 만료 상태 입니다. 지문 인증 서비스 결제를 하시겠습니까?");
                if( retValue == true ) {
                    // 서비스 결제 화면 호출
                    doSvcPay();
                }
        }
        else if( rcvdata.rstParam.retValue == "08" ) {  // 정상 서비스 이용자 일시 수행 . 필히 동일 구현
            var phoneFlag = rcvdata.rstParam.phoneOs;
            if( phoneFlag == "I" ) {                    // input type 형태로 값 세팅. 필히 동일 구현
                $('input:radio[name="phoneOS"][value="iOS"]').prop('checked', true);
            }
            else if( phoneFlag == "A" ) {
                $('input:radio[name="phoneOS"][value="ANDROID"]').prop('checked', true);
            }
            // 지문 인증 서버로 지문 인증 로그인 요청
            // 2017-08-24 alert 문구 변경
            var retValue = confirm("스마트폰의 한국전자인증FIDO앱에 요청하시겠습니까?");
            if( retValue == true ) {
                genFIDORequest(document.getElementById("userID").value, 'Auth');
            }
        }
    }, "json");
}



</script>
</head>
<body>
<form name="form1" action=""  method="post">
<input type="hidden" name="spCd" value="P0003"/>
<input type="hidden" name="custId" value="C000018"/>
<input type="hidden" name="servId" value="S00000007"/>
<input type="hidden" name="custUserNo" value=""/>
<input type="hidden" name="phoneOs" value=""/>
    <div>
        <p><b>지문 서비스 메인 로그인 샘플 </b></p>
    </div>
    <div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 450px;">
        <p>
            &nbsp;&nbsp;&nbsp;&nbsp;
            학번 : <input type="text" maxlength="16" id="userID" name="userID" />&nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id='fidologin' onclick="doMainFidoLogin()">지문 로그인</button>
            <!-- 사용자 가입 정보 DB 에서 스마트폰 OS 구분을 조회해오지만, 한국전자인증 자바스크립트 에서 반드시 input type 으로 구현해야만 값 인지하게 되어 있음 필수 동일 구현후 히든 처리 -->
            <div style="display:none">
            스마트폰 운영체제 : <label><input TYPE="radio" name="phoneOS" value="iOS"/>iOS</label> <label><input TYPE="radio" name="phoneOS" value="ANDROID" />ANDROID</label>
            </div>

        </p>
    </div>
</form>
</body>
</html>