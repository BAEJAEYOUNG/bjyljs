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

    // 분기별매출현황 그리드
    var colModel = [];
    colModel.push({label:"분기", name:"statQuarter", width:80});
//    colModel.push({label:"서비스제공자코드", name:"spCd", width:100});
    colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:100});
//    colModel.push({label:"고객사아이디", name:"custId", width:80});
    colModel.push({label:"고객사명", name:"custNm", format:"string", width:120});
//    colModel.push({label:"서비스아이디", name:"servId", width:80, hidden: true});
//    colModel.push({label:"서비스명", name:"servNm", width:80, hidden: true});
    colModel.push({label:"서비스명", name:"servNm", width:120});
//    colModel.push({label:"상품코드", name:"prodMclsCd", width:80});
    colModel.push({label:"상품명", name:"prodMclsNm", width:80});
    colModel.push({label:"사용자수", name:"userCntP", format:"number", width:60});
    colModel.push({label:"승인건수", name:"apprCntP", format:"number", width:60});
    colModel.push({label:"승인요금", name:"apprAmtP", format:"number", width:100});
    colModel.push({label:"취소건수", name:"cancelCntP", format:"number", width:60});
    colModel.push({label:"취소요금", name:"cancelAmtP", format:"number", width:100});
    colModel.push({label:"합계건수", name:"billCntP", format:"number", width:60});
    colModel.push({label:"합계요금", name:"billFeeP", format:"number", width:100})
    colModel.push({label:"사용자수", name:"userCntA", format:"number", width:60});
    colModel.push({label:"요금건수", name:"billCntA", format:"number", width:60});
    colModel.push({label:"사용요금", name:"billFeeA", format:"number", width:100});
    colModel.push({label:"사용자수", name:"userCntT", format:"number", width:60});
    colModel.push({label:"요금건수", name:"billCntT", format:"number", width:60});
    colModel.push({label:"사용요금", name:"billFeeT", format:"number", width:100});

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.footerrow = true;
    gridProp.loadComplete = function() {

        var option = {};
        option.col = [ "apprCntP", "cancelCntP", "apprAmtP", "cancelAmtP",
                       "userCntP", "billCntP", "billFeeP",
                       "userCntA", "billCntA", "billFeeA",
                       "userCntT", "billCntT", "billFeeT" ];
        option.label = { "statQuarter" : "합계" };
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

    // 분기별 매출현황그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var group = {};
    group.useColSpanStyle = true;
    group.groupHeaders = [];
    group.groupHeaders.push({startColumnName: 'userCntP', numberOfColumns: 7, titleText: "선불 (정액요금)"});
    group.groupHeaders.push({startColumnName: 'userCntA', numberOfColumns: 3, titleText: "후불 (종량요금)"});
    group.groupHeaders.push({startColumnName: 'userCntT', numberOfColumns: 3, titleText: "합계"});
    $("#grid1").jqGrid('setGroupHeaders', group);

}

function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#search-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

    $('#search-panel select[name=sQ] option:eq(1)').prop('selected', true);
    $('#search-panel select[name=eQ] option:first').prop('selected', true);
    $("#search-panel select[name=sQ]").trigger("change");
    $("#search-panel select[name=eQ]").trigger("change");

}

/*****************************************************
* 함수명 : 분기별 매출현황 조회
* 설명   :
*****************************************************/
// 일별조회
function doQuery() {

 // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/salestat/salestatquarter/list"
                      , params
                      , function(result) {

        if(result.resultCd == '00') {
            setGridHeader();
            CommonJs.setStatus(  ksid.string.replace( "분기별 매출현황 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

function setGridHeader() {

    var params = ksid.form.flushPanel('search-panel');

    grid1.hideCol(['spCd','spNm','custId','custNm','servId','servNm','prodMclsCd','prodMclsNm','payFgNm','billFgNm'
                   ,"apprCntP","cancelCntP","apprAmtP","cancelAmtP",'userCntP','billCntP','billFeeP',
                   'userCntA','billCntA','billFeeA','userCntT','billCntT','billCntT','billFeeT']);

    if( 'Y' == params.chkSp ) {
        grid1.showCol(['spCd','spNm']);
    }
    if( 'Y' == params.chkCust ) {
        grid1.showCol(['custId','custNm']);
    }
    if( 'Y' == params.chkServ ) {
        grid1.showCol(['servId','servNm']);
    }
    if( 'Y' == params.chkProd ) {
        grid1.showCol(['prodMclsCd','prodMclsNm']);
    }

    //요금종류
    params.selectType
    if( 'P' == params.selectType ) {
        console.log("params.selectType :" + params.selectType);
        grid1.showCol(["apprCntP", "cancelCntP", "apprAmtP", "cancelAmtP",'userCntP','billCntP','billFeeP']);
    }
    if( 'A' == params.selectType ) {
        console.log("params.selectType :" + params.selectType);
        grid1.showCol(['userCntA','billCntA','billFeeA']);
    }
    if( 'T' == params.selectType ) {
        console.log("params.selectType :" + params.selectType);
        grid1.showCol(["apprCntP", "cancelCntP", "apprAmtP", "cancelAmtP",'userCntP','billCntP','billFeeP','userCntA','billCntA','billFeeA','userCntT','billCntT','billFeeT']);
    }

}

/*****************************************************
* 함수명 : 분기별 매출현황 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var rownum =  $("#grid1").getGridParam("records");
    if (rownum == 0) {
        ksid.ui.alert("조회된 데이터가 없습니다!!!");
        return;
    }

    var url = "${pageContext.request.contextPath}/salestat/salestatquarter/excel";
    var fileNm = "분기별매출현황목록";

    ksid.net.ajaxExcelGrid(url, fileNm, grid1);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">매출현황</span> > <span name="menu">분기별 매출현황</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">

        <div class="styleDlTable">
            <dl>
                <dt class="width80">조회기간</dt>
                <dd>
                   <select name="sQ" title="조회시작분기" class="style-select" codeGroupCd="sQuarter" required></select>
                    ~
                    <select name="eQ" title="조회종료분기" class="style-select" codeGroupCd="eQuarter" required></select>
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
                    <input type='checkbox' id="chkGroupProd" name="chkProd" value='Y' class='chkSearch'/><label for='chkGroupProd'>상품</label>
                    &nbsp;&nbsp;
                    <input type='checkbox' id="chkGroupProd" name="chkServ" value='Y' class='chkSearch' checked/><label for='chkGroupServ'>서비스</label>
                </dd>
                <dd style="width:20px;">
                <dt class="width80">요금종류</dt>
                <dd scope="row" style="margin-top:5px;">
                    <span class="radio-wrap">
                        <input type="radio" name=selectType value="P" id="billP"/>
                        <label for="billP">선불</label>
                    </span>
                    <span class="radio-wrap">
                        <input type="radio"" name="selectType" value="A" id="billA"/>
                        <label for="billA">후불</label>
                    </span>
                    <span class="radio-wrap">
                        <input type="radio"" name="selectType" value="T" id="billT" checked="checked"/>
                        <label for="billT">전체</label>
                    </span>
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

    <h3 class="style-title"><span name="title">분기별 매출현황 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
