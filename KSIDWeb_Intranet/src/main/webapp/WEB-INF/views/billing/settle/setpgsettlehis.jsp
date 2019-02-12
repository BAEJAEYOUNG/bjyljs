<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// PG정산대사 비교 내역 json
var newJson1 = {};

// PG정산대사 비교 내역 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];

    colModel.push({ label: '거래일자', name: 'payDtm', format:'ymdh', width:70 });
    colModel.push({ label: '거래TID', name: 'payTid', format:'string', width:200 });
    colModel.push({ label: '서비스사업자명', name: 'spNm', format:'string', width:90 });
    colModel.push({ label: '고객사명', name: 'custNm', format:'string', width:90 });
    colModel.push({ label: '서비스명', name: 'servNm', format:'string', width:90 });
    colModel.push({ label: '휴대폰', name: 'telNo', format:'tel_no', width:90 });
    colModel.push({ label: '사용자명', name: 'userNm', width:80 });
    colModel.push({ label: '수집시스템', name: 'sysId', width:70 });
    colModel.push({ label: '거래명령', name: 'ksidPayCmdNm', width:50 });
    colModel.push({ label: '결제수단', name: 'ksidPayMethodNm', width:50 });
    colModel.push({ label: '거래금액', name: 'ksidPayAmt', format: 'number', width:70 });
    colModel.push({ label: '거래명령', name: 'pgcPayCmdNm', width:50 });
    colModel.push({ label: '결제수단', name: 'pgcPayMethodNm', width:50 });
    colModel.push({ label: '거래금액', name: 'pgcPayAmt', format: 'number', width:70 });
    colModel.push({ label: '거래명령', name: 'cmdChkNm', width:50 });
    colModel.push({ label: '결제수단', name: 'methodChkNm', width:50 });
    colModel.push({ label: '결제금액', name: 'amtChkNm', width:50 });
    colModel.push({ label: '비교일시', name: 'regDtm', format:'dttm', width:120 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;

    //PG정산대사 비교 내역 데이터리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var group = {};
    group.useColSpanStyle = true;
    group.groupHeaders = [];
    group.groupHeaders.push({startColumnName: 'ksidPayCmdNm', numberOfColumns: 3, titleText: "KSID 결제내역"});
    group.groupHeaders.push({startColumnName: 'pgcPayCmdNm' , numberOfColumns: 3, titleText: "PG사 결제내역"});
    group.groupHeaders.push({startColumnName: 'cmdChkNm' , numberOfColumns: 3, titleText: "결제내역 비교"});
    $("#grid1").jqGrid("setGroupHeaders", group);

    //loadcomplete event add
    $("#grid1").jqGrid("setGridParam", {

        loadComplete: function(data) {
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
                // 데이터의 cmdChkNm 확인
                if (gridData[i].cmdChkNm == '불일치') {
                    //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                    $('#grid1').jqGrid('setCell', ids[i], 'cmdChkNm', '', cssOrange);
                } else {
                    $('#grid1').jqGrid('setCell', ids[i], 'cmdChkNm', '', cssGreen);
                }
                if (gridData[i].methodChkNm == '불일치') {
                    $('#grid1').jqGrid('setCell', ids[i], 'methodChkNm', '', cssOrange);
                } else {
                    $('#grid1').jqGrid('setCell', ids[i], 'methodChkNm', '', cssGreen);
                }
                if (gridData[i].amtChkNm == '불일치') {
                    $('#grid1').jqGrid('setCell', ids[i], 'amtChkNm', '', cssOrange);
                } else {
                    $('#grid1').jqGrid('setCell', ids[i], 'amtChkNm', '', cssGreen);
                }
            }
        }
    });

    var paging = {}
    paging.options = {};
    paging.options["var"] = {};
    paging.options["prop"] = {};
    paging.options["var"].elementId = "grid1_pager";
    paging.options["prop"].totrowcnt = 0;
    paging.options["prop"].pagecnt = 100;
    paging.options["prop"].pagenow = 1;
    paging.options["prop"].blockcnt = 15;
    paging.options.context = "${pageContext.request.contextPath}";

    grid1.pager = new ksid.paging(paging.options);
    grid1.pager.parent = grid1;                 // 페이저 소속 GRID 를 지정한다.
    grid1.pager.selectFunc = doQueryPaging;     // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    grid1.pager.show();

    var sDate = new ksid.datetime().before(0,1,0).getDate("yyyy-mm-dd");
    var eDate = new ksid.datetime().getDate("yyyy-mm-dd");

    $("#search-panel input[name=sDt]").val(sDate);
    $("#search-panel input[name=eDt]").val(eDate);

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
* 함수명 : PG정산대사 비교 내역 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);
}

/*****************************************************
* 함수명 : PG정산대사 비교 내역 목록 페이징 조회
* 설명   :
*****************************************************/
function doQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/settle/setpgsettlehis/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "PG정산대사 비교 내역 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : PG정산대사 비교 내역 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/billing/settle/setpgsettlehis/excel";
    var fileNm = "PG정산대사 비교 내역 데이터목록";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);
}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">정산관리</span> > <span name="menu">PG정산대사 비교 내역</span></p>
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
                <dt class="width80">서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" overall="전체" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
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

    <h3 class="style-title"><span name="title">PG정산대사 비교 내역 데이터 목록</span></h3>
    <!-- grid -->
    <div id="grid1_pager" class="pager"></div>
    <table id="grid1"></table>
    <!--// grid -->
</div>