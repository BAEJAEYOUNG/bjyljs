<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 관리자정보 json
var newJson1 = {};

var grid1 = null;
var grid2 = null;
var grid3 = null;
var grid4 = null;

/*****************************************************
 * 함수명 : ready
 * 설명   : onload 함수
 *****************************************************/
$(document).ready(function() {
    $("#search-panel input[name=custNm]").focus();
});

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    // 고객사 목록 그리드 생성
    var colModel = [];
//    colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:140});
    colModel.push({label:"고객사명", name:"custNm", format:"string", width:140});
    colModel.push({label:"고객사유형", name:"custTpNm", width:80});
    colModel.push({label:"고객사상태", name:"custStNm", width:80});
    colModel.push({label:"사업자번호", name:"bizNo", format:"biz_no", width:100});
    colModel.push({label:"상호", name:"tradeNm", format:"string", width:140});
    colModel.push({label:"대표자명", name:"ceoNm", width:80});
    colModel.push({label:"전화번호", name:"telNo", format:"tel_no", width:100});
    colModel.push({label:"주소", name:"addr", format:"string", width:160});
    colModel.push({label:"업태", name:"bizCond", width:80});
    colModel.push({label:"종목", name:"bizItem", width:80});
    colModel.push({label:"비고", name:"remark", format:"string", width:140});
    colModel.push({label:"서비스제공자코드", name:"spCd", hidden:true});
    colModel.push({label:"고객사 ID", name:"custId", hidden:true});
    colModel.push({label:"고객사유형", name:"custTp", hidden:true});
    colModel.push({label:"상태", name:"custSt", hidden:true});

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);

        var rowData = grid1.clickedRowData;

        // 서비스 목록 조회
        doQueryCustUser();
    };

    // 고객사 목록 그리드 생성
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
    grid1.pager.parent = grid1;                     // 페이저 소속 GRID 를 지정한다.
    grid1.pager.selectFunc = doQueryPaging;         // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    grid1.pager.show();

    $("#grid1").setGridHeight(160, true);

    // 고객사-사용자 목록 그리드 생성
    colModel = [];
    colModel.push({label:"학번/사번", name:"custUserNo", width:80});
    /* colModel.push({label:"사용자명", name:"userNm", format:"string", width:80}); */
    colModel.push({label:"휴대폰번호", name:"mpNo", format:"tel_no", width:100});
    /* colModel.push({label:"학번/사번", name:"custUserNo", width:80}); */
    colModel.push({label:"사용자상태", name:"userStNm", width:60});
    /* colModel.push({label:"법인여부", name:"corpYnNm", width:60}); */
    /* colModel.push({label:"사업자번호", name:"bizNo", width:100}); */
    colModel.push({label:"가입일시", name:"joinDtm", format:"dttm", width:120});
    colModel.push({label:"해지일시", name:"cancelDtm", format:"dttm", width:120});
    colModel.push({label:"해지사유", name:"cancelRsn", format:"string", width:200});
    colModel.push({label:"서비스제공자코드", name:"spCd", hidden:true});
    colModel.push({label:"고객사 ID", name:"custId", hidden:true});
    colModel.push({label:"사용자", name:"userId", hidden:true});
    colModel.push({label:"사용자유형", name:"userTp", hidden:true});
    colModel.push({label:"사용자상태", name:"userSt", hidden:true});
    colModel.push({label:"법인여부", name:"corpYn", hidden:true});
    colModel.push({label:"가입유형", name:"joinTp", hidden:true});
    colModel.push({label:"가입유형", name:"joinTpNm", hidden:true});
    colModel.push({label:"상태", name:"userSt", hidden:true});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid2.setClickedProp(rowId);

        var rowData = grid2.clickedRowData;

        // 서비스 목록 조회
        doQueryUserServHis();
    };
    gridProp.ondblClickRow = function (rowId, status, e) {
    };

    // 고객사-사용자  목록 그리드 생성
    grid2 = new ksid.grid("grid2", gridProp);
    grid2.loadGrid();

    var paging = {}
    paging.options = {};
    paging.options["var"] = {};
    paging.options["prop"] = {};
    paging.options["var"].elementId = "grid2_pager";
    paging.options["prop"].totrowcnt = 1;
    paging.options["prop"].pagecnt = 100;
    paging.options["prop"].pagenow = 1;
    paging.options["prop"].blockcnt = 15;
    paging.options.context = "${pageContext.request.contextPath}";

    grid2.pager = new ksid.paging(paging.options);
    grid2.pager.parent = grid2;                         // 페이저 소속 GRID 를 지정한다.
    grid2.pager.selectFunc = doQueryCustUserPaging;     // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    grid2.pager.show();


    // 사용자별 서비스 이력 목록 그리드 생성
    colModel = [];
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:140});
    //colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:120});
    //colModel.push({label:"과금상태", name:"billStateNm", width:80});
    colModel.push({label:"서비스상태", name:"servSt", width:80});
    colModel.push({label:"서비스시작일시", name:"servStDtm", format:"dttm", width:120});
    colModel.push({label:"서비스종료일시", name:"servEdDtm", width:120
                , formatter:function(cellvalue, options, rowObject) {
                    options.colModel.align = "center";
                    if (cellvalue == '99991231235959') {
                        return "제한없음";
                    } else {
                        return ksid.string.formatDttm(cellvalue);
                    }
                }});
    /* colModel.push({label:"TA신규설치수", name:"taInstallCnt", format:"number", width:80});
    colModel.push({label:"TA업데이트수", name:"taUpdateCnt", format:"number", width:80});
    colModel.push({label:"TA설치제한수", name:"limitCnt", width:80
                 , formatter:function(cellvalue, options, rowObject) {
                     options.colModel.align = "right";
                     if (-1 == cellvalue) {
                         return "제한없음";
                     } else {
                         return ksid.string.formatNumber(cellvalue);
                     }
                 }}); */
    colModel.push({label:"최초서비스가입일시", name:"joinDtm", format:"dttm", width:120});
    colModel.push({label:"서비스해지일시", name:"cancelDtm", format:"dttm", width:120});
    colModel.push({label:"서비스제공자코드", name:"spCd", hidden:true});
    colModel.push({label:"고객사 ID", name:"custId", hidden:true});
    colModel.push({label:"서비스아이디", name:"servId", hidden:true});
    colModel.push({label:"상품코드", name:"prodMclsCd", hidden:true});
    colModel.push({label:"사용자", name:"userId", hidden:true});
    colModel.push({label:"상품선택코드", name:"prodChoiceCd", hidden:true});
    colModel.push({label:"휴대폰번호", name:"mpNo", hidden:true});
    colModel.push({label:"과금상태", name:"billState", hidden:true});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };

    // 사용자별 서비스 이력 목록 그리드 생성
    grid3 = new ksid.grid("grid3", gridProp);
    grid3.loadGrid();


    // 결제 이력 목록 그리드 생성
    colModel = [];
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:140});
    //colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:120});
    colModel.push({label:"승인/취소", name:"payCmd", width:70});
    colModel.push({label:"결제수단", name:"payMethodNm", width:80});
    colModel.push({label:"결제금액", name:"payAmt", format:"number", width:100});
    colModel.push({label:"할부개월", name:"payMonth", width:60});
    colModel.push({label:"카드/은행", name:"payBank", width:90});
    colModel.push({label:"결제일시", name:"udrDtm", format:"dttm", width:120});
    colModel.push({label:"결제결과", name:"rstResultCd", hidden:true});
    colModel.push({label:"결제결과", name:"rstResultMsg", hidden:true});
    colModel.push({label:"결제수단", name:"payMethod", hidden:true});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };
    gridProp.loadComplete = function() {

        // 배경색상 css 선언
        var cssGreen  = {'background-color':'#6DFF6D'};
        var cssOrange = {'background-color':'orange'};
        var cssRed    = {'color':'red'};
        var cssBlue   = {'color':'blue'};

        // 그리드 데이터의 ID 가져오기
        var ids = $('#grid4').jqGrid('getDataIDs');

        // 그리드 데이터 가져오기
        var gridData = $('#grid4').jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {
            if (gridData[i].payMonth.length > 0) {
                if (gridData[i].payMonth == '00') {
                    $("#grid4").jqGrid('setRowData', ids[i], {payMonth:"일시불"});
                } else {
                    var monVal = parseInt(gridData[i].rstCardQuota) + "개월";
                    //console.log(monVal);
                    $("#grid4").jqGrid('setRowData', ids[i], {payMonth:monVal});
                }
            }
        }

    };
    // 결제 이력 목록 그리드 생성
    grid4 = new ksid.grid("grid4", gridProp);
    grid4.loadGrid();

    doQuery();
}


function searchpanelComboAjaxAfterDoQuery() {
    $("#search-panel input[name=custNm]").focus();
}

/*****************************************************
* 함수명 : 고객사 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);
}

/*****************************************************
* 함수명 : 고객사 목록 조회
* 설명   :
*****************************************************/
function doQueryPaging(resultMsg) {

    if (false == ksid.form.validateForm("search-panel")) {
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;


    var url = "${pageContext.request.contextPath}/sp/stat/custuser/list";
    ksid.net.ajaxJqGrid(grid1, url, params, function(result) {

        grid2.initGridData();
        grid3.initGridData();
        grid4.initGridData();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("고객사 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });
}


/*****************************************************
* 함수명 : 고객사-사용자 서비스 목록 조회
* 설명   :
*****************************************************/
function doQueryCustUser(resultMsg) {

    grid2.pager.prop.pagenow = 1;

    doQueryCustUserPaging(resultMsg);

}


/*****************************************************
* 함수명 : 고객사-사용자 학번, 사번 Reload
* 설명   :
*****************************************************/
function doReloadCustUser(resultMsg)
{
    var rowId = $("#grid1").getGridParam("selrow");
    if(rowId == null) {
        ksid.ui.alert("선택한 고객사가 없습니다.<br />고객사 목록을 선택하세요.");
        return;
    }

    doQueryCustUser(resultMsg);

}

/*****************************************************
* 함수명 : 고객사-사용자 서비스 목록 조회
* 설명   :
*****************************************************/
function doQueryCustUserPaging(resultMsg) {

    var rowId = $("#grid1").getGridParam("selrow");
    var rowData = $("#grid1").getRowData(rowId);

    var params = {};
    var keys = ["spCd", "custId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }
    params.custUserNo = $("#custUserNo").val().trim();
    params.mpNo =  $("#mpNo").val().trim();

    params.pagecnt = grid2.pager.prop.pagecnt;
    params.pagenow = grid2.pager.prop.pagenow;
    //console.log("params", params);

    var url = "${pageContext.request.contextPath}/sp/stat/custuser/userByCustList";
    ksid.net.ajaxJqGrid(grid2, url, params, function(result) {

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("고객사의 사용자 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });
}


/*****************************************************
* 함수명 : 고객사정보 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doQueryUserServHis(resultMsg) {

    var rowId = $("#grid2").getGridParam("selrow");
    var rowData = $("#grid2").getRowData(rowId);

    var params = {};
    var keys = ["spCd", "custId", "userId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }

    var url = "${pageContext.request.contextPath}/sp/stat/custuser/servHisByUserList";
    ksid.net.ajaxJqGrid(grid3, url, params, function(result) {

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("사용자 서비스 이력 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                            , "{0}", result.resultData.length));
        }
    });

    var url = "${pageContext.request.contextPath}/sp/stat/custuser/pgHisByUserList";
    ksid.net.ajaxJqGrid(grid4, url, params, function(result) {

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("사용자 결제 이력 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                            , "{0}", result.resultData.length));
        }
    });

}


/*****************************************************
* 함수명 : 고객사정보 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doCustExcel() {

    var url = "${pageContext.request.contextPath}/sp/stat/custuser/excelCust";
    var fileNm = "고객사";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);
}


/*****************************************************
* 함수명 : 사용자정보 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doUserExcel() {
    if(grid1.clickedRowData == null) {
        ksid.ui.alert("선택한 고객사가 없습니다.<br />고객사 목록을 선택하세요.");
        return;
    }

    var rowId = $("#grid1").getGridParam("selrow");
    var rowData = $("#grid1").getRowData(rowId);

    var params = {};
    var keys = ["spCd", "custId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }
    params.custUserNo = $("#custUserNo").val().trim();
    params.mpNo =  $("#mpNo").val().trim();

    var url = "${pageContext.request.contextPath}/sp/stat/custuser/excelUser";
    var fileNm = rowData["spNm"] + "_고객사_사용자";

    ksid.net.ajaxExcel(url, fileNm, params, grid2);
}


</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">서비스현황</span> > <span name="menu">고객사/사용자 현황</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <input type="hidden" name="spCd" value="${sessionScope.sessionUser.spCd}" />
        <div class="styleDlTable">
            <dl>
                <dt><span name="title" class="title_on">고객사</span></dt>
                <dd>
                    <input type="text" class="style-input width120" name="custNm" maxlength="40" title="고객사명" command="doQuery()"/>
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
        </div>
        <!--// button bar  -->
    </div>

    <div class="fTop">
        <h3 class="style-title"><span name="title">고객사 목록</span></h3>
        <div class="edit-panel">
            <!--  button bar  -->
            <div class="button-bar button-bar-abso">
                <button type="button" class="style-btn" auth="P" onclick="doCustExcel()">출력</button>
            </div>
            <!-- grid -->
            <div id="grid1_pager" class="pager"></div>
            <table id="grid1" resize="false"></table>
            <!--// grid -->
        </div>
     </div>

    <div class="variableWrapCode">
        <div class="fLeft">
            <h3 class="style-title"><span name="title">사용자 목록 리스트</span></h3>
            <div class="edit-panel" id="user-edit-panel">
                <div class="button-bar button-bar-abso">
                    <div class="styleDlTable">
                        <dl>
                            <dt><span name="title">학번/사번</span></dt>
                            <dd>
                                <input type="text" class="style-input width100" id="custUserNo" name="custUserNo" maxlength="20" title="학번/사번" command="doReloadCustUser()"/>
                            </dd>
                            <dt><span name="title">휴대폰번호</span></dt>
                            <dd>
                                <input type="text" class="style-input width100" id="mpNo" name="mpNo" maxlength="20" title="휴대폰번호" command="doReloadCustUser()"/>
                            </dd>
                            <dd style="width:20"> </dd>
                            <button type="button" class="style-btn" auth="R" onclick="doReloadCustUser()">재갱신</button>
                            <button type="button" class="style-btn" auth="P" onclick="doUserExcel()">출력</button>
                        </dl>
                    </div>
                </div>
                <div id="grid2_pager" class="pager"></div>
                <table id="grid2"></table>
                <!--  button bar  -->
             </div>
        </div>

        <div class="fRight">
            <div class="style-title-wrap">
            <h3 class="style-title"><span name="title">사용자 서비스 내역 (결제취소시 서비스 자동 종료)</span></h3>
            </div>
            <table id="grid3" resize="false"></table>
            <div class="style-title-wrap bottom50Percentage">
                <h3 class="style-title"><span name="title">사용자 결제 내역</span></h3>
            </div>
            <table id="grid4" ></table>
        </div>

    </div>

</div>
