<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>OCU 사용자 서비스 정보 조회 </title>
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
    document.form1.userID.value = "${param.custUserNo}".trim();
});


function doReg() {
    var params = ksid.form.flushPanel('edit-panel');
    document.form1.custUserNo.value = document.form1.userID.value;
    if( ksid.form.validateForm('edit-panel') ) {
        $("#form1").attr('action', '${pageContext.request.contextPath}/userreg');
        $("#form1").attr('target', 'userreg');

        var regWin = ksid.ui.openWindow('', 'userreg', 550, 530);
        $("#form1").submit();
        regWin.focus();
    }
}


function doPayRequest() {
    var params = ksid.form.flushPanel('edit-panel');
    initFlag = 1;
    params.custUserNo = document.form1.userID.value;
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/cnspay/request');
        $("#form1").attr('target', 'requestSch');

        var regWin = ksid.ui.openWindow('', 'requestSch', 616, 620);
        $("#form1").submit();
        regWin.focus();
    }
}


function doClose() {
    window.close();
}


function onKeyDown() {
     if(event.keyCode == 13) {
          doUserInfoSearch();
          return(false);
     }
}


function doUserInfoSearch() {
    var params = ksid.form.flushPanel('edit-panel');

    if( $("#edit-panel input[name=userID]").val().trim().length < 6) {
        ksid.ui.alert("학번을 입력해주세요.");
            return;
    }

    params.spCd = gSpCd;
    params.custId = gCustId;
    params.servId = gServId;
    params.custUserNo = document.form1.userID.value;
    params.svcType = "SVCINFO";
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userStatChk", params, function(result) {
        if(result.rstParam.retValue == "08" || result.rstParam.retValue == "00") {
            params.code = "200";
            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rcvdata) {
                document.form1.spNo.value    = result.rstParam.spNo;
                document.form1.kookBun.value = result.rstParam.kookBun;
                document.form1.junBun.value  = result.rstParam.junBun;
                $("#form1").attr('action', '${pageContext.request.contextPath}/ocuuser/userInfo');
                $("#form1").attr('target', 'userInfo');

                var regWin = ksid.ui.openWindow('', 'userInfo', 800, 700);

                $("#form1").submit();
                regWin.focus();
                doClose();
            });
        }
        /* else if(result.rstParam.retValue == "00") {
            ksid.ui.confirm("서비스 미결제 상태 입니다. 결제하시겠습니까?", function() {
                document.form1.spNo.value    = result.rstParam.spNo;
                document.form1.kookBun.value = result.rstParam.kookBun;
                document.form1.junBun.value  = result.rstParam.junBun;
                doPayRequest();
                doClose();
            });
        } */
        else if(result.rstParam.retValue == "01") {
            params.code = "201";
            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rcvdata) {
                ksid.ui.confirm("서비스 미가입 사용자 입니다. 가입을 하시겠습니까?", function() {
                    doReg();
                    doClose();
                });
            });
        }
   });
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
    <br />
    <br />
    <center>
        <font style="font-size:25px;"><strong>지문 인증 서비스 정보 조회</strong></font>
    </center>
    <br />
    <br />

    <form id="form1" name="form1" method="post" action="popup url" target="popup_window" >

        <div id="edit-panel" class="edit-panel" style="min-width:400px;height:65px;">
            <input type="hidden" name="spCd" value="P0003" />
            <input type="hidden" name="custId" value="C000018" />
            <input type="hidden" name="servId" value="S00000007"/>
            <input type="hidden" name="spNo" value=""/>
            <input type="hidden" name="kookBun" value=""/>
            <input type="hidden" name="junBun" value=""/>
            <input type="hidden" name="custUserNo" value=""/>
            <div class="styleDlTable">
            <br />
                <dl>
                    <dt class="title_on width80">학번</dt>
                    <dd>
                        <input type="text" command="onKeyDown()" maxlength="16" name="userID" title="학번" class="style-input width110" format="no" readonly />
                    </dd>
                </dl>
            </div>
        </div>

    </form>
    <br />
    <br />
    <div class="button-bar" style="height:20px;">
    </div>
    <div class="button-bar" style="text-align:center;">
        <button type="button" class="style-btn" auth="W" onclick="doUserInfoSearch()" style="width:100px; height:30px;">조회</button>
        <button type="button" class="style-btn" auth="W" onclick="doClose()" style="width:100px; height:30px;">닫기</button>
    </div>
</div>
</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>