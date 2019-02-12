<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<style type="text/css">

.chkSearch {margin-bottom:3px; margin-right:2px;}

</style>

<script type="text/javascript" language="javascript">
var grid1 = null;
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

    // 월별매출현황 그리드
    var colModel = [];
    colModel.push({label:"매출월", name:"statMonth", format:"ym", width:80});
//    colModel.push({label:"서비스제공자코드", name:"spCd", width:100});
//    colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:100});
//    colModel.push({label:"고객사아이디", name:"custId", width:80});
    colModel.push({label:"고객사명", name:"custNm", format:"string", width:120});
//    colModel.push({label:"서비스아이디", name:"servId", width:80, hidden: true});
//    colModel.push({label:"서비스명", name:"servNm", width:80, hidden: true});
    colModel.push({label:"서비스명", name:"servNm", width:120});
//    colModel.push({label:"상품코드", name:"prodMclsCd", width:80});
    colModel.push({label:"상품명", name:"prodMclsNm", width:100});
    colModel.push({label:"사용자수", name:"userCntP", format:"number", width:80});
    colModel.push({label:"승인건수", name:"apprCntP", format:"number", width:80});
    colModel.push({label:"승인요금", name:"apprAmtP", format:"number", width:80});
    colModel.push({label:"취소건수", name:"cancelCntP", format:"number", width:80});
    colModel.push({label:"취소요금", name:"cancelAmtP", format:"number", width:100});
    colModel.push({label:"합계건수", name:"billCntP", format:"number", width:80});
    colModel.push({label:"합계요금", name:"billFeeP", format:"number", width:100})

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.footerrow = true;
    gridProp.loadComplete = function() {

        var option = {};
        option.col = [ "apprCntP", "cancelCntP", "apprAmtP", "cancelAmtP",
                       "userCntP", "billCntP", "billFeeP" ];
        option.label = { "statMonth" : "합계" };
        grid1.setSum(option);

        // 배경색상 css 선언
        var cssOrange   = {'color':'red'};

        // 그리드 데이터의 ID 가져오기
        var ids = $('#grid1').jqGrid('getDataIDs');

        // 그리드 데이터 가져오기
        var gridData = $("#grid1").jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {
            //ksid.ui.alert("billFeeT :" + gridData[i].billFeeT);
            if (gridData[i].billFeeP < 0) {
                $('#grid1').jqGrid('setCell', ids[i], 'billFeeP', '', cssOrange);
            }
            if (gridData[i].billFeeT < 0) {
                $('#grid1').jqGrid('setCell', ids[i], 'billFeeT', '', cssOrange);
            }
        }
    };

    // 월별매출현황그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var group = {};
    group.useColSpanStyle = true;
    group.groupHeaders = [];
    group.groupHeaders.push({startColumnName: 'userCntP', numberOfColumns: 7, titleText: "선불 (정액요금)"});
    $("#grid1").jqGrid('setGroupHeaders', group);

}

function searchpanelComboAjaxAfterDoQuery() {

    var sM = new ksid.datetime().before(0,1,0).getDate("yyyy-mm");
    var eM = new ksid.datetime().getDate("yyyy-mm");
    $("#search-panel input[name=sM]").val(sM);
    $("#search-panel input[name=eM]").val(eM);

    var params = {spCd:"${sessionScope.sessionUser.spCd}", custId:"${sessionScope.sessionUser.custId}"};
    var combo = $("#search-panel select[name=custId]");
    ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

}

/*****************************************************
* 함수명 : 월별매출현황 목록 조회
* 설명   :
*****************************************************/
// 일별조회
function doQuery() {

 // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/sp/stat/salestatmonth/list"
                      , params
                      , function(result) {

        if(result.resultCd == '00') {
            setGridHeader();
            CommonJs.setStatus(  ksid.string.replace( "월별 매출현황 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

function setGridHeader() {

    var params = ksid.form.flushPanel('search-panel');

    grid1.hideCol(['spCd','spNm','custId','custNm','servId','servNm','prodMclsCd','prodMclsNm','payFgNm','billFgNm' ]);

    if( 'Y' == params.chkCust ) {
        grid1.showCol(['custId','custNm']);
    }
    if( 'Y' == params.chkServ ) {
        grid1.showCol(['servId','servNm']);
    }
    if( 'Y' == params.chkProd ) {
        grid1.showCol(['prodMclsCd','prodMclsNm']);
    }

}

/*****************************************************
* 함수명 : 월별 매출현황 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var rownum =  $("#grid1").getGridParam("records");
    if (rownum == 0) {
        ksid.ui.alert("조회된 데이터가 없습니다!!!");
        return;
    }

    var url = "${pageContext.request.contextPath}/sp/stat/salestatmonth/excel";
    var fileNm = "월별매출현황목록";

    ksid.net.ajaxExcelGrid(url, fileNm, grid1);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">매출현황</span> > <span name="menu">월별 매출현황1</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">

        <input type="hidden" name="spCd" value="${sessionScope.sessionUser.spCd}" />
        <div class="styleDlTable">
            <dl>
                <dt class="width80">조회기간</dt>
                <dd>
                    <input name="sM" type="text" format="ym" class="style-input width60" title="시작월" required />
                     ~
                    <input name="eM" type="text" format="ym" class="style-input width60" title="종료월" required />
                </dd>
                <dd style="width:20px;">
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width150" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
            </dl>
            <dl>
                <dt class="width80">그룹</dt>
                <dd style="margin-top:5px;">
                    <input type='checkbox' id="chkGroupCust" name="chkCust" value='Y' class='chkSearch' checked /><label for='chkGroupCust'>고객사</label>
                    &nbsp;&nbsp;
                    <input type='checkbox' id="chkGroupProd" name="chkProd" value='Y' class='chkSearch'/><label for='chkGroupProd'>상품</label>
                    &nbsp;&nbsp;
                    <input type='checkbox' id="chkGroupProd" name="chkServ" value='Y' class='chkSearch' checked/><label for='chkGroupServ'>서비스</label>
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

    <h3 class="style-title"><span name="title">월별 매출현황 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
