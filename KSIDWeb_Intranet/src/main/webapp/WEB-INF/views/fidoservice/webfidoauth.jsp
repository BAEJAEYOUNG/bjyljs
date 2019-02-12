<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>지문 로그인</title>
<jsp:include page="${config.includePath}/css.jsp"/>
<jsp:include page="${config.includePath}/js.jsp"/>

<style type="text/css">
    @font-face {
         font-family : NanumGothic;
         src : url(${config.fontPath}/NanumGothic.ttf);
    }
    html, body {
        font-family : NanumGothic;
    }

    .msgbox-msg {
        padding: 2em 2em !important;
        overflow: hidden;
        font-family: verdana,gulim,sans-serif;
        white-space: pre-wrap;
        word-wrap: break-word;
    }
</style>

<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/util.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/jsbn.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/aes.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/des.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/desofb.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/seed.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/sha1.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/md5.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/sha256.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/prng.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/hmac.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/random.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/oids.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/asn1.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/crypto/rsa.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/pki.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/pkcs5.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/pkcs8.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/pkcs7asn1.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/jsustoolkit/toolkit/pkcs7.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/push/utils.js?v=3"></script>

<script type="text/javascript" charset="utf-8">

/* server url */
var _RELAY_SERVER_URL = "https://pcsprelay3.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";  // 푸쉬서비스 중계서버 URL
var _VERIFY_SERVER_URL = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";        // 전자서명 검증서버 URL
var _FIDO_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";           // FIDO서버 URL(real)

/* 샘플페이지에 입력 해야 할 정보 */
//ANDROID App Key 정보
//var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl5eHN8emJ1cmp7YWJud2Jle3l7d3wvEXFifmRicnZicHptcmF+dwknByoqLywIOhYtMDMyDzE9LwElHhoKPxUdLRh+eA==';  // 타임라이선스(테스트)
//real
var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuiILi+vjo7PqP7fuIk4n2ojMGHQoWGxMCZHB3emp3c2p8YWN2dn9mfHh0dXdicT8UfXdiZ3V2GCgcJjwyFh01OisFChYpGAA1MXAvBSdyACEVJG5+';

//IOS App Key 정보
//var _APPKEY_IOS = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl5eHN8emJ1cmp7YWJud2Jle3l7d3wvEXFifmRicnZicHptcmF+dwknByoqLywIOhYtMDMyDzE9LwElHhoKPxUdLRh+eA==';  // 타임라이선스(테스트)
//real
var _APPKEY_IOS = 'FjwmADokKwE5LTs3FSY8KyYuiILi+vjo7PqP7fuIk4n2ojMGHQoWGxMCZHVwfmF8d2p7ZGBxfH9mfHh0dXdicT8UfXdiZ3V2GCgcJjwyZnMEPBtqHis2E2YvMQJ8FBcADQd/JG5+';


$(document).ready(function() {
    /* document.form1.userID.value = "${param.custUserNo}"; */
    /* var phoneFlag = "${param.phoneOs}";
    if( phoneFlag == "I" ) {
        $('input:radio[name="phoneOS"][value="iOS"]').prop('checked', true);
    }
    else if( phoneFlag == "A" ) {
        $('input:radio[name="phoneOS"][value="ANDROID"]').prop('checked', true);
    } */
});


function genResultValue(data) {
    var params = ksid.form.flushPanel('edit-panel');
    params.code = data;
    params.svcType = "FIDOAUTH";
    if( data == 200 ) {
        ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rcvdata) {
            ksid.ui.alert("지문 로그인이 완료되었습니다.", function() {
                doClose();
            });
        });
    } else {
        ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/fidoCodeRst", params, function(rcvdata) {
            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rstdata) {
                ksid.ui.alert(rcvdata.rstParam.codeRemark, function() {
                    doClose();
                });
            });
        });
    }
}


function genFIDOResponse(data) {
    /* alert("genFIDOResponse data : " + data); */
}


function genFIDOAuthToken(data) {
    /* alert("genFIDOAuthToken data : " + data); */
}


function reqAuthTokenValidate(authToken) {
    iFrame_authToken_validate.location.href = _VERIFY_SERVER_URL
            + "?authToken=" + authToken;
}


function doReg() {
    var params = ksid.form.flushPanel('edit-panel');
    params.custUserNo = document.form1.userID.value;
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/userreg');
        $("#form1").attr('target', 'regFidoAuth');

        var regWin = ksid.ui.openWindow('', 'regFidoAuth', 550, 530);
        $("#form1").submit();
        regWin.focus();
    }
}


function doPay() {
    var params = ksid.form.flushPanel('edit-panel');
    params.custUserNo = document.form1.userID.value;
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/userpay2');
        $("#form1").attr('target', 'requestFidoAuth');

        var regWin = ksid.ui.openWindow('', 'requestFidoAuth', 550, 530);
        $("#form1").submit();
        regWin.focus();
    }
}


function doFidoLogin() {
    var params = ksid.form.flushPanel('edit-panel');
    var getUserId = document.form1.userID.value;

    params.custUserNo = getUserId;
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userStatChk", params, function(result) {
        if( result.rstParam.retValue == "00" ) {
            var retValue = confirm("지문 인증 서비스 미결제 상태 입니다. 지문 인증 서비스 결제를 하시겠습니까?");
            if( retValue == true ) {
                // 서비스 결제 화면 호출
                doPay();
                doClose();
            }
        }
        else if( result.rstParam.retValue == "01" ) {
            var retValue = confirm("지문 인증 서비스 미가입 상태 입니다. 지문 인증 서비스 가입을 하시겠습니까?");
            if( retValue == true ) {
                // 서비스 가입 화면 호출
                doReg();
                doClose();
            }
        }
        else if( result.rstParam.retValue == "10" ) {
                var retValue = confirm("지문 인증 서비스 이용기간 만료 상태 입니다. 지문 인증 서비스 결제를 하시겠습니까?");
                if( retValue == true ) {
                    // 서비스 결제 화면 호출
                    doPay();
                    doClose();
                }
        }
        else if( result.rstParam.retValue == "08" || rcvdata.rstParam.retValue == "11" ) {
            var phoneFlag = rcvdata.rstParam.phoneOs;
            if( phoneFlag == "I" ) {
                $('input:radio[name="phoneOS"][value="iOS"]').prop('checked', true);
            }
            else if( phoneFlag == "A" ) {
                $('input:radio[name="phoneOS"][value="ANDROID"]').prop('checked', true);
            }
            ksid.ui.confirm("공인인증센터 앱에 요청하시겠습니까?", function() {
                genFIDORequest(getUserId, 'Auth');
            });
        }
   });
}


$(document).keydown(function(e) {
    key = (e) ? e.keyCode : event.keyCode;

    var t = document.activeElement;

    if (key == 8 || key == 116 || key == 17 || key == 82) {
        if (key == 8) {
            if (t.tagName != "INPUT") {
                if (e) {
                    e.preventDefault();
                } else {
                    event.keyCode = 0;
                    event.returnValue = false;
                }
            }
        } else {
            if (e) {
                e.preventDefault();
            } else {
                event.keyCode = 0;
                event.returnValue = false;
            }
        }
    }
});


function doClose() {
    window.close();
}

</script>
</head>
<body oncontextmenu="return false" ondragstart="return false" onselectstart="return false" style="overflow-x:hidden; overflow-y:hidden;">
<div class="contents-wrap">

    <br />

    <div class="styleDlTable">

        <table style="width:100%">
            <colgroup>
                <col width="200" />
                <col width="*" />
            </colgroup>
            <tr>
                <td><img src="${pageContext.request.contextPath}/static/image/siteci/ocuci_all.png" style="width:200px;margin-bottom:10px;" /></td>
            </tr>
        </table>
    </div>

    <center>
        <font style="font-size:24px;"><strong>지문 인증 서비스 - 지문 로그인</strong></font>
    </center>

    <br />

    <form id="form1" name="form1" method="post">

        <div id="edit-panel" class="edit-panel" style="min-width:400px;height:65px;">

            <input type="hidden" name="spCd" value="P0003" /> <!-- 서비스제공자-KSID -->
            <input type="hidden" name="custId" value="C000018" /> <!-- 고객사-열린사이버대학 -->
            <input type="hidden" name="servId" value="S00000007"/>
            <input type="hidden" name="custUserNo" value=""/>
            <div class="styleDlTable">
            <br />
                <dl>
                    <dt class="width100">학번</dt>
                    <dd>
                        <input type="text" maxlength="16" id="userID" name="userID" title="학번" class="style-input width110" format="no" />
                        <!-- <input type="text" id="userID" name="userID" /> -->
                    </dd>
                </dl>
                <dl>
                    <dd style="margin-top:5px;">
                        <div style="display:none">
                            <label><input TYPE="radio" name="phoneOS" value="iOS" checked="checked" />&nbsp;iOS</label>
                            &nbsp;&nbsp;
                            <label><input TYPE="radio" name="phoneOS" value="ANDROID" />&nbsp;ANDROID</label>
                        </div>
                    </dd>
                </dl>
            </div>
        </div>
    </form>
    </br>
    <div class="button-bar" style="height:20px;">
    </div>
    <!--  button bar  -->
    <div class="button-bar" style="text-align:center;">
        <button type="button" class="style-btn" auth="W" onclick="doFidoLogin()" style="width:100px; height:30px;">지문 로그인</button>
    </div>

    <!--// button bar  -->

</div>
</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>