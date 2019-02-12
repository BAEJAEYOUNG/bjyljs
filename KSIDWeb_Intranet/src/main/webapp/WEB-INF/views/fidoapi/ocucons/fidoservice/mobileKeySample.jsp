<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, height=device-height">
<title>OCU 지문 모바일 인증 서비스 샘플</title>

<script type="text/javascript" src="/static/js/lib/jquery.min.js"></script>
<script type="text/javascript" src="/static/js/crosscert/UniSignFIDOW2AUtil.js"></script>

<script type="text/javascript">

//전자인증 script start ---------- 한국전자인증 FIDO 관련 동일 구현
_RET_SELF_URL = window.location.href.split(/[?#]/)[0];

/* WebToApp type 한국전자인증 FIDO 관련 동일 구현 2017-08-24 변경*/

_APPKEY_ERROR = "AAAAAAAAAAAAAAAAAAAAAAAAAAAA";

//fido_info 한국전자인증 FIDO 관련 동일 구현
_FIDO_SERVICE_NAME= 'OCUCONS';

// 2017-08-21 추가 한국전자인증
_FIDO_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";

</script>

<!-- ocu Json 처리에 맞게 사용 2017-08-22 -->
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

    // 2017-09-18 추가
    String authTk = "";
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
       if ("FIDO".equals(productType)) {
            // urlsafe
            errCode = errCode.replaceAll("[-]", "+");
            errCode = errCode.replaceAll("[_]", "/");
            while (errCode.length() % 4 != 0) {
                errCode += "=";
            }
            out.print("urlsafe decode base64 : " + errCode + "<p>");
            // base64decoder
            BASE64Decoder decoder = new BASE64Decoder();
            String jsonStr = new String(decoder.decodeBuffer(errCode));
            out.print("decoding json : " + jsonStr + "<p>");
            // 2017-08-22 json parse 추가
            JsonParser parser = new JsonParser();
            JsonElement element = parser.parse(jsonStr);
            String parseErrCode = element.getAsJsonObject().get("errCode").getAsString();
            // 2017-09-18 추가
            authTk = element.getAsJsonObject().get("authToken").getAsString();
            out.print("authToken : " + authTk + "<p>");
            // 2017-08-22 추가 errCode 에 따라 OCU 자체 alert 처리
            %>
                <script language='javascript'>

                if("<%=parseErrCode%>" == '0') {
                    alert('성공하였습니다.');
                }

                 </script>
             <%
            /* out.print("decoding jsonPsrStr parseErrCode : " + parseErrCode + "<p>"); */

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
</head>
<body>
<form name="form1" action=""  method="post">
    <p>
        <!-- 한국전자인증의 공인인증센터를 사용하기위한 라이선스 발급시 필요한 정보.  라이선스 발급 정보 클릭시  out.print("result : " + result + "<p>");에 표시 되는 정보를 한국전자인증 담당자에게 보내 주시면 라이선스를 발급 받으실 수 있습니다. -->
        <!-- 2018-08-24 상용 오픈 전 최초 1회 실행 -->
        <a href="javascript:UniSignW2A.getLicenseInfo(_RET_SELF_URL)"> 라이선스 발급 정보 획득</a>
    </p>
</form>
</body>
</html>