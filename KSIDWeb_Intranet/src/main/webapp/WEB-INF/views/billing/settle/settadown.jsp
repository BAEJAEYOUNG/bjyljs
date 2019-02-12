<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 고객사정보 json
var newJson1 = {};

// 고객사리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];

    colModel.push({ label: '수집일자', name: 'billDate', format: 'date', width:80 });
    colModel.push({ label: '신규설치 사용자수', name: 'ksidTaInsUserCnt', format: 'number', width:100 });
    colModel.push({ label: '신규설치 건수', name: 'ksidTaInsUdrCnt', format: 'number', width:100 });
    colModel.push({ label: '업데이트 사용자수', name: 'ksidTaUpdUserCnt', format: 'number', width:100 });
    colModel.push({ label: '업데이트 건수', name: 'ksidTaUpdUdrCnt', format: 'number', width:100 });
    colModel.push({ label: '신규설치 사용자수', name: 'tamTaInsUserCnt', format: 'number', width:100 });
    colModel.push({ label: '신규설치 건수', name: 'tamTaInsUdrCnt', format: 'number', width:110 });
    colModel.push({ label: '업데이트 사용자수', name: 'tamTaUpdUserCnt', format: 'number', width:100 });
    colModel.push({ label: '업데이트 건수', name: 'tamTaUpdUdrCnt', format: 'number', width:100 });
    colModel.push({ label: '신규설치 사용자수', name: 'insUserCntChkNm', width:100 });
    colModel.push({ label: '신규설치 건수', name: 'insUdrCntChkNm', width:100 });
    colModel.push({ label: '업데이트 사용자수', name: 'updUserCntChkNm', width:100 });
    colModel.push({ label: '업데이트 건수', name: 'updUdrCntChkNm', width:100 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.footerrow = true;
    gridProp.loadComplete = function() {

        var option = {};
        option.col = [
                        "ksidTaInsUserCnt" ,    "ksidTaInsUdrCnt" ,     "ksidTaUpdUserCnt" ,    "ksidTaUpdUdrCnt",
                        "tamTaInsUserCnt",      "tamTaInsUdrCnt" ,      "tamTaUpdUserCnt",      "tamTaUpdUdrCnt"
                     ];
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
            if (gridData[i].insUserCntChkNm == '불일치') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'insUserCntChkNm', '', cssOrange);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'insUserCntChkNm', '', cssGreen);
            }
            if (gridData[i].insUdrCntChkNm == '불일치') {
                $('#grid1').jqGrid('setCell', ids[i], 'insUdrCntChkNm', '', cssOrange);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'insUdrCntChkNm', '', cssGreen);
            }
            if (gridData[i].updUserCntChkNm == '불일치') {
                $('#grid1').jqGrid('setCell', ids[i], 'updUserCntChkNm', '', cssOrange);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'updUserCntChkNm', '', cssGreen);
            }
            if (gridData[i].updUdrCntChkNm == '불일치') {
                $('#grid1').jqGrid('setCell', ids[i], 'updUdrCntChkNm', '', cssOrange);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'updUdrCntChkNm', '', cssGreen);
            }
        }
    };

    //TA Download 정산내역 데이터리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var group = {};
    group.useColSpanStyle = true;
    group.groupHeaders = [];
    group.groupHeaders.push({startColumnName: 'ksidTaInsUserCnt', numberOfColumns: 4, titleText: "KSID TA Download"});
    group.groupHeaders.push({startColumnName: 'tamTaInsUserCnt' , numberOfColumns: 4, titleText: "TAM TA Download"});
    group.groupHeaders.push({startColumnName: 'insUserCntChkNm' , numberOfColumns: 4, titleText: "TA Download 비교"});
    $("#grid1").jqGrid('setGroupHeaders', group);

    var sDate = new ksid.datetime().before(0,1,0).getDate("yyyy-mm-dd");
    var eDate = new ksid.datetime().getDate("yyyy-mm-dd");

    $("#search-panel input[name=sDt]").val(sDate);
    $("#search-panel input[name=eDt]").val(eDate);

    $("#grid1").jqGrid('setGridHeight', $(window).height() - 310);
}

function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#search-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

}

/*****************************************************
* 함수명 : TA  정산내역 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/settle/settadown/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "TA 정산내역 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : TA Download 정산내역 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var rownum =  $("#grid1").getGridParam("records");
    if (rownum == 0) {
        ksid.ui.alert("조회된 데이터가 없습니다!!!");
        return;
    }

    var url = "${pageContext.request.contextPath}/billing/settle/settadown/excel";
    var fileNm = "TA정산내역";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcelGrid(url, fileNm, grid1);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">정산관리</span> > <span name="menu">TA Download 정산내역 데이터관리</span></p>
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

<!--                     <select name="sM" title="시작월" class="style-select" codeGroupCd="yyyy_mm"></select>      -->
<!--                    ~                                                                                         -->
<!--                    <select name="eM" title="종료월" class="style-select" codeGroupCd="yyyy_mm"></select>       -->
                </dd>
<!--
                <dt class="width80">서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
 -->
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <h3 class="style-title"><span name="title">TA 정산내역 데이터 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
