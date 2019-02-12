<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 관리자정보 json
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
    $("#search-panel input[name=custNm]").focus();
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
                    // 기준할인 목록 조회
                    //doQueryBasicDiscount();
                    break;
                case 3 :
                    // 행사할인 목록 조회
                    //doQueryPromoDiscount();
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

    // 고객사 목록 그리드 생성
    var colModel = [];
    colModel.push({label:"서비스제공자명", name:"spNm", format:"string", width:140});
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
        doQueryFixServ();

        // 기준할인 목록 조회
        doQueryBasicDiscount();

        // 행사할인 목록 조회
        doQueryPromoDiscount();
    };

    // 고객사 목록 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    $("#grid1").setGridHeight(160, true);

    // 서비스 목록 그리드 생성
    colModel = [];
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:140});
    colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:120});
    colModel.push({label:"유무상", name:"chargeFgNm", width:80});
    colModel.push({label:"과금대상유형", name:"billTarTpNm", width:80});
    colModel.push({label:"지불유형", name:"payFgNm", width:80});
    colModel.push({label:"과금유형", name:"billFgNm", width:80});
    colModel.push({label:"과금계산유형", name:"billCalcTpNm", width:100});
    colModel.push({label:"과금상태", name:"billStateNm", width:80});
    //colModel.push({label:"과금액", name:"billPrice", format:"number", width:120});
    colModel.push({label: '과금액', name: 'billPrice', width:120
        , formatter:function(cellvalue, options, rowObject) {
            //건별요금이 -9999로 SQL Select
            if (-9999 == cellvalue) {
                options.colModel.align = "center";
                return "상세금액(더블클릭)";
            } else {
                options.colModel.align = "right";
                return ksid.string.formatNumber(cellvalue);
            }
        }});
    colModel.push({label:"등록일시", name:"regDtm", format:"dttm", width:120});
    colModel.push({label:"서비스제공자코드", name:"spCd", hidden:true});
    colModel.push({label:"고객사 ID", name:"custId", hidden:true});
    colModel.push({label:"서비스 ID", name:"servId", hidden:true});
    colModel.push({label:"상품코드", name:"prodMclsCd", hidden:true});
    colModel.push({label:"상품선택코드", name:"prodChoiceCd", hidden:true});
    colModel.push({label:"유무상", name:"chargeFg", hidden:true});
    colModel.push({label:"과금대상유형", name:"billTarTp", hidden:true});
    colModel.push({label:"지불유형", name:"payFg", hidden:true});
    colModel.push({label:"과금유형", name:"billFg", hidden:true});
    colModel.push({label:"과금계산유형", name:"billCalcTp", hidden:true});
    colModel.push({label:"과금상태", name:"billState", hidden:true});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };
    gridProp.ondblClickRow = function (rowId, status, e) {
        tabs1_grid1.setClickedProp(rowId);

        var rowData = tabs1_grid1.clickedRowData;

        // 건별 서비스 목록 조회
        //if ("01" == rowData.billFg) {
            doQueryCaseServ();
        //}
    };

    // 서비스 목록 그리드 생성
    tabs1_grid1 = new ksid.grid("tabs1_grid1", gridProp);
    tabs1_grid1.loadGrid();

    // 건별 서비스 목록 그리드 생성
    colModel = [];
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:140});
    colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:120});
    colModel.push({label:"과금대상명", name:"prodNm", format:"string", width:240});
    //colModel.push({label:"건별과금액", name:"billPrice", format:"number", width:120});
    colModel.push({label: '건별과금액', name: 'billPrice', width:120
        , formatter:function(cellvalue, options, rowObject) {
            //건별요금이 아니면 -9999로 SQL Select
            if (-9999 == cellvalue) {
                options.colModel.align = "center";
                return "정액요금포함";
            } else {
                options.colModel.align = "right";
                return ksid.string.formatNumber(cellvalue);
            }
        }});
    //colModel.push({label:"비고", name:"remark", format:"string", width:160});
    colModel.push({label:"등록일시", name:"regDtm", format:"dttm", width:120});
    colModel.push({label:"서비스제공자코드", name:"spCd", hidden:true});
    colModel.push({label:"고객사 ID(은행,증권,기타)", name:"custId", hidden:true});
    colModel.push({label:"상품코드", name:"prodMclsCd", hidden:true});
    colModel.push({label:"상품선택코드", name:"prodChoiceCd", hidden:true});
    colModel.push({label:"실제 과금대상코드", name:"prodCd", hidden:true});
    colModel.push({label:"과금유형", name:"billFg", hidden:true});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };
    // 건별 서비스 목록 그리드 생성
    tabs2_grid1 = new ksid.grid("tabs2_grid1", gridProp);
    tabs2_grid1.loadGrid();

    // 기준할인 그리드 생성
    colModel = [];
    colModel.push({label:"기준할인행사명", name:"pbNm", format:"string", width:140});
    colModel.push({label:"기준할인대상구분", name:"pbTargetFgNm", width:120});
    colModel.push({label:"기준할인대상유형", name:"pbTargetTpNm", width:120});
    colModel.push({label:"기준할인대상수량", name:"pbTargetCnt", format:"number", width:120});
    colModel.push({label:"할인금액유형", name:"pbPriceTpNm", width:120});
    colModel.push({label:"할인율(%)", name:"saleRate", format:"number", width:100});
    colModel.push({label:"할인금액", name:"salePrice", format:"number", width:100});
    colModel.push({label:"시작일시", name:"stDtm", format:"date", width:120});
    colModel.push({label:"종료일시", name:"edDtm", format:"date", width:120});
    colModel.push({label:"기준할인아이디", name:"pbId", hidden:true});
    colModel.push({label:"기준할인대상구분", name:"pbTargetFg", hidden:true});
    colModel.push({label:"기준할인대상유형", name:"pbTargetTp", hidden:true});
    colModel.push({label:"할인금액유형", name:"pbPriceTp", hidden:true});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    }
    // 기준할인 그리드 생성
    tabs3_grid1 = new ksid.grid("tabs3_grid1", gridProp);
    tabs3_grid1.loadGrid();

    // 행사할인 그리드 생성
    colModel = [];
    colModel.push({label:"할인행사명", name:"promoNm", format:"string", width:140});
    colModel.push({label:"할인행사구분", name:"promoFgNm", width:120});
    colModel.push({label:"할인금액유형", name:"promoPriceTpNm", width:120});
    colModel.push({label:"할인율(%)", name:"saleRate", format:"number", width:100});
    colModel.push({label:"할인금액", name:"salePrice", format:"number", width:100});
    colModel.push({label:"시작일시", name:"stDtm", format:"date", width:120});
    colModel.push({label:"종료일시", name:"edDtm", format:"date", width:120});
    colModel.push({label:"할인행사아이디", name:"promoId", hidden:true});
    colModel.push({label:"할인행사구분", name:"promoFg", hidden:true});
    colModel.push({label:"할인금액유형", name:"promoPriceTp", hidden:true});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    }

    // 행사할인 그리드 생성
    tabs4_grid1 = new ksid.grid("tabs4_grid1", gridProp);
    tabs4_grid1.loadGrid();

}


function searchpanelComboAjaxAfterDoQuery() {
}

/*****************************************************
* 함수명 : 고객사 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    if (false == ksid.form.validateForm("search-panel")) {
        return;
    }

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    var url = "${pageContext.request.contextPath}/stat/cust/list";
    ksid.net.ajaxJqGrid(grid1, url, params, function(result) {

        tabs1_grid1.initGridData();
        tabs2_grid1.initGridData();
        tabs3_grid1.initGridData();
        tabs4_grid1.initGridData();

        $("#tabs").tabs("select", 0);

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
* 함수명 : 고객사별 서비스 목록 조회
* 설명   :
*****************************************************/
function doQueryFixServ(resultMsg) {

    var rowId = $("#grid1").getGridParam("selrow");
    var rowData = $("#grid1").getRowData(rowId);

    var params = {};
    var keys = ["spCd", "custId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }

    var url = "${pageContext.request.contextPath}/stat/cust/fixServByCustList";
    ksid.net.ajaxJqGrid(tabs1_grid1, url, params, function(result) {

        tabs2_grid1.initGridData();

        $("#tabs").tabs("select", 0);

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("서비스 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });
}

/*****************************************************
* 함수명 : 고객사별 건별 서비스 목록 조회
* 설명   :
*****************************************************/
function doQueryCaseServ(resultMsg) {

    var rowId = $("#tabs1_grid1").getGridParam("selrow");
    var rowData = $("#tabs1_grid1").getRowData(rowId);

    var params = {};
    var keys = ["spCd", "custId", "servId", "prodMclsCd"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }

    var url = "${pageContext.request.contextPath}/stat/cust/caseServByCustList";
    ksid.net.ajaxJqGrid(tabs2_grid1, url, params, function(result) {

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("건별 서비스 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }

        $("#tabs").tabs("select", 1);
    });
}


/*****************************************************
* 함수명 : 고객사별 기준할인 목록 조회
* 설명   :
*****************************************************/
function doQueryBasicDiscount(resultMsg) {

    var rowId = $("#grid1").getGridParam("selrow");
    var rowData = $("#grid1").getRowData(rowId);

    var params = {};
    var keys = ["spCd", "custId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }

    var url = "${pageContext.request.contextPath}/stat/cust/basicDiscountByCustList";
    ksid.net.ajaxJqGrid(tabs3_grid1, url, params, function(result) {

        $("#tabs").tabs("select", 0);

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("고객사의 기준할인 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });
}

/*****************************************************
* 함수명 : 고객사별 행사할인 목록 조회
* 설명   :
*****************************************************/
function doQueryPromoDiscount(resultMsg) {

    var rowId = $("#grid1").getGridParam("selrow");
    var rowData = $("#grid1").getRowData(rowId);

    var params = {};
    var keys = ["spCd", "custId"];
    for (var i in keys) {
        params[keys[i]] = rowData[keys[i]];
    }

    var url = "${pageContext.request.contextPath}/stat/cust/promoDiscountByCustList";
    ksid.net.ajaxJqGrid(tabs4_grid1, url, params, function(result) {

        $("#tabs").tabs("select", 0);

        if (resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("고객사의 행사할인 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });
}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">서비스현황</span> > <span name="menu">고객사 서비스</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt><span name="title" class="title_on">고객사</span></dt>
                <dd>
                    <input type="text" class="style-input width120" name="custNm" maxlength="40" title="고객사명" command="doQuery()"/>
                </dd>
                <dt><span name="title" class="title_on">서비스제공자</span></dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" overall="전체" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
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

    <h3 class="style-title"><span name="title">고객사 목록</span></h3>
    <!-- grid -->
    <table id="grid1" resize="false"></table>
    <!--// grid -->

    <h3 class="style-title"><span name="title">고객사별 서비스 목록</span></h3>
    <div id="tabs" class="easyui-tabs">
        <div title="서비스">
            <table id="tabs1_grid1"></table>
        </div>
        <div title="건별서비스">
            <table id="tabs2_grid1"></table>
        </div>
        <div title="기준할인">
            <table id="tabs3_grid1"></table>
        </div>
        <div title="행사할인">
            <table id="tabs4_grid1"></table>
        </div>
    </div>
</div>
