<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 사용자 정보 json
var newJson1 = {};

var grid1 = null;
var tabs1_grid1 = null;
var tabs2_grid1 = null;
var tabs3_grid1 = null;
var tabs4_grid1 = null;

/*****************************************************
 * 함수명 : ready
 * 설명   : onload 함수
 *****************************************************/
$(document).ready(function() {
    $("#search-panel input[name=userNm]").focus();
});

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    $('#tabs').tabs({
        onAdd : function(title, index) {
        }
        , onSelect : function(title, index) {
            switch(index) {
                case 0 :
                    // 서비스 목록 조회
                    // doQueryFixServ();
                    break;
                case 1 :
                    break;
                case 2 :
                    // 사용자 목록 조회
                    //doQueryUser();
                    break;
                case 3 :
                    break;
                default :
                    break;
            }
        }
        , onUnselect : function(title, index) {
        }
        , onBeforeClose : function(title, index) {
        }
        , onClose : function(title, index) {
        }
        , onUpdate : function(title, index) {
        }
    });

    // 사용자별 서비스 목록 그리드 생성
    var colModel = [];
    //colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:140});
    //colModel.push({label:"고객사명", name:"custNm", format:"string", width:140});
    colModel.push({label:"사용자명", name:"userNm", format:"string", width:80});
    colModel.push({label:"휴대폰번호", name:"mpNo", format:"tel_no", width:100});
    colModel.push({label:"가입유형", name:"joinTpNm", width:80});
    colModel.push({label:"사용자상태", name:"userStNm", width:80});
    colModel.push({label:"법인여부", name:"corpYnNm", width:80});
    colModel.push({label:"사업자번호", name:"bizNo", width:100});
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
    colModel.push({label:"상태", name:"userSt", hidden:true});

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);

        var rowData = grid1.clickedRowData;

        // 사용자별 서비스 목록 조회
        doQueryUserServ();

    };
    gridProp.loadComplete = function(data) {

        // 배경색상 css 선언
        var cssGreen  = {'background-color':'#6DFF6D'};
        var cssOrange = {'background-color':'orange'};
        var cssRed    = {'color':'red'};
        var cssBlue   = {'color':'blue'};

        // 그리드 데이터의 ID 가져오기
        var ids = $('#grid1').jqGrid('getDataIDs');

        // 그리드 데이터 가져오기
        var gridData = $('#grid1').jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {

            if (gridData[i].userSt == '0') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'userStNm', '', cssBlue);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'userStNm', '', cssRed);
            }
        }
    }

    // 사용자별 서비스 목록 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    $("#grid1").setGridHeight(160, true);

    var paging = {}
    paging.options = {};
    paging.options["var"] = {};
    paging.options["prop"] = {};
    paging.options["var"].elementId = "grid1_pager";
    paging.options["prop"].totrowcnt = 1;
    paging.options["prop"].pagecnt = 10;
    paging.options["prop"].pagenow = 1;
    paging.options["prop"].blockcnt = 15;
    paging.options.context = "${pageContext.request.contextPath}";

    grid1.pager = new ksid.paging(paging.options);
    grid1.pager.parent = grid1;                 // 페이저 소속 GRID 를 지정한다.
    grid1.pager.selectFunc = doQueryPaging;     // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    grid1.pager.show();

    // 서비스 목록 그리드 생성
    colModel = [];
    colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:140});
    colModel.push({label:"고객사명", name:"custNm", format:"string", width:140});
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:140});
    colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:120});
    colModel.push({label:"과금상태", name:"billStateNm", width:80});
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
    colModel.push({label:"TA신규설치수", name:"taInstallCnt", format:"number", width:100});
    colModel.push({label:"TA업데이트수", name:"taUpdateCnt", format:"number", width:100});
    colModel.push({label:"TA설치제한수", name:"limitCnt", width:100
                 , formatter:function(cellvalue, options, rowObject) {
                     options.colModel.align = "right";
                     if (-1 == cellvalue) {
                         return "제한없음";
                     } else {
                         return ksid.string.formatNumber(cellvalue);
                     }
                 }});
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
    gridProp.ondblClickRow = function (rowId, status, e) {
    };
    gridProp.loadComplete = function (data) {

        // 배경색상 css 선언
        var cssGreen  = {'background-color':'#6DFF6D'};
        var cssOrange = {'background-color':'orange'};
        var cssRed    = {'color':'red'};
        var cssBlue   = {'color':'blue'};

        // 그리드 데이터의 ID 가져오기
        var ids = $('#tabs1_grid1').jqGrid('getDataIDs');

        // 그리드 데이터 가져오기
        var gridData = $('#tabs1_grid1').jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {

            if (gridData[i].billState == '0') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#tabs1_grid1').jqGrid('setCell', ids[i], 'billStateNm', '', cssBlue);
            } else {
                $('#tabs1_grid1').jqGrid('setCell', ids[i], 'billStateNm', '', cssRed);
            }
        }
    }

    // 서비스 목록 그리드 생성
    tabs1_grid1 = new ksid.grid("tabs1_grid1", gridProp);
    tabs1_grid1.loadGrid();

    // 사용자별 서비스 이력 목록 그리드 생성
    colModel = [];
    colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:140});
    colModel.push({label:"고객사명", name:"custNm", format:"string", width:140});
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:140});
    colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:120});
    //colModel.push({label:"과금상태", name:"billStateNm", width:80});
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
    colModel.push({label:"TA신규설치수", name:"taInstallCnt", format:"number", width:100});
    colModel.push({label:"TA업데이트수", name:"taUpdateCnt", format:"number", width:100});
    colModel.push({label:"TA설치제한수", name:"limitCnt", width:100
                 , formatter:function(cellvalue, options, rowObject) {
                     options.colModel.align = "right";
                     if (-1 == cellvalue) {
                         return "제한없음";
                     } else {
                         return ksid.string.formatNumber(cellvalue);
                     }
                 }});
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
    tabs2_grid1 = new ksid.grid("tabs2_grid1", gridProp);
    tabs2_grid1.loadGrid();


    // 결제 이력 목록 그리드 생성
    colModel = [];
    colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:140});
    colModel.push({label:"고객사명", name:"custNm", format:"string", width:140});
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:140});
    colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:120});
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
        var ids = $('#tabs3_grid1').jqGrid('getDataIDs');

        // 그리드 데이터 가져오기
        var gridData = $('#tabs3_grid1').jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {
            if (gridData[i].payMonth.length > 0) {
                if (gridData[i].payMonth == '00') {
                    $("#tabs3_grid1").jqGrid('setRowData', ids[i], {payMonth:"일시불"});
                } else {
                    var monVal = parseInt(gridData[i].rstCardQuota) + "개월";
                    $("#tabs3_grid1").jqGrid('setRowData', ids[i], {payMonth:monVal});
                }
            }
        }

    };
    // 결제 이력 목록 그리드 생성
    tabs3_grid1 = new ksid.grid("tabs3_grid1", gridProp);
    tabs3_grid1.loadGrid();


    // 번호변경 이력 목록 그리드 생성
    colModel = [];
    colModel.push({label:"변경전 핸드폰번호", name:"oldMpNo", format:"tel_no", width:140});
    colModel.push({label:"변경후 핸드폰번호", name:"newMpNo", format:"tel_no", width:140});
    colModel.push({label:"번호변경일시", name:"chgDtm", format:"dttm", width:120});
    colModel.push({label:"번경자", name:"chgNm", width:120});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };

    // 번호변경 목록 그리드 생성
    tabs4_grid1 = new ksid.grid("tabs4_grid1", gridProp);
    tabs4_grid1.loadGrid();
}

/*****************************************************
* 함수명 : 사용자 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);
}

/*****************************************************
* 함수명 : 사용자 목록 페이징 조회
* 설명   :
*****************************************************/
function doQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    var url = "${pageContext.request.contextPath}/stat/user/list";
    ksid.net.ajaxJqGrid(grid1, url, params, function(result) {

        tabs1_grid1.initGridData();
        tabs2_grid1.initGridData();
        tabs3_grid1.initGridData();
        tabs4_grid1.initGridData();

        $("#tabs").tabs("select", 0);

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("사용자 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });
}

/*****************************************************
* 함수명 : 사용자별 서비스 목록 조회
* 설명   :
*****************************************************/
function doQueryUserServ(resultMsg) {

    var rowId = $("#grid1").getGridParam("selrow");
    var rowData = $("#grid1").getRowData(rowId);

    var params = ksid.form.flushPanel("search-panel");
    var keys = ["userId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }
    //console.log("params1:", params);

    //사용자 서비스 조회
    var url = "${pageContext.request.contextPath}/stat/user/fixServByUserList";
    ksid.net.ajaxJqGrid(tabs1_grid1, url, params, function(result) {

        //tabs2_grid1.initGridData();

        $("#tabs").tabs("select", 0);

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("서비스 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });

    //사용자 서비스 이력
    var params = {};
    //var keys = ["spCd", "custId", "servId", "prodMclsCd", "userId"];
    var keys = ["userId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }

    var url = "${pageContext.request.contextPath}/stat/user/fixServHisByUserList";
    ksid.net.ajaxJqGrid(tabs2_grid1, url, params, function(result) {

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("사용자 서비스 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });

    //결제이력 조회
    var params = {};
    var keys = ["spCd", "custId", "servId", "prodMclsCd", "userId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }
    //console.log("params2:", params);

    var url = "${pageContext.request.contextPath}/stat/user/pgPayByUserList";
    ksid.net.ajaxJqGrid(tabs3_grid1, url, params, function(result) {

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("사용자 결제 이력 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }

    });

    //번호변경 이력
    var params = {};
    var keys = ["userId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }
    //console.log("params2:", params);

    var url = "${pageContext.request.contextPath}/stat/user/mpNoChgHisByUserList";
    ksid.net.ajaxJqGrid(tabs4_grid1, url, params, function(result) {

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("사용자 번호변경 이력 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }

    });

}


/*****************************************************
* 함수명 : 멀티 콤보 처리
* 설명   :
*****************************************************/
function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#search-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">서비스현황</span> > <span name="menu">사용자 서비스</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt><span name="title" class="title_on">사용자명</span></dt>
                <dd>
                    <input type="text" class="style-input width120" name="userNm" maxlength="40" title="사용자명" command="doQuery()"/>
                </dd>
                <dt><span name="title" class="title_on">휴대폰번호</span></dt>
                <dd>
                    <input type="text" class="style-input width120" name="mpNo" maxlength="40" title="휴대폰번호" command="doQuery()"/>
                </dd>
                <dt><span name="title" class="title_on">사용자상태</span></dt>
                <dd>
                    <select name="userSt" title="사용자상태" class="style-select width200" overall="전체" codeGroupCd="USER_ST" selected_value=""></select>
                </dd>
                <!--
                <dt><span name="title" class="title_on">서비스제공자</span></dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" overall="전체" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
                <dt><span name="title" class="title_on">고객사</span></dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
                 -->
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <!--
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
             -->
        </div>
        <!--// button bar  -->
    </div>

    <h3 class="style-title"><span name="title">사용자 목록</span></h3>
    <!-- grid -->
    <table id="grid1" resize="false"></table>
    <div id="grid1_pager" class="pager"></div>
    <!--// grid -->

    <h3 class="style-title"><span name="title">사용자별 서비스 목록</span></h3>
    <div id="tabs" class="easyui-tabs">
        <div title="서비스">
            <table id="tabs1_grid1"></table>
        </div>
        <div title="서비스 이력">
            <table id="tabs2_grid1"></table>
        </div>
        <div title="결제 이력">
            <table id="tabs3_grid1"></table>
        </div>
        <div title="번호변경 이력">
            <table id="tabs4_grid1"></table>
        </div>
    </div>
</div>
