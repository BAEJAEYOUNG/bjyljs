<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, height=device-height">
<title>OCU 지문 모바일 인증 서비스 샘플</title>

<script type="text/javascript" src="./jquery/jquery.min-3.1.0.js"></script>
<script type="text/javascript" src="./UniSignFIDOW2AUtil.js"></script>

<!-- 한국전자인증 FIDO관련 사용 Json 필요시 사용 -->
<%-- <%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.parser.JSONParser" %> --%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="com.google.gson.JsonParser" %>


<!-- 한국전자인증 FIDO관련 사용 필수 정의 -->
<%@ page import="sun.misc.BASE64Decoder" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.io.BufferedReader" %>

<%
   // 한국전자인증 FIDO서비스 구현 부분
    String resultState = request.getParameter("resultState");
    String result = request.getParameter("result");
    String rtnParam = request.getParameter("rtnParam");
    String sidResult = request.getParameter("sidResult");

    String productType = request.getParameter("product_type");
    String errCode = request.getParameter("ErrCode");
    String authToken = request.getParameter("AuthToken");

    // 한국전자인증 FIDO 관련 Debug 시 사용
    if (result != null) {
        result = java.net.URLDecoder.decode(result);
        out.print("result length : " + result.length() + "<p>");
        out.print("result : " + result + "<p>");
    }

    if (resultState != null) {
        out.print("result state : " + resultState + "<p>");
    }

    if (rtnParam != null) {
        out.print("rtnParam : " + rtnParam + "<p>");
    }
    if (sidResult != null) {
        out.print("sidResult : " + sidResult + "<p>");
        out.print("<p>");
    }

    if (productType != null) {
        out.print("productType : " + productType + "<p>");
        out.print("<p>");
    }

    if (errCode != null) {
        // 한국전자인증 FIDO 관련 Debug 시 사용
       if ("FIDO".equals(productType)) {
            // urlsafe
            errCode = errCode.replaceAll("[-]", "+");
            errCode = errCode.replaceAll("[_]", "/");
            while (errCode.length() % 4 != 0) {
                errCode += "=";
            }
            /* out.print("urlsafe decode base64 : " + errCode + "<p>"); */

            // base64decoder
            BASE64Decoder decoder = new BASE64Decoder();
            String jsonStr = new String(decoder.decodeBuffer(errCode));

            // 2017-08-22 json parse 추가
            JsonParser parser = new JsonParser();
            JsonElement element = parser.parse(jsonStr);
            String parseErrCode = element.getAsJsonObject().get("errCode").getAsString();
            // 2017-08-22 추가 errCode 에 따라 OCU 자체 alert 처리
            if(parseErrCode.equals("0")) {
                %>
                <script language='javascript'>
                alert('성공하였습니다.');
                </script>
                <%
            }
            /* out.print("decoding jsonPsrStr parseErrCode : " + parseErrCode + "<p>"); */

        } else {
            out.print("errCode : " + errCode + "<p>");
            out.print("<p>");
        }

        //  FIDO WebToApp 에러 정의/////////////////////////////////////////////////////////////////////////////////////////////////////////
        //  SUCCEED                                                                      "0"        성공
        //  ERR_UNKONWN                                                             "-1000"  알수없는 에러입니다.
        //  LINCENSE_FAILURE                                                        "-1001"  라이선스 체크 실패  되었습니다.
        //  ERR_FIDO_WRONG_CCFIDO_PROTOCOL                         "-1002"  CCFIDO프로토콜 오류 입니다.
        //  ERR_FIDO_UNAVAILABLE_BIOTYPE                                 "-1003"  허용하지 않는 바이오타입입니다.
        //  ERR_FIDO_CONNECT_FIDOSERVER_FAILURE                   "-1004"  FIDO SERVER 연결 실패 되었습니다.
        //  ERR_FIDO_ALREADY_REGISTERED                                  "-1006"   이미 등록이 되어있습니다.
        //  ERR_FIDO_NOT_REGISTERED_USER                                "-1007"  등록되지 않은 사용자 입니다.
        //  ERR_FIDO_NOT_SUPPORT_DEVICE                                 "-1008"  지원하지 않는 단말기 입니다.
        //  ERR_FIDO_NOT_SUPPORT_FIDO                                     "-1010"  FIDO를 지원하지 않습니다.
        //  ERR_FIDO_VERIFICATION_FAILURE_BY_TOUCHID             "-1013"  지문 검증 실패 하였습니다.
        //  ERR_FIDO_CAN_NOT_USE_TOUCHID                               "-1014" TouchID를 사용 할 수 없습니다.
        //  ERR_FIDO_UNREGISTERED_TOUCHID                              "-1015"  TouchID가 등록되지 않았습니다.
        //  IS_FAILED_FIDO_REGISTRATION_ERROR                          "-1016"  등록 실패 되었습니다.
        //  IS_FAILED_FIDO_AUTHENTICATION_ERROR                      "-1017"  로그인 실패 되었습니다.
        //  IS_FAILED_FIDO_DELETION_ERROR                                 "-1018"  해지 실패 되었습니다.
        //  CANCELED_TO_FINGERPRINT_AUTHENTICATION_ERROR "-1019"  지문 인증 취소 되었습니다.
        //  ENTERED_IN_FINGERPRINT_LOCKMODE_ERROR             "-1020"  지문 인증이 락모드로 변경 되었습니다.
        //  NO_HAVE_PERMISSION_FOR_APP                                  "-1021"  앱 퍼미션이 없습니다.
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
%>
<script type="text/javascript" charset="utf-8">

var gSpCd   = "P0003";                                  // 서비스 제공자 코드
var gCustId = "C000018";                                // 고객사 코드
var gServId = "S00000007";                              // 서비스 코드

//빌링서버 기본 정보
var mainDomainUrl = "https://bill.ksidmobile.co.kr";
//var mainDomainUrl = "http://192.168.2.35:8080";

//빌링서버 사용자 서비스 상태 검사 Url 정보
var userStatChkUrl = mainDomainUrl + "/devauth/mobileauth/userStatChk";

// 전자인증 script start ---------- 한국전자인증 FIDO 관련 동일 구현
_RET_SELF_URL = window.location.href.split(/[?#]/)[0];


/* WebToApp type 한국전자인증 FIDO 관련 동일 구현 2017-08-21 변경*/
_APPKEY_FIDO = 'FjwmADokKwE5LTs3FSY8KyYuiILi+oWulJaJjYS7LxANGxwaFA1oYmB0e3Zwdmt3emR5fmFzdGVkdHlyORphdXJlf2pgc2FkcH1tc2EtAQowATNhNSsNBhAWCycPCAcpGwB+YSIMajUVcXQ=';
_APPKEY_ERROR = "AAAAAAAAAAAAAAAAAAAAAAAAAAAA";

//fido_info 한국전자인증 FIDO 관련 동일 구현
_FIDO_SERVICE_NAME= 'OCU';

// 2017-08-21 추가 한국전자인증
_FIDO_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";

//한국전자인증 FIDO 관련 동일 구현
function genCCFIDOProtocol(operation, flag) {

    var base64UrlCCFIDOProtocol = '';

    // 2017-08-21 추가 idDomainValue : document.getElementById("userID").value 에 학번정보 대체, "_" + "bill.ksidmobile.co.kr"부분은 동일구현
    // 2017-08-22 추가 bill.ksidmobile.co.kr -> bill.ksidmobile.co.kr/ocu 변경
    var idDomainValue = document.getElementById("userID").value + "_" + "bill.ksidmobile.co.kr/ocu";
    var CCFidoProtocol = new Object();
    CCFidoProtocol.op = operation;
    if (flag) {
        CCFidoProtocol.content = id('plainText').value;
    } else {
        CCFidoProtocol.content = "";
    }
    if (true == _USUtil.OS.isAndroid()) {
        CCFidoProtocol.id = idDomainValue;     // 2017-08-21 학번 정보 와 도메인 정보 결합 정보 입력
    } else if (true == _USUtil.OS.isiOS()) {
        CCFidoProtocol.id = idDomainValue;     // 2017-08-21 학번 정보 와 도메인 정보 결합 정보 입력
    }
    //CCFidoProtocol.id = _FIDO_ID;                     // 고객이 넣어주는 ID
    CCFidoProtocol.serviceName = _FIDO_SERVICE_NAME;    // 고객이 넣어주는 서비스명
    CCFidoProtocol.serviceType = 0;                     // FIDO
    CCFidoProtocol.bioType = 2;                         // BIOTYPE(지문)
    CCFidoProtocol.fidoServerUrl = _FIDO_SERVER_URL;    // 2017-08-21 한국전자인증 추가

    base64UrlCCFIDOProtocol =
        encodeUrl(_USUtil.Base64.encode(JSON.stringify(CCFidoProtocol)));

    return base64UrlCCFIDOProtocol;
}

// 한국전자인증 FIDO 관련 동일 구현
function encodeUrl(str) {
    return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');
}
// 전자인증 script end ---------- /



// 지문 로그인 버턴 Action
function doFidoLogin() {
 // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 한국스마트아이디 지문 로그인 웹 페이지를 호출에 필요한 Parameter 정보
    var params= {};
    params.spCd       = gSpCd;                  // 빌링서버 관리용 기본 코드 정의 필수
    params.custId     = gCustId;                // 빌링서버 관리용 기본 코드 정의 필수
    params.servId     = gServId;                // 빌링서버 관리용 기본 코드 정의 필수
    params.custUserNo = document.getElementById("userID").value;    // 학생 학번 정보 정의

    // 지문 인증 서비스 가입 및 결제 상태 확인 후 지문 인증 로그인 요청 userStatChkUrl 정의 URL 로 확인 요청
   $.post(userStatChkUrl, params, function(rcvdata) {
        if( rcvdata.rstParam.retValue == "00" ) {
            alert("지문 인증 서비스 미결제 상태 입니다. PC에서 한국열린사이버대학교 홈페이지 지문 인증 서비스 이용 안내에서 로그인 후 서비스 결제를 하십시오.");
        }
        else if( rcvdata.rstParam.retValue == "01" ) {
            alert("지문 인증 서비스 미가입 상태 입니다. PC에서 한국열린사이버대학교 홈페이지 지문 인증 서비스 이용 안내에서 로그인 후 서비스 가입을 하십시오.");
        }
        else if( rcvdata.rstParam.retValue == "10" ) {
            alert("지문 인증 서비스 이용기간 만료 상태 입니다. PC에서 한국열린사이버대학교 홈페이지 지문 인증 서비스 이용 안내에서 로그인 후 서비스 결제를 하십시오.");
        }
        else if( rcvdata.rstParam.retValue == "08" ) {  // 정상 서비스 이용자 일시 수행 . 필히 동일 구현
            // 공인인증센터로 지문 로그인 메세지 전달
            FIDOW2A.auth(_RET_SELF_URL, _APPKEY_FIDO, genCCFIDOProtocol('Auth', false));
        }
    }, "json");
}


</script>
</head>
<body>
<form name="form1" action=""  method="post">
<input type="hidden" name="spCd" value=""/>
<input type="hidden" name="custId" value=""/>
<input type="hidden" name="servId" value=""/>
<input type="hidden" name="custUserNo" value=""/>
    <div>
        <p><b> OCU 지문 서비스 모바일 샘플 </b></p>
    </div>
    <div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 360px;">
        <p>
            &nbsp;&nbsp;&nbsp;&nbsp;
            학번 : <input type="text" maxlength="16" id="userID" name="userID" value=""/>
            &nbsp;&nbsp;&nbsp;
            <button type="button" id='fidologin' onclick="doFidoLogin()">지문 로그인</button>
        </p>
    </div>
    </br>
    <p>
        <!-- 한국전자인증의 공인인증센터를 사용하기위한 라이선스 발급시 필요한 정보.  라이선스 발급 정보 클릭시  out.print("result : " + result + "<p>");에 표시 되는 정보를 한국전자인증 담당자에게 보내 주시면 라이선스를 발급 받으실 수 있습니다. -->
        <a href="javascript:UniSignW2A.getLicenseInfo(_RET_SELF_URL)"> 라이선스 발급 정보 획득</a>
    </p>
</form>
</body>
</html>