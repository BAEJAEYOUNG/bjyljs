<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<style type="text/css">

.chkSearch {margin-bottom:3px; margin-right:2px;}

</style>

<script type="text/javascript" language="javascript">
// var grid1 = null;
// var tabs1_grid1 = null;
// var tabs2_grid1 = null;
//var tabs3_grid1 = null;

/*****************************************************
 * 함수명 : ready
 * 설명   : onload 함수
 *****************************************************/
$(document).ready(function() {
});

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    // 입렬매출 그리드
    var colModel = [];
    colModel.push({label:"트래픽일시", name:"statDtm", format:"ymdh", width:90});
//    colModel.push({label:"서비스제공자코드", name:"spCd", width:100});
    colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:100});
//    colModel.push({label:"고객사아이디", name:"custId", width:80});
    colModel.push({label:"고객사명", name:"custNm", format:"string", width:120});
//    colModel.push({label:"서비스아이디", name:"servId", width:80});
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:150});
//    colModel.push({label:"상품코드", name:"prodMclsCd", width:80});
    colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:80});
//    colModel.push({label:"과금분류코드", name:"prodCd", width:80});
    colModel.push({label:"과금분류", name:"prodNm", format:"string", width:100});
    colModel.push({label:"사용자수", name:"userCnt", format:"number", width:100});
    colModel.push({label:"유료건수", name:"billCnt", format:"number", width:100});
    colModel.push({label:"무료건수", name:"freeCnt", format:"number", width:100});
    colModel.push({label:"에러건수", name:"errorCnt", format:"number", width:100});

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.footerrow = true;
    gridProp.loadComplete = function() {

        var option = {};
        option.col = [ "userCnt", "billCnt", "freeCnt", "errorCnt" ];
        option.label = { "statDtm" : "합계" };
        grid1.setSum(option);

    };


    // 고객사 목록 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var group = {};
    group.useColSpanStyle = true;
    group.groupHeaders = [];
    group.groupHeaders.push({startColumnName: 'joinCnt', numberOfColumns: 2, titleText: "당일"});
    group.groupHeaders.push({startColumnName: 'totalJoinCnt', numberOfColumns: 3, titleText: "전체"});
    $("#grid1").jqGrid('setGroupHeaders', group);

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
* 함수명 : 고객사 목록 조회
* 설명   :
*****************************************************/
// 일별조회
function doQuery() {

 // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/stat/statservtrfday/list"
                      , params
                      , function(result) {

        if(result.resultCd == '00') {
            setGridHeader();
            CommonJs.setStatus(  ksid.string.replace( "서비스 가입 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

function setGridHeader() {

    var params = ksid.form.flushPanel('search-panel');

    grid1.hideCol(['spCd','spNm','custId','custNm','servId','servNm','prodMclsCd','prodMclsNm','prodCd','prodNm']);

    console.log('params', params);

    if( 'Y' == params.chkSp ) {
        grid1.showCol(['spCd','spNm']);
    }

    if( 'Y' == params.chkCust ) {
        grid1.showCol(['custId','custNm']);
    }

    if( 'Y' == params.chkProd ) {
        grid1.showCol(['prodMclsCd','prodMclsNm']);
    }

    if( 'Y' == params.chkServ ) {
        grid1.showCol(['servId','servNm']);
    }

    if( 'Y' == params.chkBillCls ) {
        grid1.showCol(['prodCd','prodNm']);
    }

}

/*****************************************************
* 함수명: 사용자목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var rownum =  $("#grid1").getGridParam("records");
    if (rownum == 0) {
        ksid.ui.alert("조회된 데이터가 없습니다!!!");
        return;
    }

    var url = "${pageContext.request.contextPath}/stat/statservtrfday/excel";
    var fileNm = "서비스트래픽현황목록";

    ksid.net.ajaxExcelGrid(url, fileNm, grid1);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">서비스현황</span> > <span name="menu">고객사 서비스1</span></p>
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
                <dt>서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width130" overall="전체" codeGroupCd="SP_CD"></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width130" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
            </dl>
            <dl>
                <dt class="width80">그룹</dt>
                <dd style="margin-top:5px;">
                    <input type='checkbox' id="chkGroupSp" name="chkSp" value='Y' class='chkSearch' checked /><label for='chkGroupSp'>서비스제공자</label>
                    &nbsp;&nbsp;
                    <input type='checkbox' id="chkGroupCust" name="chkCust" value='Y' class='chkSearch' checked /><label for='chkGroupCust'>고객사</label>
                    &nbsp;&nbsp;
                    <input type='checkbox' id="chkGroupProd" name="chkProd" value='Y' class='chkSearch' /><label for='chkGroupProd'>상품</label>
                    &nbsp;&nbsp;
                    <input type='checkbox' id="chkGroupServ" name="chkServ" value='Y' class='chkSearch' checked /><label for='chkGroupServ'>서비스</label>
                    &nbsp;&nbsp;
                    <input type='checkbox' id="chkGroupBillCls" name="chkBillCls" value='Y' class='chkSearch' checked /><label for='chkGroupBillCls'>과금분류</label>
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

    <h3 class="style-title"><span name="title">서비스 가입 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
