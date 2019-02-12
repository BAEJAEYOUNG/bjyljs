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

    // 사용자 목록 그리드 생성
    colModel = [];

    colModel.push({label:"서비스제공자", name:"spNm", format:"string", width:120});
    colModel.push({label:"고객사", name:"custNm", format:"string", width:120});
    colModel.push({label:"사용자명", name:"userNm", format:"string", width:80});
    colModel.push({label:"휴대폰번호", name:"mpNo", format:"tel_no", width:100});
    colModel.push({label:"학번/사번", name:"custUserNo", width:80});
    colModel.push({label:"사용자상태", name:"userStNm", width:60});
    colModel.push({label:"가입일시", name:"joinDtm", format:"dttm", width:120});
    colModel.push({label:"법인여부", name:"corpYnNm", width:60});
    colModel.push({label:"사업자번호", name:"bizNo", width:100});
    colModel.push({label:"해지일시", name:"cancelDtm", format:"dttm", width:120});
    colModel.push({label:"해지사유", name:"cancelRsn", format:"string", width:200});
    colModel.push({label:"서비스제공자코드", name:"spCd", hidden:true});
    colModel.push({label:"서비스제공자사업자번호", name:"bizNo", hidden:true});
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

        grid1.setClickedProp(rowId);

        var rowData = grid1.clickedRowData;

        // 사용자 서비스 내역,
        doSearchService();
        // 사용자 결제내역 조회
        doSearchUser();

    };

    // 고객사-사용자  목록 그리드 생성
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
    grid1.pager.parent = grid1;                         // 페이저 소속 GRID 를 지정한다.
    grid1.pager.selectFunc = doQueryPaging;             // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    grid1.pager.show();


    // 사용자별 서비스 이력 목록 그리드 생성
    colModel = [];
    colModel.push({label:"서비스명", name:"servNm", format:"string", width:140});
    colModel.push({label:"상품명", name:"prodMclsNm", format:"string", width:120});
    colModel.push({label:"과금상태", name:"billStateNm", width:80});
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
    colModel.push({label:"TA신규설치수", name:"taInstallCnt", format:"number", width:80});
    colModel.push({label:"TA업데이트수", name:"taUpdateCnt", format:"number", width:80});
    colModel.push({label:"TA설치제한수", name:"limitCnt", width:80
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
    grid2 = new ksid.grid("grid2", gridProp);
    grid2.loadGrid();


    // 결제 이력 목록 그리드 생성
    var colModel = [];

    colModel.push({ label:'서비스제공자코드', name:'spCd', hidden:true });
    colModel.push({ label:'고객사아이디', name:'custId', hidden:true });
    colModel.push({ label:'서비스아이디', name:'servId', hidden:true });
    colModel.push({ label:'취소비밀번호', name:'cancelPwd', hidden:true });
    colModel.push({ label:'부분취소금액', name:'cancelAmt', hidden:true });
    colModel.push({ label:'거래 ID', name:'payTid', hidden:true });
    colModel.push({ label:'가맹점 ID', name:'payMid', hidden:true });
    colModel.push({ label:'취소가능금액', name:'payCancelAmt', hidden:true });
    colModel.push({ label:'취소구분', name:'payCancelFg', hidden:true });

    colModel.push({ label:'결제일시', name:'udrDtm', format:'dttm', width:120 });
    colModel.push({ label:'서비스명', name:'servNm', format:'string', width:170 });
    colModel.push({ label:'결제금액', name:'rstAmt', format:'number', width:70 });
    colModel.push({ label:'결제수단', name:'payMethodNm', width:70 });
    colModel.push({ label:'승인/취소', name:'payCmdNm', width:70 });
    colModel.push({ label:'취소가능여부', name:'payCancelableYn', format:'string', width:300 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid3.setClickedProp(rowId);
//         ksid.debug.printObj('grid3.clickedRowData', grid3.clickedRowData);
    };
    grid3 = new ksid.grid("grid3", gridProp);
    grid3.loadGrid();


//     var sDate = new ksid.datetime().before(1,0,0).getDate("yyyy-mm-dd");
//     var eDate = new ksid.datetime().getDate("yyyy-mm-dd");

//     $("#search-panel input[name=sDt]").val(sDate);
//     $("#search-panel input[name=eDt]").val(eDate);

}


function searchpanelComboAjaxAfterDoQuery() {
    $("#search-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#search-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

    $("#search-panel input[name=userNm]").focus();
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

    var url = "${pageContext.request.contextPath}/registration/userservicecancel/list";
    ksid.net.ajaxJqGrid(grid1, url, params, function(result) {

        grid2.initGridData();
        grid3.initGridData();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace(
                    CommonJs.setMsgLanguage("사용자 목록 <strong>{0}</strong>건이 조회 되었습니다.")
                                          , "{0}", result.resultData.length));
        }
    });
}

/*****************************************************
* 함수명 : 사용자 서비스 내역 조회
* 설명   :
*****************************************************/
function doSearchService() {

    var params = grid1.clickedRowData;

    var url = "${pageContext.request.contextPath}/registration/userservicecancel/list2";
    ksid.net.ajaxJqGrid(grid2, url, params, function(result) {
    });

}

function doSearchUser() {

    var params = grid1.clickedRowData;

    var url = "${pageContext.request.contextPath}/registration/userservicecancel/list3";
    ksid.net.ajaxJqGrid(grid3, url, params, function(result) {
    });

}

function doPayCancel() {

    if(grid3.clickedRowData == null) {
        ksid.ui.alert('서비스 결제 내역에서 승인취소할 서비스를 선택하세요');
        return;
    }

    if( grid3.clickedRowData.payCancelFg == 'N' ) {
        ksid.ui.alert('해당 결제내역은 취소가능한 상태가 아닙니다.');
        return;
    }

    ksid.ui.confirm('선택하신 결제내역( ' + grid3.clickedRowData.servNm + '-'  + grid3.clickedRowData.payCancelableYn + ' ) 을 승인취소 하시겠습니까?', function() {

        var gridData = $.extend({}, grid1.clickedRowData, grid3.clickedRowData);
        gridData.telNo = gridData.mpNo;
        var arrTelNo = ksid.string.formatTelNo(gridData.telNo).split('-');
        gridData.spNo = arrTelNo[0];
        gridData.kookBun = arrTelNo[1];
        gridData.junBun = arrTelNo[2];
        gridData.goodsName = gridData.servNm;

        ksid.form.bindPanel('form1', gridData);

        //ksid.debug.printObj(ksid.form.flushPanel('form1'));

        if( ksid.form.validateForm('form1') ) {

            $("#form1").attr('action', '${pageContext.request.contextPath}/cnspaycancel/request');
            $("#form1").attr('target', 'winPayCancel');

            var payCancelWin = ksid.ui.openWindow('', 'winPayCancel', 620, 680);

            $("#form1").submit();

            payCancelWin.focus();

        }

    })

}


</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">고객관리</span> > <span name="menu">사용자서비스취소</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
<!--             <dl> -->
<!--                 <dt class="width80">가입기간</dt> -->
<!--                 <dd> -->
<!--                     <input type="text" name="sDt" title="조회시작일자" class="style-input width80" format="date" /> -->
<!--                     ~ -->
<!--                     <input type="text" name="eDt" title="조회종료일자" class="style-input width80" format="date" /> -->
<!--                 </dd> -->
<!--             </dl> -->
            <dl>
                <dt class="width80">서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" codeGroupCd="SP_CD" overall="전체" selected_value=""></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" codeGroupCd="CUST_ID" overall="전체" selected_value=""></select>
                </dd>
                <dt>사용자명</dt>
                <dd>
                    <input type="text" name="userNm" title="사용자명" class="style-input width110" command="doQuery()" />
                </dd>
                <dt>학번</dt>
                <dd>
                    <input type="text" name="custUserNo" title=학번" class="style-input width110" command="doQuery()" />
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
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <div class="variableWrapCode">
        <div class="fLeft">
            <h3 class="style-title"><span name="title">서비스가입 사용자 목록 리스트</span></h3>
            <div class="edit-panel">
                <div id="grid1_pager" class="pager"></div>
                <table id="grid1"></table>
                <!--  button bar  -->
             </div>
        </div>

        <div class="fRight">
            <div class="style-title-wrap">
            <h3 class="style-title"><span name="title">사용자 서비스 내역</span></h3>
            </div>
            <table id="grid2" resize="false"></table>
            <div class="style-title-wrap bottom50Percentage">
                <h3 class="style-title"><span name="title">사용자 결제 내역</span></h3>
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="D" onclick="doPayCancel()">결제취소</button>
                </div>
            </div>
            <table id="grid3" ></table>
        </div>


    </div>

</div>

<form id="form1" name="form1" method="post" action="popup url" target="popup_window">

<input type="hidden" name="payTid" title="거래 ID" required />
<input type="hidden" name="payMid" title="가맹점 ID" required />

<input type="hidden" name="spCd" title="서비스제공자코드" required />
<input type="hidden" name="custId" title="고객사아이디" required />
<input type="hidden" name="servId" title="서비스아이디" required />
<input type="hidden" name="userId" title="사용자아이디" required />
<input type="hidden" name="telNo" title="휴대폰번호" required />

<input type="hidden" name="payCancelFg" title="취소구분" required />
<input type="hidden" name="cancelPwd" title="취소비밀번호" required />

<input type="hidden" name="spNo" title="사업자번호" value="${resultData.spNo}" required />
<input type="hidden" name="kookBun" title="국번" value="${resultData.kookBun}" required />
<input type="hidden" name="junBun" title="전번" value="${resultData.junBun}" required />

<input type="hidden" name="goodsName" title="상품명" value="${resultData.servNm}" />
<input type="hidden" name="payCancelAmt" title="취소금액" value="" required />

</form>
