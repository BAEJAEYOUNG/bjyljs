<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// PG 정산대사 정산내역 json
var newJson1 = {};

// PG 정산대사 정산내역  grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '거래일자'    , name: 'billDate'      , format: 'date', width:80 });
    colModel.push({ label: '결제요청 건수', name: 'ksidApprCnt'   , format: 'number', width:110 });
    colModel.push({ label: '결제취소 건수', name: 'ksidCancelCnt' , format: 'number', width:110 });
    colModel.push({ label: '결제요청 금액', name: 'ksidApprAmt'   , format: 'number', width:110 });
    colModel.push({ label: '결제취소 금액', name: 'ksidCancelAmt' , format: 'number', width:110 });

    colModel.push({ label: '결제요청 건수', name: 'pgcApprCnt'   , format: 'number', width:110 });
    colModel.push({ label: '결제취소 건수', name: 'pgcCancelCnt' , format: 'number', width:110 });
    colModel.push({ label: '결제요청 금액', name: 'pgcApprAmt'   , format: 'number', width:110 });
    colModel.push({ label: '결제취소 금액', name: 'pgcCancelAmt' , format: 'number', width:110 });

    colModel.push({ label: '결제요청 건수', name: 'apprCntChk'   , width:80 });
    colModel.push({ label: '결제요청 금액', name: 'apprAmtChk'   , width:80 });
    colModel.push({ label: '결제취소 건수', name: 'cancelCntChk' , width:80 });
    colModel.push({ label: '결제취소 금액', name: 'cancelAmtChk' , width:80 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.footerrow = true;
/*    gridProp.height = 150;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);
        doQuery2();
    }; */

    gridProp.loadComplete = function() {

        var option = {};
        option.col = ["ksidApprCnt" , "ksidCancelCnt" , "ksidApprAmt" , "ksidCancelAmt" , "pgcApprCnt", "pgcCancelCnt", "pgcApprAmt", "pgcCancelAmt"];
        option.label = { "billDate" : "합계" };
        grid1.setSum(option);

        // 배경색상 css 선언
        var cssGreen = {'background-color':'#6DFF6D'};
        var cssOrange   = {'background-color':'orange'};

        // 그리드 데이터의 ID 가져오기
        var ids = $('#grid1').jqGrid('getDataIDs');

        // 그리드 데이터 가져오기
        var gridData = $("#grid1").jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {
            //ksid.ui.alert("cmdChkNm :" + gridData[i].cmdChkNm);
            if (gridData[i].apprCntChk == '불일치') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'apprCntChk', '', cssOrange);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'apprCntChk', '', cssGreen);
            }
            if (gridData[i].apprAmtChk == '불일치') {
                $('#grid1').jqGrid('setCell', ids[i], 'apprAmtChk', '', cssOrange);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'apprAmtChk', '', cssGreen);
            }
            if (gridData[i].cancelCntChk == '불일치') {
                $('#grid1').jqGrid('setCell', ids[i], 'cancelCntChk', '', cssOrange);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'cancelCntChk', '', cssGreen);
            }
            if (gridData[i].cancelAmtChk == '불일치') {
                $('#grid1').jqGrid('setCell', ids[i], 'cancelAmtChk', '', cssOrange);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'cancelAmtChk', '', cssGreen);
            }
        }
    };

    //PG 거래대사 정산내역  그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var group = {};
    group.useColSpanStyle = true;
    group.groupHeaders = [];
    group.groupHeaders.push({startColumnName: 'ksidApprCnt', numberOfColumns: 4, titleText: "KSID 결제내역"});
    group.groupHeaders.push({startColumnName: 'pgcApprCnt' , numberOfColumns: 4, titleText: "PG사 결제내역"});
    group.groupHeaders.push({startColumnName: 'apprCntChk' , numberOfColumns: 4, titleText: "결제내역 비교"});
    $("#grid1").jqGrid('setGroupHeaders', group);

    var sDate = new ksid.datetime().before(0,1,0).getDate("yyyy-mm-dd");
    var eDate = new ksid.datetime().getDate("yyyy-mm-dd");

    $("#search-panel input[name=sDt]").val(sDate);
    $("#search-panel input[name=eDt]").val(eDate);

 }

/*****************************************************
* 함수명 : 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#search-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

}

/*****************************************************
* 함수명 : PG 정산대사 정산내역  조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/settle/setpgsettle/list"
                      , params
                      , function(result) {

        CommonJs.setStatus(  ksid.string.replace( "PG 정산대사 내역 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );

    });

}

/*****************************************************
* 함수명 : 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var rownum =  $("#grid1").getGridParam("records");
    if (rownum == 0) {
        ksid.ui.alert("조회된 데이터가 없습니다!!!");
        return;
    }

    var url = "${pageContext.request.contextPath}/billing/settle/setpgsettle/excel";
    var fileNm = "PG 정산대사 내역";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcelGrid(url, fileNm, grid1);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">정산관리</span> > <span name="menu">PG 정산대사 내역</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt class="width80">조회기간</dt>
                <dd>
                    <input type="text" name="sDt" title="조회시작일자" class="style-input width80" to="eDt" format="date" required/>
                    ~
                    <input type="text" name="eDt" title="조회종료일자" class="style-input width80" from="sDt" format="date" required/>
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="R" onclick="doExcel()">출력</button>
        </div>
        <!--// button bar  -->
    </div>

    <div class="style-title-wrap">
        <h3 class="style-title">PG 정산대사 내역 데이터 목록</h3>
    </div>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->

</div>
