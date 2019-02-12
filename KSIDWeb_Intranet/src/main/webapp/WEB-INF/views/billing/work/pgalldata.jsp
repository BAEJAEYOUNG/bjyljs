<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// PG 결제전체 처리 데이터정보 json
var newJson1 = {};

// PG 결제전체 처리 데이터리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label:'결제일시', name:'udrDtm', format:'dttm', width:120 });
    colModel.push({ label:'서비스제공자', name:'spNm', format:'string', width:100});
    colModel.push({ label:'고객사', name:'custNm', format:'string', width:100});
    colModel.push({ label:'서비스명', name:'servNm', format:'string', width:130});
    colModel.push({ label:'사용자명', name:'userNm', format:'string', width:80});
    colModel.push({ label:'학번/사번', name:'custUserNo', format:'string', width:80});
    colModel.push({ label:'휴대폰번호', name:'telNo', format:'tel_no', width:100});
    colModel.push({ label:'결제명령', name:'rstPayCmdNm', width:70 });
    colModel.push({ label:'결제결과', name:'rstResultMsg', width:100 });
    colModel.push({ label:'결제수단', name:'rstPayMethodNm', width:70 });
    colModel.push({ label:'결제금액', name:'rstPayAmt', format:'number', width:70 });
    //colModel.push({ label:'승인일자', name:'rstAuthDtm', format:'dttm', width:120 });
    colModel.push({ label:'승인번호', name:'rstAuthCd', width:70 });
    colModel.push({ label:'카드사', name:'rstCardNm', width:70 });
    colModel.push({ label:'할부개월', name:'rstCardQuota', width:60 });
    //colModel.push({ label:'은행코드', name:'rstBankCd', width:60 });
    colModel.push({ label:'은행명', name:'rstBankNm', width:60 });
    colModel.push({ label:'가맹점 ID', name:'rstPayMid', width:80 });
    colModel.push({ label:'거래ID', name:'rstPayTid', width:220 });
    //colModel.push({ label:'주문번호', name:'rstPayOid', width:120 });

    colModel.push({ label:'서비스제공자코드', name:'spCd', hidden:true});
    colModel.push({ label:'고객사 ID', name:'custId', hidden:true});
    colModel.push({ label:'서비스아이디', name:'servId', hidden:true});
    colModel.push({ label:'사용자', name:'userId', hidden:true});
    colModel.push({ label:'결제명령', name:'rstPayCmd', hidden:true });
    colModel.push({ label:'결제결과', name:'rstResultCd', hidden:true});
    colModel.push({ label:'결제수단', name:'rstPayMethod', hidden:true});


    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;

    gridProp.loadComplete = function() {

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

            if (gridData[i].rstResultCd == '3001' || gridData[i].rstResultCd == '4000' || gridData[i].rstResultCd == '4100'
                || gridData[i].rstResultCd == '2001' || gridData[i].rstResultCd == '2002' || gridData[i].rstResultCd == '2211') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'rstResultMsg', '', cssBlue);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'rstResultMsg', '', cssRed);
            }

            if (gridData[i].rstCardQuota.length > 0) {
                if (gridData[i].rstCardQuota == '00') {
                    $("#grid1").jqGrid('setRowData', ids[i], {rstCardQuota:"일시불"});
                } else {
                    var monVal = parseInt(gridData[i].rstCardQuota) + "개월";
                    $("#grid1").jqGrid('setRowData', ids[i], {rstCardQuota:monVal});
                }
            }
        }

    };


    //PG 결제전체 처리 데이터 리스트 그리드 생성
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

        params.custId = $("#search-panel select[name=custId] option:selected").val();
        var combo = $("#search-panel select[name=servId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/servIdList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

    //고객사 선택
    $("#search-panel select[name=custId]").change(function() {

        var params = {};
        params.spCd = $("#search-panel select[name=spCd] option:selected").val();
        params.custId = $(this).val();
        var combo = $("#search-panel select[name=servId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/servIdList", params);

    });

    $("#search-panel input[name=userNm]").focus();

}


/*****************************************************
* 함수명 : PG 결제전체 처리 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);
}


/*****************************************************
* 함수명 : PG 결제전체 처리 목록 페이징 조회
* 설명   :
*****************************************************/
function doQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/work/pgalldata/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus( ksid.string.replace( "PG 결제전체 처리 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : PG 결제전체 처리 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/billing/work/pgalldata/excel";
    var fileNm = "PG결제전체처리내역";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);
}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">작업관리</span> > <span name="menu">PG 결제전체 처리 내역</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt class="width80">조회기간</dt>
                <dd>
                    <input type="text" name="sDt" title="조회시작일자" class="style-input width80" to="eDt" format="date" required />
                    ~
                    <input type="text" name="eDt" title="조회종료일자" class="style-input width80" from="sDt" format="date" required />
                </dd>
                <dd style="width:20px;"></dd>
                <dt>사용자명</dt>
                <dd>
                    <input type="text" name="userNm" title="사용자명" class="style-input width110" command="doQuery()" />
                </dd>
                <dt>학번</dt>
                <dd>
                    <input type="text" name="custUserNo" title="학번" class="style-input width110" command="doQuery()" />
                </dd>
                <dt>휴대폰번호</dt>
                <dd>
                    <input type="text" name="mpNo" title="휴대폰번호" class="style-input width110" command="doQuery()" />
                </dd>
            </dl>
            <dl>
                <dt>서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width130" overall="전체" codeGroupCd="SP_CD"></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width130" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
                <dt>서비스선택</dt>
                <dd>
                    <select name="servId" title="서비스선택" class="style-select width200" overall="전체" codeGroupCd="SERV_ID"></select>
                </dd>
                <dt>승인/취소 결과</dt>
                <dd>
                     <select name="rstResultCd" title="승인/취소 결과" class="style-select width110" overall="전체" codeGroupCd="PAY_RESULT" selected_value=""></select>
                </dd>
                <dt>결제수단</dt>
                <dd>
                     <select name="payMethod" title="결제수단" class="style-select width110" overall="전체" codeGroupCd="PAY_METHOD" selected_value=""></select>
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

    <h3 class="style-title"><span name="title">PG 결제전체 처리 데이터 목록(승인/취소)</span></h3>
    <!-- grid -->
    <div id="grid1_pager" class="pager"></div>
    <table id="grid1"></table>
    <!--// grid -->
</div>
