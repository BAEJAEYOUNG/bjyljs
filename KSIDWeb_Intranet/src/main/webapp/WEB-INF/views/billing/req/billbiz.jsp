<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 법인정보 json
var newJson1 = {};

// 법인리스트 grid
var grid1 = null;
var grid2 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '요금청구월', name: 'billMonth', format:"ym", width:80 });
    colModel.push({ label: '서비스제공자명', name: 'spNm', format:"string", width:100 });
    colModel.push({ label: '고객사명', name: 'custNm', format:"string", width:80 });
    colModel.push({ label: '서비스명', name: 'servNm', format:"string", width:80 });
    colModel.push({ label: '법인명', name: 'userNm', format:"string", width:80 });
    colModel.push({ label: '사업자번호', name: 'bizNo', width:80 });

    colModel.push({ label: '사용자수', name: 'totUserCnt', format:'number', width:60 });
    colModel.push({ label: '사용건수', name: 'totUdrCnt', format:'number' ,width:60 });
    colModel.push({ label: '사용요금', name: 'totUdrFee', format:'number' ,width:70 });
    colModel.push({ label: '기본할인요금', name: 'totDcFee', format:'number' ,width:80 });
    colModel.push({ label: '청구대상요금', name: 'totRealFee', format:'number' ,width:80 });

    colModel.push({ label: '할인명#1', name: 'bsDcCdNm1', format: 'string' , width:60 });
    colModel.push({ label: '할인금액#1', name: 'bsDcFee1', format:'number' ,width:70 });
    colModel.push({ label: '할인명#2', name: 'bsDcCdNm2', format: 'string' , width:60 });
    colModel.push({ label: '할인금액#2', name: 'bsDcFee2', format:'number' ,width:70 });
    colModel.push({ label: '할인명#3', name: 'bsDcCdNm3', format: 'string' , width:60 });
    colModel.push({ label: '할인금액#3', name: 'bsDcFee3', format:'number' ,width:70 });
    colModel.push({ label: '할인명#4', name: 'bsDcCdNm4', format: 'string' , width:60 });
    colModel.push({ label: '할인금액#4', name: 'bsDcFee4', format:'number' ,width:70 });

    colModel.push({ label: '청구요금', name: 'billFee', format:'money' ,width:60 });
    colModel.push({ label: '부가세', name: 'vatFee', format:'money' ,width:60 });

    colModel.push({ label: '인출여부', name: 'wdFlagNm', width:70 });
    colModel.push({ label: '수납여부', name: 'rcFlagNm', width:70 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.footerrow = true;
    gridProp.height = 150;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);
        doQuery2();
    };
    gridProp.loadComplete = function() {

        var option = {};
        option.col = ["totUserCnt" , "totUdrCnt" , "totUdrFee" , "totDcFee" , "totRealFee", "billFee", "vatFee"];
        option.label = { "servNm" : "합계" };
        grid1.setSum(option);

    };

    //법인리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var group = {};
    group.useColSpanStyle = true;
    group.groupHeaders = [];
    group.groupHeaders.push({startColumnName: 'totUserCnt', numberOfColumns: 5, titleText: "전체"});
    group.groupHeaders.push({startColumnName: 'bsDcCdNm1', numberOfColumns: 8, titleText: "프로모션 할인"});
    $("#grid1").jqGrid('setGroupHeaders', group);

    var colModel = [];
    colModel.push({ label: '요금청구월', name: 'billMonth', format:"ym", width:100 });
    colModel.push({ label: '서비스제공자명', name: 'spNm', width:100 });
    colModel.push({ label: '고객사명', name: 'custNm', width:60 });
    colModel.push({ label: '서비스명', name: 'servNm', width:80 });
    colModel.push({ label: '요금종류', name: 'prodTpNm',width:70 });
    colModel.push({ label: '사용자수', name: 'totUserCnt', format:'number' ,width:80 });
    colModel.push({ label: '사용건수', name: 'totUdrCnt', format:'number' ,width:80 });
    colModel.push({ label: '사용요금', name: 'totUdrFee', format:'number' ,width:80 });
    colModel.push({ label: '할인요금', name: 'totDcFee', format:'number' ,width:80 });
    colModel.push({ label: '청구대상요금', name: 'totRealFee', format:'number' ,width:100 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    //법인리스트 그리드 생성
    grid2 = new ksid.grid("grid2", gridProp);
    grid2.loadGrid();

    var group2 = {};
    group2.useColSpanStyle = true;
    group2.groupHeaders = [];
    group2.groupHeaders.push({startColumnName: 'totUserCnt', numberOfColumns: 5, titleText: "전체"});
    $("#grid2").jqGrid('setGroupHeaders', group2);

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

    var sM = new ksid.datetime().before(0,1,0).getDate("yyyy-mm");
    var eM = new ksid.datetime().getDate("yyyy-mm");
    $("#search-panel input[name=sM]").val(sM);
    $("#search-panel input[name=eM]").val(eM);

    $("#search-panel input[name=userNm]").focus();

}

/*****************************************************
* 함수명 : 종량요금 법인 청구서 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/req/billbiz/list"
                      , params
                      , function(result) {

        grid2.initGridData();
        CommonJs.setStatus(  ksid.string.replace( "종량요금 법인 청구서 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );

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

    var url = "${pageContext.request.contextPath}/billing/req/billbiz/excel2";
    var fileNm = "종량요금법인청구서";

    ksid.net.ajaxExcelGrid(url, fileNm, grid1);
}

function doExcel2() {

    var rownum =  $("#grid1").getGridParam("records");
    if (rownum == 0) {
        ksid.ui.alert("조회된 데이터가 없습니다!!!");
        return;
    }

    var url = "${pageContext.request.contextPath}/billing/req/billbiz/excel2";
    var fileNm = "종량요금법인상세청구서";

    ksid.net.ajaxExcelGrid(url, fileNm, grid2);
}


/*****************************************************
* 함수명 : 종량요금 법인 상세 청구서 목록 조회
* 설명   :
*****************************************************/
function doQuery2(resultMsg) {

    var params = {};
    params.billMonth = grid1.clickedRowData.billMonth;
    params.spCd = grid1.clickedRowData.spCd;
    params.custId = grid1.clickedRowData.custId;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid2
                      , "${pageContext.request.contextPath}/billing/req/billbiz/listDtl"
                      , params
                      , function(result) {

        CommonJs.setStatus(  ksid.string.replace( "종량요금 법인 상세 청구서 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );

    });

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">청구관리</span> > <span name="menu">종량요금 법인 청구서</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt class="width80">요금청구월</dt>
                <dd>
                    <input name="sM" type="text" format="ym" class="style-input width60" title="시작월" required />
                     ~
                    <input name="eM" type="text" format="ym" class="style-input width60" title="종료월" required />
                </dd>
                <dt class="width80">서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
            </dl>
            <dl>
                <dt class="width80">법인명</dt>
                <dd>
                    <input type="text" name="userNm" title="법인명" class="style-input width110" command="doQuery()" />
                </dd>
                <dt class="width80">사업자번호</dt>
                <dd>
                    <input type="text" name="bizNo" title="사업자번호" class="style-input width110" command="doQuery()" />
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
        </div>
        <!--// button bar  -->
    </div>

<!--     <h3 class="style-title"><span name="title">종량요금 법인 청구서</span></h3> -->
    <div class="style-title-wrap">
        <h3 class="style-title">종량요금 법인 청구서</h3>
        <div class="button-bar">
            <button type="button" onclick="doExcel()" class="style-btn">출력</button>
        </div>
    </div>
    <!-- grid -->
    <table id="grid1" resize="false"></table>
    <!--// grid -->
    <div class="style-title-wrap">
        <h3 class="style-title">종량요금 법인 상세 청구서</h3>
        <div class="button-bar">
            <button type="button" onclick="doExcel2()" class="style-btn">출력</button>
        </div>
    </div>
    <!-- grid -->
    <table id="grid2"></table>
    <!--// grid -->

</div>
