<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>사용자 결제 완료</title>
<jsp:include page="${config.includePath}/css.jsp"/>
<jsp:include page="${config.includePath}/js.jsp"/>

<script type="text/javascript" src="${config.jsPath}/fidoservice/sdu/servInfo.js"></script>

<style type="text/css">

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
    table.tbService td {font-size:12px; color:#0E2D5F; text-align:left; width:180px;; background:#fff; padding:3px; border:1px solid #95B8E7}

    table.tbService2 {border-spacing:0px; border:1px solid #95B8E7;}
    table.tbService2 tr {height:25px;}
    table.tbService2 th {font-size:12px; color:#0E2D5F; text-align:left; width:120px; background:#E0ECFF; padding:3px; border:1px solid #95B8E7}
    table.tbService2 td {font-size:12px; color:#0E2D5F; text-align:left; width:180px;; background:#fff; padding:3px; border:1px solid #95B8E7}

    body {overflow-y:auto;}
</style>

<script type="text/javascript" charset="utf-8">

var bConfirmOk = false;     // 사용자 확인여부
var jsonUserInfo = null;    // 사용자 초기화 json
var jsonForm1 = null;       // form1 초기화 json

$(document).ready(function() {
    var colModel = [];
    /* colModel.push({ label:'서비스명', name:'servNm', index:'servNm', format:'string', width:215 });
    colModel.push({ label:'서비스시작일시', name:'servStDtm', index:'servStDtm', format:'dttm', width:190 });
    colModel.push({ label:'서비스종료일시', name:'servEdDtm', index:'servEdDtm', format:'dttm', width:190 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.rownumbers = 0; */
    /* grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid(); */

    $("#grid1").jqGrid({
        datatype: "local",
        height: 250,
        colNames:['서비스명', '서비스시작일시', '서비스종료일시'],
        colModel:[
                  {name:'servNm', index:'servNm', format:'string', width:214},
                  {name:'servStDtm', index:'servStDtm', format:'dttm', width:200},
                  {name:'servEdDtm', index:'servEdDtm', format:'dttm', width:200}
                  ]
    });

    var gridData = [
                    {servNm:"${resultData.servNm}", servStDtm:"${resultData.servStDtm}", servEdDtm:"${resultData.servEdDtm}"}
                    ];
    $("#grid1").jqGrid('addRowData', 1, gridData[0]);

    $("#grid1").jqGrid('setGridHeight', 100);

    jsonUserInfo = ksid.form.flushPanel('edit-panel');
    jsonForm1 = ksid.form.flushPanel('form1');

//     ksid.debug.printObj('jsonForm1', jsonForm1);
    var params = {};
    params.spCd       = gSpCd;
    params.custId     = gCustId;
    params.servId     = gServId;
    params.svcType    = "SVCPAY";
    params.custUserNo = "${resultData.custUserNo}";
    params.code = "200";
    ksid.net.ajax("${pageContext.request.contextPath}/devauth/mobileauth/servicehist", params, function(rcvdata) {
    });
    init();
});


$(window).resize(function() {
    sizeFix();
    resize();
});


function resize() {
    var hGrid2 = $(window).height() - 500;
    $("#grid2").jqGrid('setGridHeight', hGrid2);
}


function init() {
    sizeFix();
    resize();
}


function sizeFix() {
    window.resizeTo(655, 650);
}


function doPushRegView() {

    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;
    document.form1.custUserNo.value = "${resultData.custUserNo}";

    window.open("about:blank", "webfidoreg", "width=550,height=360");
    document.form1.action = "${pageContext.request.contextPath}/sdu/fidoservice/webpushreg";
    document.form1.target = "webfidoreg";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


function doCloseNext() {
    ksid.ui.confirm("지문 인증 서비스를 이용하려면 1회 PC와 연결 을 실행해야 합니다. PC와 연결을 하시겠습니까?", function() {
        doPushRegView();
        doClose();
     }, function(){
        doClose();
    });
}


function doClose() {
    window.close();
}



</script>

</head>
<body style="overflow-x:hidden; overflow-y:hidden;">

<div class="contents-wrap">

    <br />

    <left>
        <img src="${pageContext.request.contextPath}/static/image/siteci/SDU_signature02.png" style="width:220px;margin-bottom:10px;" />
        &nbsp;&nbsp;
        <!--  <font style="font-size:35px; font-family:'바탕체'"><strong>TEE 사용자 가입</strong></font> -->
    </left>
    <br />
    <br />
    <div>
        <h3 class="style-title"><span name="title">결제 완료 [${resultData.payRstDtm}]</span></h3>
        <br />
        <center>
            <img src="${pageContext.request.contextPath}/static/image/ksid/Checkmark_m.png" style="width:60px;margin-bottom:10px;" />
            <font style="font-size:18px;"><strong>지문 인증 서비스 사용 결제가 완료 되었습니다.</strong></font>
        </center>
        <br/>
        <center>
            <font style="font-size:13px;color:blue;"><strong>※ 스마트폰의 '결제완료문자' 하단에 한국전자인증FIDO앱 다운로드 URL 실행 설치 완료 후, <br>[PC와 연결]을 1회 실행하십시오.</strong></font>
        </center>
    </div>

    <form id="form1" name="form1" method="post" action="popup url" target="popup_window">
    <input type="hidden" name="spCd" value=""/>
    <input type="hidden" name="custId" value=""/>
    <input type="hidden" name="servId" value=""/>
    <input type="hidden" name="custUserNo" value=""/>
    <div id="divForm">
    <div id="divInfo" class="layout-content">
        <br />
        <h3 class="style-title"><span name="title">결제 정보</span></h3>

        <div id="divUserInfo">
            <table class="tbService">
                <tr>
                    <th>최종결제금액</th>
                    <td><span name='finalPayMoney' style="width:80px"></span>${resultData.payAmt}원 </td>
                    <th>결제수단</th>
                    <td><span name="payMthod" format="date"></span>${resultData.payMthod}</td>
                </tr>

                <tr>
                    <th>학번</th>
                    <td><span name="custUserNo">${resultData.custUserNo}</span></td>
                    <th>휴대폰번호</th>
                    <td><span name="telNo">${resultData.telNo}</span></td>
                </tr>
            </table>
            <div id="serviceInfo"></div>
        </div>
        <br />
        <br />
        <h3 class="style-title"><span name="title">결제 서비스 정보</span></h3>

        <!-- <table id="grid1"></table> -->
         <div id="divUserInfo2">
            <table class="tbService2">
                <tr>
                    <th>서비스명</th>
                    <td colspan="3"s><span name='servNm' style="width:80px"></span>${resultData.servNm} </td>
                </tr>

                <tr>
                    <th>시작일</th>
                    <td><span name="servStDtm" format="dttm">${resultData.servStDtm}</span></td>
                    <th>만료일</th>
                    <td><span name="servEdDtm" format="dttm">${resultData.servEdDtm}</span></td>
                </tr>
            </table>
            <div id="serviceInfo"></div>
        </div>

        <br />
        <br />
        <br />
        <!--  button bar  -->
        <div class="button-bar" style="text-align:center;">
            <button type="button" class="style-btn" auth="W" onclick="doCloseNext()" style="width:120px; height:30px;">확인완료(닫기)</button>
        </div>
        <!--// button bar  -->
    </div>
</div>
</form>




</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>
