<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 카드관리 데이터정보 json
var newJson1 = {};

// 카드관리 데이터리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label:'카드상태', name:'cardsSt', hidden:true });
    colModel.push({ label:'카드유형', name:'cardsIssueTp', hidden:true });
    colModel.push({ label:'고객사코드', name:'cardsCustCd', hidden:true });

    colModel.push({ label:'시리얼번호', name:'serialNo', format:'string', width:180 });
    colModel.push({ label:'카드상태', name:'cardsStNm', width:120 });
    colModel.push({ label:'고객사', name:'cardsCustCdNm', format:'string', width:150 });
    colModel.push({ label:'발급년도', name:'cardsIssueYear', width:70 });
    colModel.push({ label:'카드유형', name:'cardsIssueTpNm', width:120 });
    colModel.push({ label:'시리얼발급일시', name:'serialDtm', format:'dttm', width:140 });
    colModel.push({ label:'발급완료일시', name:'regDtm', format:'dttm', width:140 });

//     colModel.push({ label: '과금대상레벨', name: 'prodLvl', width:60 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;

    //카드관리 데이터리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

 // Pager 설정
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

}

/*****************************************************
* 함수명 : 모든 search-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel input[name=serialNo]").focus();

}

/*****************************************************
* 함수명: 카드관리 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    console.log('grid1.pager.prop', grid1.pager.prop);

    doQueryPaging(resultMsg);

}

/*****************************************************
* 함수명 : 고객사 목록 조회
* 설명   :
*****************************************************/
function doQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/product/cards/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "카드시리얼관리 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}


</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu"></span> > <span name="menu"></span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt>카드시리얼번호</dt>
                <dd>
                    <input type="text" name="serialNo" title="카드시리얼번호" class="style-input width110" command="doQuery()" />
                </dd>
                <dt>발급년도</dt>
                <dd>
                    <select name="cardsIssueYear" title="발급년도" class="style-select width100" codeGroupCd="CARDS_ISSUE_YEAR"></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="cardsCustCd" title="고객사" class="style-select width120" codeGroupCd="CARDS_CUST_CD" overall="전체" selected_value=""></select>
                </dd>
                <dt>카드유형</dt>
                <dd>
                    <select name="cardsIssueTp" title="카드유형" class="style-select width100" codeGroupCd="CARDS_ISSUE_TP" overall="전체" selected_value=""></select>
                </dd>
                <dt>카드상태</dt>
                <dd>
                    <select name="cardsSt" title="카드상태" class="style-select width100" codeGroupCd="CARDS_ST" overall="전체" selected_value=""></select>
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <h3 class="style-title"><span name="title">카드 목록</span></h3>
    <!-- grid -->
    <div id="grid1_pager"></div>
    <table id="grid1"></table>
    <!--// grid -->
</div>
