<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>OCU 사용자 서비스 해지 </title>
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
</style>

<script type="text/javascript" charset="utf-8">
var gSpCd = "P0003";
var gCustId = "C000018";
var gServId = "S00000007";
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


function doUserInfoView() {
    document.form1.spNo.value    = result.rstParam.spNo;
    document.form1.kookBun.value = result.rstParam.kookBun;
    document.form1.junBun.value  = result.rstParam.junBun;
    $("#form1").attr('action', '${pageContext.request.contextPath}/ocuuser/userInfo');
    $("#form1").attr('target', 'userInfo');

    var regWin = ksid.ui.openWindow('', 'userInfo', 800, 700);

    $("#form1").submit();
    regWin.focus();
}

function doDereg() {

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
    params.custUserNo = document.form1.custUserNo.value;
    params.svcType = "SVCDEREG";
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/authRegChk", params, function(result) {
        if(result.resultCd == '00') {
            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userRegCheck", params, function(result) {
                if(result.resultCd == "01") {
                    ksid.ui.alert("지문 인증 서비스 미가입 상태입니다.");
                }
                else if(result.resultCd == "08") {
                    ksid.ui.confirm("지문 인증 서비스 결제일 기준 7일 이내 사용자는 서비스 해지 시, 결제승인취소를 해야 정상 서비스 해지가 가능합니다.\n 결제승인취소 하시겠습니까?", function() {  //가입자삭제:delUser, 서비스해지:deregServ, 가입해지:deregUser
                        document.form1.spNo.value    = params.spNo;
                        document.form1.kookBun.value = params.junBun;
                        document.form1.junBun.value  = params.kookBun;
                        document.form1.userID.value  = document.form1.custUserNo.value;
                        $("#form1").attr('action', '${pageContext.request.contextPath}/ocuuser/userInfo');
                        $("#form1").attr('target', 'userInfo');

                        var regWin = ksid.ui.openWindow('', 'userInfo', 800, 700);

                        $("#form1").submit();
                        regWin.focus();
                        doClose();
                    });
                }
                else {
                    ksid.ui.confirm("지문 인증 서비스를 해지하시겠습니까?", function() {  //가입자삭제:delUser, 서비스해지:deregServ, 가입해지:deregUser
                        ksid.net.ajax("${pageContext.request.contextPath}/registration/user/delUser", params, function(result) {
                            ksid.ui.alert(result.resultData);
                            if(result.resultCd == '00') {
                                params.code = "200";
                                ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rcvdata) {
                                    ksid.ui.alert("지문 인증 서비스가 정상 해지되었습니다.", function() {
                                        doClose();
                                    });
                                });
                                /* doClose(); */
                            } else {
                                params.code = "201";
                                ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rcvdata) {
                                    ksid.ui.alert("지문 인증 서비스 해지에 실패했습니다. 콜센터에 문의 하십시오.", function() {
                                        doClose();
                                    });
                                });
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


function doReg() {
    var params = ksid.form.flushPanel('edit-panel');
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/userreg');
        $("#form1").attr('target', 'regCancel');

        var regWin = ksid.ui.openWindow('', 'regCancel', 550, 530);
        $("#form1").submit();
        regWin.focus();
    }
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
    params.type = "CANCEL";
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
        }
        else if(result.resultCd == "02") {
            ksid.ui.alert("인증 확인 상태입니다.");
        }
        else if(result.resultCd == "06") {
            ksid.ui.confirm("지문 인증 서비스 가입 정보가 없습니다. 지문 인증 서비스 가입을 하시겠습니까?", function() {
                doReg();
                doClose();
            });
        }
        else if(result.resultCd == "07") {
            ksid.ui.alert("이미 등록된 휴대폰 번호가 있습니다.");
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
    params.custUserNo = "${param.custUserNo}".trim();
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
                <td><img src="${pageContext.request.contextPath}/static/image/siteci/ocu_signiture_02.png" style="width:220px;margin-bottom:10px;" /></td>
            </tr>
        </table>
    </div>

    <center>
        <font style="font-size:25px;"><strong>지문 인증 서비스 해지</strong></font>
    </center>

    <br />

    <form id="form1" name="form1" method="post" action="popup url" target="popup_window">

        <div id="edit-panel" class="edit-panel" style="min-width:400px;height:140px;">

            <input type="hidden" name="spCd" value="P0003" /> <!-- 서비스제공자-KSID -->
            <input type="hidden" name="custId" value="C000018" /> <!-- 고객사-열린사이버대학 -->
            <input type="hidden" name="servId" value="S00000007"/>
            <input type="hidden" name="userID" value=""/>
            <div class="styleDlTable">
                </br>
                <dl>
                    <dt class="title_on width80">학번</dt>
                    <dd>
                        <input type="text" maxlength="16" name="custUserNo" title="학번" class="style-input width110" format="no" readonly />
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
            </div>
        </div>

    </form>

    <br />
    <div class="button-bar" style="height:20px;">
    </div>
    <!--  button bar  -->
    <div class="button-bar" style="text-align:center;">
        <button type="button" class="style-btn" auth="W" onclick="doDereg()" style="width:100px; height:30px;">해지</button>
        <button type="button" class="style-btn" auth="W" onclick="doClose()" style="width:100px; height:30px;">닫기</button>
    </div>

    <!--// button bar  -->

</div>
</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>