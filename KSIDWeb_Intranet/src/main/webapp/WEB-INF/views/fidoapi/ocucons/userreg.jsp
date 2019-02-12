<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>지문 인증 서비스 가입</title>
<jsp:include page="${config.includePath}/css.jsp"/>
<jsp:include page="${config.includePath}/js.jsp"/>

<script type="text/javascript" src="${config.jsPath}/fidoservice/ocucons/servInfo.js"></script>

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

<script type="text/javascript" charset="utf-8">
var authMaxTm = 2;
var statFlag = 0;
var authFlag = 0;
var smsSendFlag = 0;
var gAuthCd = "";
var timer;

$(document).ready(function() {
    $('#edit-panel input[name=spNo]').keyup(function() {
        if($(this).val().length == 3) {
            $('#edit-panel input[name=kookBun]').focus();
        }
    });

    $('#edit-panel input[name=kookBun]').keyup(function() {
        if($(this).val().length == 4) {
            $('#edit-panel input[name=junBun]').focus();
        }
    });
    doMobileAuthDel();
    $("#edit-panel input[name=userNm]").focus();
    document.form1.custUserNo.value = "${param.custUserNo}".trim();
});


function doReg() {
    var params = ksid.form.flushPanel('edit-panel');

    if( $("#edit-panel input[name=custUserNo]").val().trim().length < 8 ) {
        ksid.ui.alert("학번을 입력해주세요.");
        return;
    }

    if( !$('input[name="phoneOs"]').is(':checked') ) {
        ksid.ui.alert("스마트폰운영체제를 선택해주세요.");
        return;
    }

    if( $("#edit-panel input[name=spNo]").val().length < 3 ||
            $("#edit-panel input[name=kookBun]").val().length < 3 ||
            $("#edit-panel input[name=junBun]").val().length < 4 ) {
            ksid.ui.alert("휴대폰 번호를 입력해주세요.");
            return;
    }

    params.spCd = gSpCd;
    params.custId = gCustId;
    params.servId = gServId;
    params.authNo = gAuthCd;
    params.svcType = "SVCREG";
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authRegChk", params, function(result) {
        if( params.chkTermsUser == 'Y' && params.chkTermsLbs == 'Y') {
                if(result.resultCd == '00') {
                    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userRegCheck", params, function(result) {
                        if(result.resultCd == "01") {
                            ksid.ui.confirm("지문 인증 서비스를 가입 하시겠습니까?", function() {
                                ksid.net.ajax("${pageContext.request.contextPath}/registration/user/reg", params, function(result) {
                                    /* ksid.ui.alert(result.resultData); */
                                    if(result.resultCd == '00') {
                                        params.code = 200;
                                        ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rstdata) {
                                            ksid.ui.confirm("지문 인증 서비스 가입이 완료 되었습니다.서비스를 이용하려면 결제를 하여야 합니다. 결제하시겠습니까?", function() {
                                                doPayRequest();
                                                doClose();
                                            });
                                        });

                                    }
                                });
                            });
                        }
                        else if(result.resultCd == "02") {
                            params.code = 201;
                            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rstdata) {
                                ksid.ui.confirm("이미 지문 인증 서비스 가입 완료 상태 입니다. 서비스를 이용하려면 결제를 하여야 합니다. 결제하시겠습니까?", function() {
                                    doPayRequest();
                                    doClose();
                                });
                            });
                        }
                        else if(result.resultCd == "05") {
                            params.code = 201;
                            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rstdata) {
                                ksid.ui.alert("지문 인증 서비스 가입 정보가 있습니다.\n 콜센터에 문의 하십시오.[032-8060-0270]\n [번호 변경 필수 문의]");
                            });
                        }
                    });
                }
                else if(result.resultCd == "02") {
                    ksid.ui.alert("휴대폰번호 인증을 하십시오.");
                }
                else if(result.resultCd == "04") {
                    ksid.ui.alert("지문 인증 서비스 가입 유효 시간을 초과하였습니다.");
                }
        }
        else {
            ksid.ui.alert("약관에 모두 동의 해야 가입이 가능합니다.");
        }
    });
}


function doChkSelect() {
    var params = ksid.form.flushPanel('edit-panel');

    if( params.chkTermsAll != 'Y' ) {
        $("#edit-panel input[type=checkbox]").prop("checked", false);
    }

    if( params.chkTermsAll == 'Y' ) {
        $("#edit-panel input[type=checkbox]").prop("checked", true);
    }
}


function doPayRequest() {
    var params = ksid.form.flushPanel('edit-panel');
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/cnspay/request');
        $("#form1").attr('target', 'requestReg');

        var regWin = ksid.ui.openWindow('', 'requestReg', 616, 620);
        $("#form1").submit();
        regWin.focus();
    }
}


function doAuthConfirm() {
    var params = ksid.form.flushPanel('edit-panel');

    if( statFlag == 1) {
        ksid.ui.alert("인증 확인 시간을 초과하였습니다.");
        return;
    }

    if(params.authNo == "") {
        ksid.ui.alert("인증 번호를 입력해 주십시오.");
        return;
    }

    if(params.spNo == "" || params.junBun == "" || params.kookBun == "") {
        ksid.ui.alert("휴대폰 정보가 올바르지 않습니다.");
        return;
    }

    params.spCd = gSpCd;
    params.custId = gCustId;
    params.servId = gServId;
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authConfirm", params, function(result) {
        if(result.resultCd == "00") {
            authFlag = 1;
            statFlag = 0;
            gAuthCd = $("#edit-panel input[name=authNo]").val().trim();
            $("#edit-panel input[name=authNo]").val('');
            ksid.ui.alert("정상 인증 되었습니다.");
            /* doMobileAuthDel(); */
        }
        else if(result.resultCd == "02") {
            authFlag = 1;
            ksid.ui.alert("이미 인증된 번호 입니다.");
            /* doMobileAuthDel(); */
        }
        else if(result.resultCd == "04") {
            authFlag = 1;
            ksid.ui.alert("인증번호 확인 유효시간 초과하였습니다.");
            /* doMobileAuthDel(); */
        }
        else {
            ksid.ui.alert("인증에 실패하였습니다.");
        }
    });
}


function doMobileAuthReq() {
    var params = ksid.form.flushPanel('edit-panel');

    $("#edit-panel input[name=authNo]").val('');

    if( $("#edit-panel input[name=spNo]").val().length < 3 ||
        $("#edit-panel input[name=kookBun]").val().length < 3 ||
        $("#edit-panel input[name=junBun]").val().length < 4 ) {
            ksid.ui.alert("휴대폰 번호를 입력해주세요.");
            return;
    }

    /* if( smsSendFlag == 1 ) {
        ksid.ui.alert("이미 인증번호가 발송되었습니다. 인증확인 하십시오.");
        return;
    } */

    params.spCd = gSpCd;
    params.custId = gCustId;
    params.servId = gServId;
    params.type = "REG";
    statFlag = 0;
    authFlag = 0;
    doMobileAuthDel();
    timerModule();

    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authNumReq", params, function(result) {
        if(result.resultCd == "00" || result.resultCd == "07") {
            ksid.ui.alert("인증번호가 정상적으로 전송 되었습니다.");
            var statFlag = 0;
            var authFlag = 0;
        }
        else if(result.resultCd == "02") {
            ksid.ui.alert("인증 확인 상태입니다.");
        }
        else if(result.resultCd == "06") {
            ksid.ui.alert("이미 지문 인증 서비스 가입한 학번 정보가 있습니다.");
        }
        /* else if(result.resultCd == "07") {
            ksid.ui.alert("이미 지문 인증 서비스 가입한 휴대번호 정보가 있습니다.");
        } */
        else {
            ksid.ui.alert("인증번호 전송에 실패 하였습니다.");
        }
    });
}


function doMobileAuthDel() {
    var params = ksid.form.flushPanel('edit-panel');

    params.spCd = gSpCd;
    params.custId = gCustId;
    params.servId = gServId;
    params.custUserNo = "${param.custUserNo}";
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authUserNumDel", params, function(result) {
        if(result.resultCd == "00") {
            /*  alert("인증번호가 delete 정상적으로 전송 되었습니다."); */
        }
    });
}


function timerModule() {
    var hour = 0;
    var minute = authMaxTm;
    var second = 0;
    clearInterval(timer);
    /* $(".timeMin").html(minute);
    $(".timeSec").html(second); */
    var tmp = minute + "분 " + second + "초";
    $("#edit-panel input[name=timerText]").val(tmp);

    timer = setInterval(function () {
        /* $(".timeMin").html(minute);
        $(".timeSec").html(second); */
        var tmp = minute + "분 " + second + "초";
        $("#edit-panel input[name=timerText]").val(tmp);
        if( authFlag == 1 ) {
            clearInterval(timer); /* 타이머 종료 */
            var minute2 = authMaxTm;
            var second2 = 0;
            var tmp = minute2 + "분 " + second2 + "초";
            $("#edit-panel input[name=timerText]").val(tmp);
            /* smsSendFlag = 0; */
            /* $("#edit-panel input[name=authNo]").val(''); */
        }
        if( authFlag == 0 && second == 0 && minute == 0 ){
            clearInterval(timer); /* 타이머 종료 */
            var minute2 = authMaxTm;
            var second2 = 0;
            var tmp = minute2 + "분 " + second2 + "초";
            $("#edit-panel input[name=timerText]").val(tmp);
            doMobileAuthDel();
            statFlag = 1;
            /* smsSendFlag = 0; */
            ksid.ui.alert("인증 확인 시간을 초과하였습니다.");
        }
        else {
            second--;
            // 분처리
            if(second < 0) {
                minute--;
                second = 59;
            }

             //시간처리
            /* if(minute < 0){
                if(hour > 0){
                    hour--;
                    minute = 59;

                }
            } */
        }
    }, 1000); /* millisecond 단위의 인터벌 */
}




function doChkSelect() {
    var params = ksid.form.flushPanel('edit-panel');

    if( params.chkTermsAll != 'Y' ) {
        $("#edit-panel input[type=checkbox]").prop("checked", false);
    }

    if( params.chkTermsAll == 'Y' ) {
        $("#edit-panel input[type=checkbox]").prop("checked", true);
    }
}


function doClose() {
    window.close();
}

</script>
</head>
<body oncontextmenu="return false" ondragstart="return false" onselectstart="return false" style="overflow-x:hidden; overflow-y:hidden;">
<div class="contents-wrap">

    <br/>

    <div class="styleDlTable">

        <table style="width:99%">
            <colgroup>
                <col width="200" />
                <col width="*" />
            </colgroup>
            <tr>
                <td><img src="${config.imagePath}/fidoapi/ocucons.png" style="margin-bottom:10px;" /></td>
            </tr>
        </table>
    </div>
    <br/>
    <center>
        <font style="font-size:25px;"><strong>지문 인증 서비스 가입</strong></font>
    </center>

    <br />

    <form id="form1" name="form1" method="post" action="popup url" target="popup_window">

<!--         <div id="edit-panel" class="edit-panel" style="min-width:400px;height:270px;"> -->

        <div id="edit-panel" class="edit-panel" style="min-width:200;width:device-width;height:auto;">
            <input type="hidden" name="spCd" value="P0003" /> <!-- 서비스제공자-KSID -->
            <input type="hidden" name="custId" value="C000022" /> <!-- 고객사-OCU컨소시엄 -->
            <input type="hidden" name="servId" value="S00000040"/>
            <input type="hidden" name="payFinalUrl" value="ocucons/userPayFinal"/>
            <br>
            <table class="styleContentsTable" cellpadding="0" cellspacing="1" border="0" font-size="7px">
                <colgroup>
                    <col class="width145"/>
                    <col/>
                </colgroup>

                <tbody>
                    <tr>
                        <th class="title_on">학번</th>
                        <td>
                            <input type="text" maxlength="16" name="custUserNo" title="학번" class="style-input width110" readonly />
                        </td>
                    </tr>
                    <tr>
                        <th class="title_on">스마트폰운영체제</th>
                        <td>
                            <span>
                                <label><input type="radio" name="phoneOs" value="I"  />&nbsp;아이폰</label>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <label><input TYPE="radio" name="phoneOs" value="A" />&nbsp;아이폰외(안드로이드폰)</label><br><br>
                                <label>※  스마트폰 운영체제를 정확히 입력하셔야 합니다.</label><br>
                                <font style="font-size:15px;"><strong>&nbsp;</font>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th class="title_on">휴대폰번호</th>
                        <td>
                            <span>
                                <input type="text" maxlength="3" name="spNo" title="사업자번호" class="style-input width30" />&nbsp;<!--
                                --><font style="color:#999"> - </font>&nbsp;<!--
                                --><input type="text" maxlength="4" name="kookBun" title="국번" class="style-input width55" />&nbsp;<!--
                                --><font style="color:#999"> - </font>&nbsp;<!--
                                --><input type="text" maxlength="4" name="junBun" title="전번" class="style-input width55" />&nbsp;&nbsp;&nbsp;&nbsp;<!--
                                --><button type="button" class="style-btn" auth="W" onclick="doMobileAuthReq()" style="width:70px; height:14px;">인증번호 요청</button>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th class="title_on">인증번호</th>
                        <td>
                            <span>
                                <input type="text" maxlength="6" name="authNo" title="인증번호" class="style-input" style="width:110" />&nbsp;&nbsp;<!--
                                --><button type="button" class="style-btn" auth="W" onclick="doAuthConfirm()" style="width:70px; height:14px;">인증 확인</button>&nbsp;&nbsp;<!--
                                --><input type="text" maxlength="6" name="timerText" title="타이머" value = "2분 0초" class="style-input" style="border:0px;background-color:#e2e2e2;color:black;width:50;" disabled />
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <font style="font-size:5px;"><strong>&nbsp;</font>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type='checkbox' id="chkGroupTermsAll" name="chkTermsAll" value='Y' class='chkSearch' onclick="doChkSelect()" checked /><label for='chkGroupTermsAll'>&nbsp;&nbsp;아래 약관에 모두 동의</label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type='checkbox' id="chkGroupTermsUser" name="chkTermsUser" value='Y' class='chkSearch' checked /><label for='chkGroupTermsUser'>&nbsp;&nbsp;개인 정보 수집</label> &nbsp;&nbsp;
                            <a href = "${config.htmlPath}/collect.html" target = "_blank"> [보기] </a>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type='checkbox' id="chkGroupTermsLbs" name="chkTermsLbs" value='Y' class='chkSearch' checked /><label for='chkGroupTermsLbs'>&nbsp;&nbsp;서비스 이용 약관</label> &nbsp;&nbsp;
                            <a href = "${config.htmlPath}/usetermsOcucons.html" target = "_blank"> [보기] </a>
                        </td>
                    </tr>
                </tbody>

            </table>

        </div>
    </form>

    <br/>
    <!--  button bar  -->
    <div class="button-bar" style="text-align:center;">
        <button type="button" class="style-btn" auth="W" onclick="doReg()" style="width:100px; height:30px;">가입</button>
        <button type="button" class="style-btn" auth="W" onclick="doClose()" style="width:100px; height:30px;">닫기</button>
    </div>

    <!--// button bar  -->

</div>
</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>