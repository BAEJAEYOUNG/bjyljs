<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>사용자 가입정보 확인</title>
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

    dd.info { padding-top:11px; color:#777;}

    table.tbService {border-spacing:0px; border:1px solid #95B8E7;}
    table.tbService tr {height:25px;}
    table.tbService th {font-size:12px; color:#0E2D5F; text-align:left; width:120px; background:#E0ECFF; padding:3px; border:1px solid #95B8E7}
    table.tbService td {font-size:12px; color:#0E2D5F; text-align:left; width:200px;; background:#fff; padding:3px; border:1px solid #95B8E7}

    body {overflow-y:auto;}

</style>

<script type="text/javascript" charset="utf-8">
var initMaxTm = 10;
var bConfirmOk = false;     // 사용자 확인여부
var jsonUserInfo = null;    // 사용자 초기화 json
var jsonForm1 = null;       // form1 초기화 json
var initFlag = 0;
var mainTimer;

function doMainTimeInit() {
    initFlag = 1;
}


$(document).ready(function() {
    var colModel = [];
    colModel.push({ label:'서비스명',     name:'servNm',    format:'string', width:215 });
    colModel.push({ label:'서비스시작일시', name:'servStDtm', format:'dttm',   width:188 });
    colModel.push({ label:'서비스종료일시', name:'servEdDtm', format:'dttm',   width:188 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    $("#grid1").jqGrid('setGridHeight', 100);

    var colModel = [];

    colModel.push({ label:'서비스제공자코드', name:'spCd', hidden:true });
    colModel.push({ label:'고객사아이디', name:'custId', hidden:true });
    colModel.push({ label:'서비스아이디', name:'servId', hidden:true });
    colModel.push({ label:'취소비밀번호', name:'cancelPwd', hidden:true });
    colModel.push({ label:'부분취소금액', name:'cancelAmt', hidden:true });
    colModel.push({ label:'거래 ID', name:'payTid', hidden:true });
    colModel.push({ label:'가맹점 ID', name:'payMid', hidden:true });
    colModel.push({ label:'취소가능금액', name:'payCancelAmt', hidden:true });
    colModel.push({ label:'취소구분', name:'payCancelFg', hidden:true });

    colModel.push({ label:'결제일시', name:'udrDtm', format:'dttm', width:120 });
    colModel.push({ label:'서비스명', name:'servNm', format:'string', width:140 });
    colModel.push({ label:'결제금액', name:'rstAmt', format:'number', width:50 });
    colModel.push({ label:'결제수단', name:'payMethodNm', width:60 });
    colModel.push({ label:'승인/취소', name:'payCmdNm', width:60 });
    colModel.push({ label:'취소가능여부', name:'payCancelableYn', format:'string', width:170 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid2.setClickedProp(rowId);
        /* ksid.debug.printObj('grid2.clickedRowData', grid2.clickedRowData); */
    };
    grid2 = new ksid.grid("grid2", gridProp);
    grid2.loadGrid()

    jsonUserInfo = ksid.form.flushPanel('edit-panel');
    jsonForm1 = ksid.form.flushPanel('form1');
//     ksid.debug.printObj('jsonForm1', jsonForm1);

    init();

});

$(window).resize(function() {

    sizeFix();

    resize();

});

function resize() {
    var hGrid2 = $(window).height() - 530;
    $("#grid2").jqGrid('setGridHeight', hGrid2);
}

function init() {

    sizeFix();

    resize();

    doSearchUser();

    initFlag = 0;
    mainTimerModule();

}

function sizeFix() {

    window.resizeTo(700, 700);

}

function loadUserData(params) {

    ksid.form.bindPanel('divUserInfo', jsonUserInfo);
    ksid.form.bindPanel('divUserInfo', userInfo);

    // 서비스 가입정보 가져오기
    ksid.net.ajaxJqGrid(grid1, "${pageContext.request.contextPath}/sdu/userInfo/list", params);
    // 서비스 결제정보 가져오기
    ksid.net.ajaxJqGrid(grid2, "${pageContext.request.contextPath}/sdu/userInfo/listPay", params);

}

function doSearchUser() {

    if(ksid.form.validateForm("divInfo")) {

        var params = ksid.form.flushPanel("divInfo");
        params.spCd = "${resultData.spCd}";
        params.custId = "${resultData.custId}";
        params.mpNo = "${resultData.spNo}" + "${resultData.kookBun}" + "${resultData.junBun}";
        params.telNo = params.mpNo;
        params.custUserNo = "${resultData.userID}";
        ksid.net.ajax("${pageContext.request.contextPath}/sdu/userInfo/sel", params, function(result) {

            if(result.resultCd == '00') {

                if(result.resultData != null) {

                    userInfo = ksid.json.cloneObject(result.resultData);

//                     ksid.debug.printObj('userInfo', userInfo);

                    var params2 = {};
                    params2.spCd = params.spCd;
                    params2.custId = params.custId;
                    params2.userId = result.resultData.userId;

                    loadUserData(params2);

                } else {
                    ksid.ui.alert('고객님은 서비스에 가입되어 있지 않습니다')
                }
            }
        });

    }

}

function doPayCancel() {

    if(grid2.clickedRowData == null) {
        ksid.ui.alert('서비스 결제 이력에서 승인취소할 서비스를 선택하세요');
        return;
    }

    if( grid2.clickedRowData.payCancelFg == 'N' ) {
        ksid.ui.alert('해당 결제내역은 취소가능한 상태가 아닙니다.');
        return;
    }

    ksid.ui.confirm('선택하신 결제내역( ' + grid2.clickedRowData.servNm + '-'  + grid2.clickedRowData.payCancelableYn + ' ) 을 승인취소 하시겠습니까?', function() {

        var params = ksid.form.flushPanel("divUserInfo");

        params.spCd = "${resultData.spCd}";
        params.custId = "${resultData.custId}";
        params.telNo = "${resultData.spNo}" + "${resultData.kookBun}" + "${resultData.junBun}";
        params.goodsName = grid2.clickedRowData.servNm;

        ksid.form.bindPanel('form1', jsonForm1);               // form1 초기화
        ksid.form.bindPanel('form1', params);                  // 기분정보 바인딩
        ksid.form.bindPanel('form1', grid2.clickedRowData);    // 선택 data 바인딩

        if( ksid.form.validateForm('form1') ) {

            $("#form1").attr('action', '${pageContext.request.contextPath}/cnspaycancel/request');
            $("#form1").attr('target', 'winPayCancel');

            var payCancelWin = ksid.ui.openWindow('', 'winPayCancel', 620, 680);

            $("#form1").submit();

            payCancelWin.focus();

        }

    })

}


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

        if( initFlag == 0 && second == 0 && minute == 0 ){
            clearInterval(mainTimer); /* 타이머 종료 */
            var minute2 = initMaxTm;
            var second2 = 0;
            var tmp = minute2 + "분 " + second2 + "초";
            $("#mainTmId").val(tmp);
            /* smsSendFlag = 0; */

            $.blockUI({message:null,overlayCSS:{ opacity:0.7}});

            ksid.ui.alert("사용 유효시간 초과하였습니다.", function() {
                doClose();
            });

            /* setTimeout(function(){
                ksid.ui.alert("사용 유효시간 초과하였습니다.", function() {
                    doClose();
                });
            }, 100); */

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


$(function() {
    $("#initBtn").click(function(){
        initFlag = 1;
    });
});

function doClose() {
    window.close();
}


</script>
</head>
<body oncontextmenu="return false" ondragstart="return false" onselectstart="return false"  style="overflow-x:hidden; overflow-y:hidden;">

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
                <td style="text-align:right">
                <font style="font-size:12px"><strong>사용 유효 시간 :</strong></font>
                <input id="mainTmId" type="text" maxlength="6" name="mainTimerText" title="메인타이머" value = "10분 0초" class="style-input width45" format="no" style="border: 0px;background-color: #e2e2e2;color:black" disabled />
                <button id="initBtn" type="button" class="style-btn" auth="W" onclick="doMainTimeInit" style="width:30px; height:14px;">연장</button>
                </td>
            </tr>
        </table>
    </div>
    <%-- <left>
        <img src="${pageContext.request.contextPath}/static/image/siteci/ocuci_all.png" style="width:250px;margin-bottom:10px;" />
        &nbsp;&nbsp;
        <!--  <font style="font-size:35px; font-family:'바탕체'"><strong>TEE 사용자 가입</strong></font> -->
    </left> --%>
    <center>
        <font style="font-size:25px;"><strong>지문 인증 서비스 정보 조회</strong></font>
    </center>

    <br />

    <div id="divForm">

    <div id="divInfo" class="layout-content">

        <h3 class="style-title"><span name="title">가입 사용자 정보</span></h3>

        <div id="divUserInfo">
            <input type="hidden" name="userId" title="사용자아이디" />
            <table class="tbService">
                <tr>
                    <th>학번</th>
                    <td><span name="custUserNo" format="string"></span></td>
                    <th>휴대폰번호</th>
                    <td><span name="mpNo" format="tel_no"></span></td>
                </tr>
                <tr>
                    <th>가입일시</th>
                    <td colspan="3"><span name="joinDtm" format="dttm"></span></td>
                </tr>
            </table>
            <div id="serviceInfo"></div>
        </div>

        <h3 class="style-title"><span name="title">가입 서비스 정보</span></h3>

        <table id="grid1"></table>

        <h3 class="style-title"><span name="title">서비스 결제 이력</span></h3>

        <table id="grid2"></table>

        <br />

        <!--  button bar  -->
        <div class="button-bar" style="text-align:center;">
            <button type="button" class="style-btn" auth="W" onclick="self.close();" style="width:120px; height:30px;">확인완료(닫기)</button>
            <button type="button" class="style-btn" auth="W" onclick="doPayCancel()" style="width:120px; height:30px;">승인취소</button>
        </div>
        <!--// button bar  -->

    </div>

</div>

<form id="form1" name="form1" method="post" action="popup url" target="popup_window">
<input type="hidden" name="custUserNo" value="${resultData.userID}" />
<input type="hidden" name="payTid" title="거래 ID" required />
<input type="hidden" name="payMid" title="가맹점 ID" required />

<input type="hidden" name="spCd" title="서비스제공자코드" required />
<input type="hidden" name="custId" title="고객사아이디" required />
<input type="hidden" name="servId" title="서비스아이디" required />
<input type="hidden" name="userId" title="사용자아이디" required />
<input type="hidden" name="telNo" title="휴대폰번호" required />

<input type="hidden" name="payCancelFg" title="취소구분" required />
<input type="hidden" name="cancelPwd" title="취소비밀번호" required />

<input type="hidden" name="spNo" title="사업자번호" value="${resultData.spNo}" required />
<input type="hidden" name="kookBun" title="국번" value="${resultData.kookBun}" required />
<input type="hidden" name="junBun" title="전번" value="${resultData.junBun}" required />

<input type="hidden" name="goodsName" title="상품명" value="${resultData.servNm}" />
<input type="hidden" name="payCancelAmt" title="취소금액" value="" required />

</form>

</body>
</html>

<jsp:include page="${config.includePath}/footer.jsp"/>
