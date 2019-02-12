<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>OCU 사용자 가입</title>
<jsp:include page="${config.includePath}/css.jsp"/>
<jsp:include page="${config.includePath}/js.jsp"/>

<style type="text/css">
    #mainTabs .tabs-inner {
        height:28px !important;
    }

    /* jquery 다이얼로그 닫기 버튼 없애기 */
    .ui-dialog-titlebar-close {
        visibility: hidden;
    }

    /* jquery datepicker css 변경 */
    .ui-datepicker select.ui-datepicker-year {width:60px;}
    .ui-datepicker select.ui-datepicker-month {width:55px;}
    .ui-datepicker { font-size:9pt; width:200px; }
    img.ui-datepicker-trigger {margin-left:5px;vertical-align:middle;cursor:default}

    /* jqgrid 버그 패치 */
    .ui-jqgrid .ui-jqgrid-bdiv div div
    {
        display:none;
    }

    /* 공통 ui css 변경 */
    .ui-widget-content {background:#ffffff;}
    .footrow {background:#e2ebfc;}
    .footrow td:first-child  {background:#e2ebfc;}

    table.ui-jqgrid-btable { height: 1px; }
</style>

<script type="text/javascript" charset="utf-8">
var gSpCd = "P0003";
var gCustId = "C000018";
var gServId = "S00000007";
var initMaxTm = 10;
var authMaxTm = 2;
var statFlag = 0;
var authFlag = 0;
var mStatFlag = 0;
var mAuthFlag = 0;
var smsSendFlag = 0;
var gAuthCd = "";
var timer;
var mainTimer;

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
    $("#edit-panel input[name=userNm]").focus();
});


function doReg() {
    var params = ksid.form.flushPanel('edit-panel');
    initFlag = 1;

    if( $("#edit-panel input[name=userNm]").val().length == 0 ) {
        ksid.ui.alert("이름을 입력해주세요.");
        return;
    }

    if( $("#edit-panel input[name=custUserNo]").val().length < 8 ) {
        ksid.ui.alert("학번을 입력해주세요.");
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
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authRegChk", params, function(result) {
        if( params.chkTermsUser == 'Y' &&
            params.chkTermsLbs == 'Y' &&
            params.chkTermsMobile == 'Y' &&
            params.chkTermsCert == 'Y' ) {
                if(result.resultCd == '00') {
                    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userRegCheck", params, function(result) {
                        if(result.resultCd == "00") {
                            ksid.ui.confirm("가입하시겠습니까?", function() {
                                ksid.net.ajax("${pageContext.request.contextPath}/registration/user/reg", params, function(result) {
                                    ksid.ui.alert(result.resultData);
                                    if(result.resultCd == '00') {
                                        ksid.ui.confirm("가입이 완료 되었습니다. 결제하시겠습니까?", function() {
                                            doPayRequest();
                                        });
                                        /* try {
                                            opener.doQuery();
                                            self.close()
                                        } catch (e) {
                                            // TODO: handle exception
                                        } */
                                    }
                                });
                            });
                        }
                        else if(result.resultCd == "02") {
                            ksid.ui.confirm("이미 서비스 가입 완료했습니다. 서비스를 이용하려면 결제를 하여야 합니다. 결제하시겠습니까?", function() {
                                doPayRequest();
                            });
                        }
                        else if(result.resultCd == "03") {
                            ksid.ui.alert("이미 서비스 가입 사용자 입니다.");
                        }
                        else if(result.resultCd == "05") {
                            ksid.ui.alert("서비스 가입 정보가 있습니다.\n 콜센터에 문의 하십시오.[032-8060-0165]\n [번호 변경 필수 문의]");
                        }
                    });
                }
                else if(result.resultCd == "02") {
                    ksid.ui.alert("휴대폰번호 인증을 하십시오.");
                }
                else if(result.resultCd == "04") {
                    ksid.ui.alert("가입 유효 시간을 초과하였습니다.");
                }
        }
        else {
            ksid.ui.alert("약관에 모두 동의 해야 가입이 가능합니다.");
        }
    });
}


function doRegAction() {
    var params = ksid.form.flushPanel('edit-panel');
    params.spCd = gSpCd;
    params.custId = gCustId;
    params.servId = gServId;
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userRegCheck", params, function(result) {
        if(result.resultCd == "00") {
            ksid.ui.alert("정상 가입 결재 사용자 입니다.");
        }
        else if(result.resultCd == "02") {
            ksid.ui.confirm("서비스 가입 사용자 입니다. 서비스를 이용하려면 결제를 해야만 합니다. 결제하시겠습니까?", function() {
                doPayRequest();
            });
        }
        else if(result.resultCd == "05") {
            ksid.ui.alert("서비스 가입 정보가 있습니다.\n 콜센터에 문의 하십시오.[032-8060-0165]\n [번호 변경 필수 문의]");
        }
        else {
            ksid.ui.confirm("서비스 가입이 가능합니다. 가입하시겠습니까?", function() {
                $("#form1").attr('action', '${pageContext.request.contextPath}/userreg');
                $("#form1").attr('target', 'userreg');

                var regWin = ksid.ui.openWindow('', 'userreg', 600, 600);

                $("#form1").submit();
                /* var regWin = ksid.ui.openWindow('${pageContext.request.contextPath}/userreg', 'userregwin', 600, 600); */
                regWin.focus();
            });
        }
    });
}



function doUserInfoSearch() {
    var params = ksid.form.flushPanel('edit-panel');
    initFlag = 1;
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
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authRegChk", params, function(result) {
        if(result.resultCd == '00') {
            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userRegCheck", params, function(result) {
                if(result.resultCd == "01") {
                    ksid.ui.alert("서비스 미가입 사용자 입니다.");
                }
                else if(result.resultCd == "05") {
                    ksid.ui.alert("서비스 가입 정보가 있습니다.\n 콜센터에 문의 하십시오.[032-8060-0165]\n [번호 변경 필수 문의]");
                }
                else {
                    $("#form1").attr('action', '${pageContext.request.contextPath}/ocuuser/userInfo');
                    $("#form1").attr('target', 'userInfo');

                    var regWin = ksid.ui.openWindow('', 'userInfo', 800, 700);

                    $("#form1").submit();
                    regWin.focus();
                }
            });
        }
        else if(result.resultCd == "02") {
            ksid.ui.alert("휴대폰번호 인증을 하십시오.");
        }
        else if(result.resultCd == "04") {
            ksid.ui.alert("인증 유효 시간[15분]을 초과하였습니다.");
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

function doTest() {
    /* var params = ksid.form.flushPanel('edit-panel');
    initFlag = 1;
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/cnspay/request');
        $("#form1").attr('target', 'request');

        var regWin = ksid.ui.openWindow('', 'request', 616, 620);
        $("#form1").submit(); */

        var regWin = ksid.ui.openWindow('${pageContext.request.contextPath}/ocuuser/userPayFinal', 'userPayFinal', 800, 700);

        regWin.focus();
}


function doPayRequest() {
    var params = ksid.form.flushPanel('edit-panel');
    initFlag = 1;
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/cnspay/request');
        $("#form1").attr('target', 'request');

        var regWin = ksid.ui.openWindow('', 'request', 616, 620);
        $("#form1").submit();
        regWin.focus();
    }
}


function doPayReq() {
    var params = ksid.form.flushPanel('edit-panel');
    /*  $("#edit-panel input[name=authNo]").val(''); */

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
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authRegChk", params, function(result) {
        if(result.resultCd == '00') {
            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userRegCheck", params, function(result) {
                if(result.resultCd == "00") {
                    ksid.ui.alert("이미 서비스 결제를 완료하였습니다.");
                }
                else if(result.resultCd == "02") {
                    ksid.ui.confirm("결제하시겠습니까?", function() {
                        doPayRequest();
                    });
                }
                else if(result.resultCd == "05") {
                    ksid.ui.alert("서비스 가입 정보가 있습니다.\n 콜센터에 문의 하십시오.[032-8060-0165]\n [번호 변경 필수 문의]");
                }
                else {
                    ksid.ui.alert("서비스 미가입 사용자 입니다.");
                }
            });
        }
        else if(result.resultCd == "02") {
            ksid.ui.alert("휴대폰번호 인증을 하십시오.");
        }
        else if(result.resultCd == "04") {
            ksid.ui.alert("인증 유효 시간[15분]을 초과하였습니다.");
        }
   });
}


function doUnreq() {

    var params = ksid.form.flushPanel('edit-panel');
    /*  $("#edit-panel input[name=authNo]").val(''); */

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
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authRegChk", params, function(result) {
        if(result.resultCd == '00') {
            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userRegCheck", params, function(result) {
                if(result.resultCd == "01") {
                    ksid.ui.alert("서비스 미가입 사용자 입니다.");
                }
                else {
                    ksid.ui.confirm("서비스 해지하시겠습니까?", function() {  //가입자삭제:delUser, 서비스해지:deregServ, 가입해지:deregUser
                        ksid.net.ajax("${pageContext.request.contextPath}/registration/user/delUser", params, function(result) {
                            //ksid.ui.alert(result.resultData);
                            if(result.resultCd == '00') {
                                ksid.ui.alert("서비스가 해지 성공했습니다.");
                            } else {
                                ksid.ui.alert("서비스가 해지 실패했습니다. 콜센터에 문의 하십시오.");
                            }
                        });
                    });
                }
            });
        }
        else if(result.resultCd == "02") {
            ksid.ui.alert("휴대폰번호 인증을 하십시오.");
        }
        else if(result.resultCd == "04") {
            ksid.ui.alert("인증 유효 시간[15분]을 초과하였습니다.");
        }
   });
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
            initFlag = 1;
            mainTimerModule();
            gAuthCd = $("#edit-panel input[name=authNo]").val();
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
    initFlag = 1;
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
    statFlag = 0;
    authFlag = 0;
    doMobileAuthDel();
    /* setTimeout( timerModule(), 1000); */
    timerModule();

    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authNumReq", params, function(result) {
        if(result.resultCd == "00") {
            ksid.ui.alert("인증번호가 정상적으로 전송 되었습니다.");
            var statFlag = 0;
            var authFlag = 0;
            var mStatFlag = 0;
            var mAuthFlag = 0;
            /* smsSendFlag = 1; */
        }
        else if(result.resultCd == "02") {
            ksid.ui.alert("인증 확인 상태입니다.");
        }
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
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authNumDel", params, function(result) {
        if(result.resultCd == "00") {
            /*  alert("인증번호가 delete 정상적으로 전송 되었습니다."); */
        }
    });
    /* var regWin = ksid.ui.openWindow('${pageContext.request.contextPath}/devauth/mobileauth', 'authwin', 600, 600);
    regWin.focus(); */
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

var initFlag = 0;
function doMainTimeInit() {
    initFlag = 1;
}

$(function() {
    $("#initBtn").click(function(){
        initFlag = 1;
    });
});


function mainTimerModule() {
    var hour = 0;
    var minute = initMaxTm;
    var second = 0;
    clearInterval(mainTimer);
    /* $(".timeMin").html(minute);
    $(".timeSec").html(second); */
    var tmp = minute + "분 " + second + "초";
    $("#mainTmId").val(tmp);

    mainTimer = setInterval(function () {
        /* $(".timeMin").html(minute);
        $(".timeSec").html(second); */
        var tmp = minute + "분 " + second + "초";
        $("#mainTmId").val(tmp);

        if( initFlag == 1 ) {
            clearInterval(mainTimer); /* 타이머 종료 */
            var minute2 = initMaxTm;
            var second2 = 0;
            var tmp = minute2 + "분 " + second2 + "초";
            $("#mainTmId").val(tmp);
            initFlag = 0;
            mainTimerModule();
        }

        if( mAuthFlag == 1 ) {
            clearInterval(mainTimer); /* 타이머 종료 */
            var minute2 = initMaxTm;
            var second2 = 0;
            var tmp = minute2 + "분 " + second2 + "초";
            $("#mainTmId").val(tmp);
        }

        if( mAuthFlag == 0 && second == 0 && minute == 0 ){
            clearInterval(mainTimer); /* 타이머 종료 */
            var minute2 = initMaxTm;
            var second2 = 0;
            var tmp = minute2 + "분 " + second2 + "초";
            $("#mainTmId").val(tmp);
            doMobileAuthDel();
            mStatFlag = 1;
            /* smsSendFlag = 0; */
            ksid.ui.alert("사용 유효 시간을 초과하였습니다. 휴대폰번호 재 인증 후 사용하십시오.");
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
                    mHour--;
                    minute = 59;
                }
            } */
        }
    }, 1000); /* millisecond 단위의 인터벌 */
}


$(document).ready(function(){
    var params = ksid.form.flushPanel('edit-panel');
    /* mainTimerModule(); */
});


function doChkSelect() {
    var params = ksid.form.flushPanel('edit-panel');

    if( params.chkTermsAll != 'Y' ) {
        $("#edit-panel input[type=checkbox]").prop("checked", false);
    }

    if( params.chkTermsAll == 'Y' ) {
        $("#edit-panel input[type=checkbox]").prop("checked", true);
    }
}


</script>
</head>
<body style="overflow-x:hidden; overflow-y:hidden;">
<div class="contents-wrap">

    <br />

    <div class="styleDlTable">

        <table style="width:100%">
            <colgroup>
                <col width="200" />
                <col width="*" />
            </colgroup>
            <tr>
                <td><img src="${pageContext.request.contextPath}/static/image/siteci/ocuci_all.png" style="width:270px;margin-bottom:10px;" /></td>
                <td style="text-align:right">
                <font style="font-size:12px"><strong>사용 유효 시간 :</strong></font>
                <input id="mainTmId" type="text" maxlength="6" name="mainTimerText" title="메안타이머" value = "10분 0초" class="style-input width45" format="no" style="border: 0px;background-color: #e2e2e2;color:black" disabled />
                <button id="initBtn" type="button" class="style-btn" auth="W" onclick="doMainTimeInit" style="width:30px; height:14px;">연장</button>
                </td>
            </tr>
        </table>
    </div>

    <center>
        <font style="font-size:25px; font-family:'바탕체'"><strong>지문 인증 서비스</strong></font>
    </center>

    <br />

    <form id="form1" name="form1" method="post" action="popup url" target="popup_window">

        <div id="edit-panel" class="edit-panel" style="min-width:400px;height:240px;">

            <input type="hidden" name="spCd" value="P0003" /> <!-- 서비스제공자-KSID -->
            <input type="hidden" name="custId" value="C000018" /> <!-- 고객사-열린사이버대학 -->
            <input type="hidden" name="servId" value="S00000007"/>
            <!-- <input type="hidden" name="goodsName" value="지문 인증 서비스" />
            <input type="hidden" name="amt" value="3300" /> -->

            <div class="styleDlTable">
                <dl>
                <dt class="title_on width80">이름</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="userNm" title="이름" class="style-input width110" required />
                </dd>
                </dl>
                <dl>
                    <dt class="title_on width80">학번</dt>
                    <dd>
                        <input type="text" maxlength="8" name="custUserNo" title="학번" class="style-input width110" format="no" />
                    </dd>
                </dl>
                <dl>
                <dt class="title_on width80">휴대폰번호</dt>
                <dd class="width10">
                    <!-- <select name="mobileCompany" title="통신사" class="style-select width70" codeGroupCd="MOBILE_COMPANY"></select>
                    &nbsp;&nbsp; -->
                    <input type="text" maxlength="3" name="spNo" title="사업자번호" class="style-input width30" format="no" />
                    &nbsp;&nbsp;<font style="color:#999"> - &nbsp;</font>
                </dd>
                <dd class="width10">
                    <input type="text" maxlength="4" name="kookBun" title="국번" class="style-input width55" format="no" />
                    &nbsp;&nbsp;<font style="color:#999"> - &nbsp;</font>
                </dd>
                <dd class="width10">
                    <input type="text" maxlength="4" name="junBun" title="전번" class="style-input width55" format="no" />
                </dd>
                <dd class="width10">
                </dd>
                <dd>
                    <button type="button" class="style-btn" auth="W" onclick="doMobileAuthReq()" style="width:70px; height:14px;">인증번호 요청</button>
                </dd>
            </dl>
            <dl>
                <dt class="title_on width80">인증번호</dt>
                <dd class="width130">
                    <input type="text" maxlength="6" name="authNo" title="인증번호" class="style-input width110" format="no" />
                </dd>
                <dd>
                    <button type="button" class="style-btn" auth="W" onclick="doAuthConfirm()" style="width:70px; height:14px;">인증 확인</button>
                </dd>
                <dd class="width10">
                    <input type="text" maxlength="6" name="timerText" title="타이머" value = "2분 0초" class="style-input width50" format="no" style="border: 0px;background-color: #e2e2e2;color:black;" disabled />
                </dd>
            </dl>
            <dl style="height:10px;">
            </dl>
            <dl>
                <dd style="margin-top:5px;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type='checkbox' id="chkGroupTermsAll" name="chkTermsAll" value='Y' class='chkSearch' onclick="doChkSelect()" checked /><label for='chkGroupTermsAll'>&nbsp;&nbsp;아래 약관에 모두 동의</label>
                    &nbsp;&nbsp;
                </dd>
            </dl>

            <table style="font-size:12px;margin-left:50px;margin-top:10px;" cellpadding="5">
                <tr style="height:25px;">
                    <td>
                    <input type='checkbox' id="chkGroupTermsUser" name="chkTermsUser" value='Y' class='chkSearch' checked /><label for='chkGroupTermsUser'>&nbsp;&nbsp;개인정보 이용</label>
                     &nbsp;&nbsp;
                     <a href = "http://www.emobileid.co.kr" target = "_blank"> [보기] </a>
                    </td>
                    <td style="width:50px;">&nbsp;</td>
                    <td>
                    <input type='checkbox' id="chkGroupTermsLbs" name="chkTermsLbs" value='Y' class='chkSearch' checked /><label for='chkGroupTermsLbs'>&nbsp;&nbsp;고유식별정보 처리</label>
                    &nbsp;&nbsp;
                    <a href = "http://www.emobileid.co.kr" target = "_blank"> [보기] </a>
                    </td>
                </tr>
                <tr style="height:25px;">
                    <td>
                    <input type='checkbox' id="chkGroupTermsMobile" name="chkTermsMobile" value='Y' class='chkSearch' checked /><label for='chkGroupTermsMobile'>&nbsp;&nbsp;통신사 이용 약관</label>
                    &nbsp;&nbsp;
                    <a href = "http://www.emobileid.co.kr" target = "_blank"> [보기] </a>
                    </td>
                    <td style="width:50px;">&nbsp;</td>
                    <td>
                    <input type='checkbox' id="chkGroupTermsCert" name="chkTermsCert" value='Y' class='chkSearch' checked /><label for='chkGroupTermsCert'>&nbsp;&nbsp;이용 약관</label>
                    &nbsp;&nbsp;
                    <a href = "http://www.emobileid.co.kr" target = "_blank"> [보기] </a>
                    </td>
                </tr>
            </table>
            </div>
        </div>

    </form>

    <br />
    <div class="button-bar" style="height:20px;">
    </div>
    <!--  button bar  -->
    <div class="button-bar" style="text-align:center;">
        <button type="button" class="style-btn" auth="W" onclick="doReg()" style="width:100px; height:30px;">가입</button>
        <button type="button" class="style-btn" auth="W" onclick="doUserInfoSearch()" style="width:100px; height:30px;">조회</button>
        <button type="button" class="style-btn" auth="W" onclick="doPayReq()" style="width:100px; height:30px;">결제</button>
        <button type="button" class="style-btn" auth="W" onclick="doUnreq()" style="width:100px; height:30px;">해지</button>
    </div>
    <br />
    <br />
    <br />
    <div style="width:570px; height:60px; border:1px solid #777" >
    <pre><span style="font-size:12px">
  지문 인증 서비스는 온라인 환경에서 아이디, 패스워드 방식 대신 지문인식과 같은 생체인식
 기술을 활용하여 보다 편리하고 안전하게 개인 인증을 수행하는 서비스
        </textarea>
    </span></pre>
    </div>

    <!--// button bar  -->

</div>
</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>