<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>PC와 재연결</title>
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
var _RELAY_SERVER_URL = "https://fidotestserver.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(test)
var _VERIFY_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";                 // 전자서명 검증서버 URL(test)
var _FIDO_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";           // FIDO서버 URL(real)

/* var _RELAY_SERVER_URL   = "https://pcsprelay3.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(real)
var _FIDO_SERVER_URL    = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";           // FIDO서버 URL(real)
var _VERIFY_SERVER_URL  = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";           // 전자서명 검증서버 URL(real) */

/* 샘플페이지에 입력 해야 할 정보 */
// ANDROID App Key 정보
var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl5eHN8emJ1cmp7YWJud2Jle3l7d3wvEXFifmRicnZicHptcmF+dwknByoqLywIOhYtMDMyDzE9LwElHhoKPxUdLRh+eA==';  // 타임라이선스(테스트)
/* var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuiILi+vjo7PqP7fuIk4n2ojMGHQoWGxMCZHB3emp3c2p8YWN2dn9mfHh0dXdicT8UfXdiZ3V2GCgcJjwyFh01OisFChYpGAA1MXAvBSdyACEVJG5+'; */

//IOS App Key 정보
var _APPKEY_IOS = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl5eHN8emJ1cmp7YWJud2Jle3l7d3wvEXFifmRicnZicHptcmF+dwknByoqLywIOhYtMDMyDzE9LwElHhoKPxUdLRh+eA==';  // 타임라이선스(테스트)
/* var _APPKEY_IOS = 'FjwmADokKwE5LTs3FSY8KyYuiILi+vjo7PqP7fuIk4n2ojMGHQoWGxMCZHVwfmF8d2p7ZGBxfH9mfHh0dXdicT8UfXdiZ3V2GCgcJjwyZnMEPBtqHis2E2YvMQJ8FBcADQd/JG5+'; */

$(document).ready(function() {
    document.form1.custUserNo.value = "${param.custUserNo}".trim();
    document.form1.spCd.value   = "${param.spCd}";
    document.form1.custId.value = "${param.custId}";
    document.form1.servId.value = "${param.servId}";
    /* alert('phoneFlag : ' + phoneFlag); */
    /* if( phoneFlag == "I" ) {
        $('input:radio[name="phoneOS"][value="iOS"]').prop('checked', true);
    }
    else if( phoneFlag == "A" ) {
        $('input:radio[name="phoneOS"][value="ANDROID"]').prop('checked', true);
    } */
});


function reqAuthTokenValidate(authToken) {
    iFrame_authToken_validate.location.href = _VERIFY_SERVER_URL
            + "?authToken=" + authToken;
}


function genResultValue(data) {
    var params = ksid.form.flushPanel('edit-panel');
    params.code = data;
    params.svcType = "FIDOPCRECCON";
    if( data == 200 ) {
        ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/mobileOsChg", params, function(result) {
            if( result.rstParam.retValue == "00") {
                ksid.ui.confirm("PC와 재연결을 완료하였습니다. 지문 등록을 하시겠습니까?", function() {
                    doFidoReg();
                    doClose();
                });
            }
            else {
                ksid.ui.alert("PC와 재연결 정보 과금서버 변경에 실패했습니다.", function() {
                    doClose();
                });
            }
        });
        ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rstdata) {
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


function genRandomValue(data) {
    document.getElementById('random').value = data;
}


function doFidoReg() {
    var params = ksid.form.flushPanel('edit-panel');
    params.custUserNo = document.form1.custUserNo.value;
    if( ksid.form.validateForm('edit-panel') ) {
        $("#form1").attr('action', '${pageContext.request.contextPath}/sdu/fidoservice/webfidoreg');
        $("#form1").attr('target', 'regPushChg');

        var regWin = ksid.ui.openWindow('', 'regPushChg', 550, 350);
        $("#form1").submit();
        regWin.focus();
    }
}


function doReg() {
    var params = ksid.form.flushPanel('edit-panel');
    params.custUserNo = document.form1.custUserNo.value;
    if( ksid.form.validateForm('edit-panel') ) {
        $("#form1").attr('action', '${pageContext.request.contextPath}/sdu/userreg');
        $("#form1").attr('target', 'regPushChg');

        var regWin = ksid.ui.openWindow('', 'regPushChg', 550, 530);
        $("#form1").submit();
        regWin.focus();
    }
}


function doPayRequest() {
    var params = ksid.form.flushPanel('edit-panel');
    params.custUserNo = document.form1.custUserNo.value;

    if( ksid.form.validateForm('edit-panel') ) {
        $("#form1").attr('action', '${pageContext.request.contextPath}/cnspay/request');
        $("#form1").attr('target', 'requestPushChg');

        var regWin = ksid.ui.openWindow('', 'requestPushChg', 616, 620);
        $("#form1").submit();
        regWin.focus();
    }
}


function doPhoneReg() {
    var params = ksid.form.flushPanel('edit-panel');
    params.custUserNo = document.form1.custUserNo.value;
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userStatChk", params, function(rcvdata) {
        document.form1.spNo.value = rcvdata.rstParam.spNo;
        document.form1.kookBun.value = rcvdata.rstParam.kookBun;
        document.form1.junBun.value = rcvdata.rstParam.junBun;
        if( rcvdata.rstParam.retValue == "00" ) {
            ksid.ui.confirm("지문 인증 서비스 미결제 상태 입니다. 지문 인증 서비스 결제를 하시겠습니까?", function() {
                doPayRequest();
                doClose();
            });
        }
        else if( rcvdata.rstParam.retValue == "01" ) {
            ksid.ui.confirm("지문 인증 서비스 미가입 상태 입니다. 지문 인증 서비스 가입을 하시겠습니까?", function() {
                doReg();
                doClose();
            });
        }
        else if( rcvdata.rstParam.retValue == "10" ) {
            ksid.ui.confirm("지문 인증 서비스 이용기간 만료 상태 입니다. 지문 인증 서비스 결제를 하시겠습니까?", function() {
                doPayRequest();
                doClose();
            });
        }
        else if( rcvdata.rstParam.retValue == "08" ) {
            /* document.form1.mobileOs.value = rcvdata.rstParam.phoneOs; */
            var radioValue = $(':radio[name="phoneOS"]:checked').val();
            var getUserId = document.form1.custUserNo.value;
            ksid.ui.confirm("PC와 재연결 인증 번호를 요청하시겠습니까?", function() {
                reqModifyConnect(getUserId);
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
                <td><img src="${pageContext.request.contextPath}/static/image/siteci/SDU_signature02.png" style="width:220px;margin-bottom:10px;" /></td>
            </tr>
        </table>
    </div>

    <center>
        <font style="font-size:24px;"><strong>지문 인증 서비스 - PC와 재연결</strong></font>
    </center>

    <br />

    <form id="form1" name="form1" method="post">

        <div id="edit-panel" class="edit-panel" style="min-width:400px;height:90px;">

            <input type="hidden" name="spCd" value="" /> <!-- 서비스제공자-KSID -->
            <input type="hidden" name="custId" value="" /> <!-- 고객사-열린사이버대학 -->
            <input type="hidden" name="servId" value=""/>
            <input type="hidden" name="spNo" value=""/>
            <input type="hidden" name="kookBun" value=""/>
            <input type="hidden" name="junBun" value=""/>
            <input type="hidden" name="mobileOs" value=""/>
            <div class="styleDlTable">
            <br />
                <dl>
                    <dt class="width120">학번</dt>
                    <dd>
                        <input type="text" maxlength="16" id="custUserNo" name="custUserNo" title="학번" class="style-input width110" format="no" readonly />&nbsp;&nbsp;
                        <button type="button" class="style-btn" auth="W" onclick="doPhoneReg()" style="width:140px; height:14px;">PC와 연결 인증 번호 요청</button>
                    </dd>
                </dl>
                <dl>
                    <dt class="width120">스마트폰운영체제</dt>
                    <dd style="margin-top:5px;">
                        <label><input TYPE="radio" name="phoneOS" value="iOS" checked />&nbsp;iOS</label>&nbsp;&nbsp;&nbsp;
                        <label><input TYPE="radio" name="phoneOS" value="ANDROID" />&nbsp;ANDROID</label>
                    </dd>
                </dl>
            </div>
        </div>
    </form>
    </br>
    <div class="button-bar" style="text-align:center;">
     <font style="font-size:13px;"><strong>아래 인증번호를 스마트폰의 한국전자인증FIDO앱에 입력해 주세요.</strong></font>
    </div>
    <div class="button-bar" style="text-align:center;">
    </br>
     <font style="font-size:12px;color:blue;"><strong>※스마트폰실행순서: 한국전자인증FIDO앱 실행&rArr;PC와연결 선택&rArr;인증번호입력</strong></font>
    </div>
    </br>
     <div class="button-bar" style="text-align:center;">
     <font style="font-size:12px;color:red;"><strong>반드시 스마트폰에 한국전자인증FIDO앱을 사전 설치하여야 합니다.</strong></font>
    </div>
    </br>
    <div class="button-bar" style="text-align:center;">
        <input type="text" id="random" name="random" class="style-input width150" style="font-size:16pt;width:320px;height:40px;text-align:center;" format="no" readonly/>
    </div>
    </br>
    <!--  button bar  -->
    <div class="button-bar" style="text-align:center;">
        <button type="button" class="style-btn" auth="W" onclick="doClose()" style="width:100px; height:30px;">닫기</button>
    </div>

    <!--// button bar  -->

</div>
</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>