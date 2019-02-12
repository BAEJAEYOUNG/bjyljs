<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>OCU 사용자 서비스 결제 </title>
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

    document.form1.custUserNo.value = "${param.custUserNo}".trim();
});


function doPayRequest() {
    var params = ksid.form.flushPanel('edit-panel');
    initFlag = 1;
    params.custUserNo = document.form1.custUserNo.value.trim();
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/cnspay/request');
        $("#form1").attr('target', 'requestPay');

        var regWin = ksid.ui.openWindow('', 'requestPay', 616, 620);
        $("#form1").submit();
        regWin.focus();
    }
}


function doReg() {
    var params = ksid.form.flushPanel('edit-panel');
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/userreg');
        $("#form1").attr('target', 'regPay');

        var regWin = ksid.ui.openWindow('', 'regPay', 550, 530);
        $("#form1").submit();
        regWin.focus();
    }
}


function doPushRegView() {
    var params = ksid.form.flushPanel('edit-panel');
    if( ksid.form.validateForm('edit-panel') ) {

        $("#form1").attr('action', '${pageContext.request.contextPath}/fidoservice/webpushreg');
        $("#form1").attr('target', 'regPay');

        var regWin = ksid.ui.openWindow('', 'regPay', 550, 360);
        $("#form1").submit();
        regWin.focus();
    }
}


function doPayReq() {
    var params = ksid.form.flushPanel('edit-panel');
    /*  $("#edit-panel input[name=authNo]").val(''); */

    if( $("#edit-panel input[name=custUserNo]").val().length < 6) {
        ksid.ui.alert("학번을 입력해주세요.");
            return;
    }

    params.spCd = gSpCd;
    params.custId = gCustId;
    params.servId = gServId;
    params.custUserNo = document.form1.custUserNo.value;
    params.svcType = "SVCPAY";
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/userStatChk", params, function(result) {
        if(result.rstParam.retValue == "08") {
            ksid.ui.confirm("이미 지문 인증 서비스 결제를 완료하였습니다.서비스를 이용하려면 'PC와연결'을 1회 실행하여야 합니다. 'PC와연결'을 진행하시겠습니까?", function() {
/*                 document.form1.spNo.value    = result.rstParam.spNo;
                document.form1.kookBun.value = result.rstParam.kookBun;
                document.form1.junBun.value  = result.rstParam.junBun; */
                doPushRegView();
                doClose();
            });
        }
        else if(result.rstParam.retValue == "00") {
            ksid.ui.confirm("지문 인증 서비스 결제하시겠습니까?", function() {
                document.form1.spNo.value    = result.rstParam.spNo;
                document.form1.kookBun.value = result.rstParam.kookBun;
                document.form1.junBun.value  = result.rstParam.junBun;
                doPayRequest();
                doClose();
            });
        }
        else if(result.rstParam.retValue == "11") {
            ksid.ui.confirm("지문 인증 서비스 만료일이 ["+ result.rstParam.svcEdDate +"] 입니다. 서비스 기간 연장 결제하시겠습니까?", function() {
                document.form1.spNo.value    = result.rstParam.spNo;
                document.form1.kookBun.value = result.rstParam.kookBun;
                document.form1.junBun.value  = result.rstParam.junBun;
                doPayRequest();
                doClose();
            });
        }
        else if(result.rstParam.retValue == "10") {
            ksid.ui.confirm("지문 인증 서비스 이용 기간["+ result.rstParam.svcEdDate +"]이 만료 되었습니다.서비스 기간 연장 결제하시겠습니까?", function() {
                document.form1.spNo.value    = result.rstParam.spNo;
                document.form1.kookBun.value = result.rstParam.kookBun;
                document.form1.junBun.value  = result.rstParam.junBun;
                doPayRequest();
                doClose();
            });
        }
        else if(result.rstParam.retValue == "01") {
            params.code = 201;
            ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rstdata) {
                ksid.ui.confirm("지문 인증 서비스 미가입 상태 입니다. 지문 인증 서비스 가입을 하시겠습니까?", function() {
                    doReg();
                    doClose();
                });
            });
        }
   });
}


function doClose() {
    window.close();
}


function onKeyDown() {
     if(event.keyCode == 13) {
          doPayReq();
          return(false);
     }
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


function closePage( event ){
    if( event.clientY < 0 ){
    }

 }

/* window.onbeforeunload = function () {
    alert("bbbbbb");
}; */

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
    <center>
        <font style="font-size:25px;"><strong>지문 인증 서비스 결제</strong></font>
    </center>
    <br />
    <br />

    <form id="form1" name="form1" method="post" action="popup url" target="popup_window">

        <div id="edit-panel" class="edit-panel" style="min-width:400px;height:65px;">

            <input type="hidden" name="spCd" value="P0003" /> <!-- 서비스제공자-KSID -->
            <input type="hidden" name="custId" value="C000018" /> <!-- 고객사-열린사이버대학 -->
            <input type="hidden" name="servId" value="S00000007"/>
            <input type="hidden" name="spNo" value=""/>
            <input type="hidden" name="kookBun" value=""/>
            <input type="hidden" name="junBun" value=""/>
            <!-- <input type="hidden" name="goodsName" value="지문 인증 서비스" />
            <input type="hidden" name="amt" value="1000" /> -->

            <div class="styleDlTable">
            <br />
                <dl>
                    <dt class="title_on width80">학번</dt>
                    <dd>
                        <input type="text" command="onKeyDown()" maxlength="16" name="custUserNo" title="학번" class="style-input width130" format="no" readonly/>
                    </dd>
                </dl>
            </div>
        </div>

    </form>
    <br />
    <br />
    <div class="button-bar" style="height:20px;">
    </div>
    <!--  button bar  -->
    <div class="button-bar" style="text-align:center;">
        <button type="button" class="style-btn" auth="W" onclick="doPayReq()" style="width:100px; height:30px;">결제</button>
        <button type="button" class="style-btn" auth="W" onclick="doClose()" style="width:100px; height:30px;">닫기</button>
    </div>

    <!--// button bar  -->

</div>
</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>