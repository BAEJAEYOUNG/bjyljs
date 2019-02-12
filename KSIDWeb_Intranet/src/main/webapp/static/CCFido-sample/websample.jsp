<%@ page contentType="text/html;charset=utf-8"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<title>(ClientAPI-1.0.0)</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<!--[if !IE]> -->
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/util.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/jsbn.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/aes.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/des.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/desofb.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/seed.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/sha1.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/md5.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/sha256.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/prng.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/hmac.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/random.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/oids.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/asn1.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/crypto/rsa.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/pki.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/pkcs5.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/pkcs8.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/pkcs7asn1.js"></script>
<script type="text/javascript" src="./crosscert/jsustoolkit/toolkit/pkcs7.js"></script>
<script type="text/javascript" src="./crosscert/push/CCFidoUtils.js?v=3"></script>
<script type="text/javascript">

    /* test server url */
    var _RELAY_SERVER_URL   = "https://fidotestserver.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(test)
    var _FIDO_SERVER_URL    = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";             // FIDO서버 URL(test)
    var _VERIFY_SERVER_URL  = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";             // 전자서명 검증서버 URL(test)

    /* 샘플페이지에 입력 해야 할 정보 */
//     var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuABAGECQ/JCAsFyA9JzkWHAYAGgQLf21+e3ZzeWB8dWJ+YH5xdWNsfH1zcTIHd3Njd2NkcHR2Zn5tcGF+dwN0YyApLwI1GAQrHmgjdjd2OxQbBTQrEgEdABh+eA==';
//     var _APPKEY_IOS = 'FjwmADokKwE5LTs3FSY8KyYuABAGECQ/JCAsFyA9JzkWHAYAGgQLf21+e3ZzeWB8dWJ+YH5xdWNsfH1zcTIHd3Njd2NkcHR2Zn5tcGF+dwN0YyApLwI1GAQrHmgjdjd2OxQbBTQrEgEdABh+eA==';
    var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl1enV1e2tzdmZ+ZGJud2JldHl1dHcvEXFifmtic3ZicHptcmF+dwknByoqLzk3NjIcHhMiHik0Eh02BScPAGMXGz5+eA==';   // 타임라이선스(테스트)
    var _APPKEY_IOS     = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl1enV1e2tzdmZ+ZGJud2JldHl1dHcvEXFifmtic3ZicHptcmF+dwknByoqLzk3NjIcHhMiHik0Eh02BScPAGMXGz5+eA==';   // 타임라이선스(테스트)

    console.log('_APPKEY_ANDROID = ', _APPKEY_ANDROID);
    console.log('_APPKEY_IOS = ', _APPKEY_IOS);

    /* 샘플페이지에 입력 해야 할 정보 */
    var _FIDO_SERVICE_NAME = "SDU"; // 업체 구분(영문약자)

    // push service first-regist
    function smartPhoneRegist(userID) {
        reqRegConnect(userID);
    }

    // push service re-regist
    function smartPhoneReRegist(userID) {
        reqModifyConnect(userID);
    }

    // fido regist
    function fingerprintReg(userID) {
        genFIDORequest(userID, 'Reg');
    }

    // fido deregist
    function fingerprintDereg(userID) {
        genFIDORequest(userID, 'Dereg');
    }

    // fido authentication
    function fingerprintAuth(userID) {
        genFIDORequest(userID, 'Auth');
    }

    // fido init-regist : Added by OpCode(20170915)
    function fingerprintInitReg(userID) {
        genFIDORequest(userID, 'InitReg');
    }

    // gen random value
    function genRandomValue(data) {
        document.getElementById('randomvalue').value = data;
    }

    // gen fido response
    function genFIDOResponse(data) {
        document.getElementById('fidoresponse').value = data;
    }

    // gen fido response
    function genFIDOAuthToken(data) {
        document.getElementById('fidoauthtoken').value = data;
    }

    // gen result value
    function genResultValue(data) {
        if (data == '200') {
            alert("성공");
        } else {
            alert("실패 [errcode : " + data + "]");
        }
    }

    /* RESTful방식으로 FIDO서버에 GET/POST 방식으로 요청 */
    function reqAuthTokenValidate(authToken) {
        iFrame_authToken_validate.location.href = _VERIFY_SERVER_URL
                + "?authToken=" + authToken;
    }
</script>
</head>
<body>
    <div>
        <h1>
            <b>지문인증서비스 샘플페이지</b>
        </h1>
    </div>
    <div>
        <p>
            <b>라이선스 발급(스마트폰에서 접속하여 실행)</b>
        </p>
    </div>
    <div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 750px;">
        <p>
            <button onclick="javascript:UniSignW2A.getLicenseInfo(_RET_SELF_URL);">라이선스 발급 정보 획득</button>
        </p>
        <%
            String state = request.getParameter("resultState");
            if (state != null) {
                out.print("state : " + state + "<p>");
            }

            String license = request.getParameter("result");
            if (license != null) {
                license = java.net.URLDecoder.decode(license, "utf-8");
                out.print("license length : " + license.length() + "<p>");
                out.print("license : " + license + "<p>");
            }
        %>
    </div>
    <br />
    <div>
        <p>
            <b>필수 입력 정보(PC에서 필요한 정보)</b>
        </p>
    </div>
    <div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 750px;">
        <p>
            학번 : <input type="text" id="userID" name="userID" /> <br /> <br />스마트폰 운영체제 : <label><input TYPE="radio" name="phoneOS" value="iOS" checked="checked" />iOS</label> <label><input TYPE="radio" name="phoneOS" value="ANDROID" />ANDROID</label>
        </p>
    </div>
    <br />
    <div>
        <p>
            <b>기능</b>
        </p>
    </div>
    <div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 750px;">
        <p>
            <button id='smartPhoneRegist' onclick="smartPhoneRegist(userID.value);">스마트폰 등록</button>
            <button id='smartPhoneReRegist' onclick="smartPhoneReRegist(userID.value);">스마트폰 기기 변경</button>
            <button id='fingerprintReg' onclick="fingerprintReg(userID.value);">지문 등록</button>
            <button id='fingerprintDereg' onclick="fingerprintDereg(userID.value);">지문 해지</button>
            <button id='fingerprintAuth' onclick="fingerprintAuth(userID.value);">지문 로그인</button>
            <button id='fingerprintInitReg' onclick="fingerprintInitReg(userID.value);">지문 등록(로컬 사용자 삭제 후 등록)</button>
        </p>
    </div>
    <br />
    <div>
        <p>
            <b>결과출력값</b>
        </p>
    </div>
    <div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 750px;">
        <p>
            randomvalue : <input type="text" id="randomvalue" name="randomvalue" value="" />
        </p>
        <p>
            fidoresponse : <input type="text" id="fidoresponse" name="fidoresponse" value="" />
        </p>
        <p>
            fidoauthtoken : <input type="text" id="fidoauthtoken" name="fidoauthtoken" value="" />
            <button id='authTokenValidate' onclick="reqAuthTokenValidate(fidoauthtoken.value);">FIDO Validate</button>
            <br />
            <br />
            <iframe name="iFrame_authToken_validate" width="350px;" height="70px;"></iframe>
        </p>
    </div>
</body>

</html>