<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 사용자 월정액 요금 데이터 json
var newJson1 = {};

// 사용자 월정액 요금리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '요금청구월', name: 'udrMonth', format:'ym', width:80 });
    colModel.push({ label: '서비스제공자', name: 'spNm', width:80 });
    colModel.push({ label: '고객사', name: 'custNm', width:90 });
    colModel.push({ label: '서비스명', name: 'servNm', width:100 });
    colModel.push({ label: '사용자명', name: 'userNm',format: 'string' , width:100 });
    colModel.push({ label: '휴대폰번호', name: 'telNo',format: 'tel_no' , width:100 });
    colModel.push({ label: '상품명', name: 'prodMclsNm', width:100 });
    colModel.push({ label: '과금대상유형', name: 'billTarTpNm', width:80 });
    colModel.push({ label: '과금시작일', name: 'stDtm', format: 'date' , width:80 });
    colModel.push({ label: '과금종료일', name: 'edDtm', format: 'date' , width:80 });
    colModel.push({ label: '과금일수', name: 'calcDay', format: 'number',width:60 });
    colModel.push({ label: '사용요금', name: 'calcFee', format: 'number' , width:60 });
    colModel.push({ label: '일할계산여부', name: 'calcTypeNm', width:80 });
    colModel.push({ label: '청구여부', name: 'payFlagNm', width:60 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;

    //사용자 월정액 요금 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var paging = {}
    paging.options = {};
    paging.options["var"] = {};
    paging.options["prop"] = {};
    paging.options["var"].elementId = "grid1_pager";
    paging.options["prop"].totrowcnt = 1;
    paging.options["prop"].pagecnt = 100;
    paging.options["prop"].pagenow = 1;
    paging.options["prop"].blockcnt = 15;
    paging.options.context = "${pageContext.request.contextPath}";

    grid1.pager = new ksid.paging(paging.options);
    grid1.pager.parent = grid1;                 // 페이저 소속 GRID 를 지정한다.
    grid1.pager.selectFunc = doQueryPaging;     // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    grid1.pager.show();

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

    $("#search-panel input[name=userNm]").focus();

}


/*****************************************************
* 함수명 : 사용자 월정액 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);
}


/*****************************************************
* 함수명 : 사용자 월정액 목록 페이징 조회
* 설명   :
*****************************************************/
function doQueryPaging(resultMsg) {

    if(ksid.form.validateForm("search-panel") == false) {
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/fee/usermo/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "사용자 월정액 요금 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 사용자별 월정액 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/billing/fee/usermo/excel";
    var fileNm = "사용자월정액요금데이터";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);
}


</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">요금조회</span> > <span name="menu">사용자 월정액 요금</span></p>
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
            </dl>
            <dl>
                <dt class="width80">서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
                <dt>사용자명</dt>
                <dd>
                    <input type="text" name="userNm" title="사용자명" class="style-input width110" command="doQuery()" />
                </dd>
                <dt>휴대폰번호</dt>
                <dd>
                    <input type="text" name="mpNo" title="휴대폰번호" class="style-input width110" command="doQuery()" />
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

    <h3 class="style-title"><span name="title">사용자 월정액 요금 데이터 목록</span></h3>
    <!-- grid -->
    <div id="grid1_pager" class="pager"></div>
    <table id="grid1"></table>
    <!--// grid -->
</div>
