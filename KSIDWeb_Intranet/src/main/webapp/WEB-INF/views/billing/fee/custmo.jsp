<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 고객사 월정액 요금 정보 json
var newJson1 = {};

// 고객사 월정액 요금 리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '요금청구월', name: 'udrMonth', format:"ym", width:80 });
    colModel.push({ label: '서비스제공자', name: 'spNm', width:80 });
    colModel.push({ label: '고객사', name: 'custNm', width:90 });
    colModel.push({ label: '서비스명', name: 'servNm', width:150 });
    colModel.push({ label: '상품명', name: 'prodMclsNm', width:80 });
    colModel.push({ label: '과금 시작일', name: 'stDtm',format: 'date' , width:80 });
    colModel.push({ label: '과금 종료일', name: 'edDtm',format: 'date' , width:80 });
    colModel.push({ label: '과금일수', name: 'calcDay', format: 'number',width:80 });
    colModel.push({ label: '사용요금', name: 'calcFee', format: 'money' , width:80 });
    colModel.push({ label: '일할계산여부', name: 'calcTypeNm', width:80 });
    colModel.push({ label: '청구여부', name: 'payFlagNm' , width:80 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;

    //고객사 고정 월정요금 데이터리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

}

function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#search-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

    var sM = new ksid.datetime().getDate("yyyy-mm");
    $("#search-panel input[name=sM]").val(sM);
    $("#search-panel input[name=eM]").val(sM);

}


/*****************************************************
* 함수명 : 고객사 월정액 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    if(ksid.form.validateForm("search-panel") == false) {
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/fee/custmo/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "고객사 월정액 요금 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 고객사 월정액 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var rownum =  $("#grid1").getGridParam("records");
    if (rownum == 0) {
        ksid.ui.alert("조회된 데이터가 없습니다!!!");
        return;
    }

    var url = "${pageContext.request.contextPath}/billing/fee/custmo/excel";
    var fileNm = "고객사월정액요금데이터";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcelGrid(url, fileNm, grid1);
}


</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">요금조회</span> > <span name="menu">고객사 월정액 요금</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt class="width80">조회기간</dt>
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
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <h3 class="style-title"><span name="title">고객사 월정액 요금 데이터 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
