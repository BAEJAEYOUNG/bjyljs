<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>



<script type="text/javascript" language="javascript">

// TAM CCI Report 파일 수집 데이터정보 json
var newJson1 = {};

// TAM CCI Report 파일 수집 데이터리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '정산월', name: 'billMonth', format: 'ym', width:70 });
    colModel.push({ label: '파일명', name: 'fileNm', width:160 });
    colModel.push({ label: '파일크기(Bytes)', name: 'fileSz', format: 'number', width:90 });
    colModel.push({ label: '파일라인수', name: 'fileLn', format: 'number', width:70 });
    colModel.push({ label: '파일유효성', name: 'fileChkNm', width:100 });
    colModel.push({ label: '에러메시지', name: 'errMsg', align: 'left', width:270 });
    colModel.push({ label: 'TA신규설치수', name: 'installCnt', format: 'number', width:100 });
    colModel.push({ label: 'TA업데이트수', name: 'updateCnt', format: 'number', width:100 });
    colModel.push({ label: '수집일시', name: 'gtrDtm', format: 'dttm', width:120 });

    colModel.push({ label: '파일유효성', name: 'fileChk', hidden:true });

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
        var gridData = $("#grid1").jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {
            if (gridData[i].fileChk != 'Y') {
                $('#grid1').jqGrid('setCell', ids[i], 'fileChkNm', '', cssRed);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'fileChkNm', '', cssBlue);
            }
        }
    };


    //TAM CCI Report 파일 수집 데이터 리스트 그리드 생성
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


    var sMonth = new ksid.datetime().before(0,3,0).getDate("yyyy-mm");
    var eMonth = new ksid.datetime().getDate("yyyy-mm");
    $("#search-panel input[name=sMonth]").val(sMonth);
    $("#search-panel input[name=eMonth]").val(eMonth);

}

function searchpanelComboAjaxAfterDoQuery() {


}

/*****************************************************
* 함수명 : TAM CCI Report 파일 수집 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);
}


/*****************************************************
* 함수명 : TAM CCI Report 파일 수집 목록 페이징 조회
* 설명   :
*****************************************************/
function doQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    if( params.sMonth.length < 6 || params.eMonth < 6) return;
    var li_date_from = ksid.number.toNumber(params.sMonth);
    var li_date_to = ksid.number.toNumber(params.eMonth);

    if( li_date_from > li_date_to ) {
        ksid.ui.alert( "조회종료월이 조회시작월 보다 크거나 같아야 합니다." );
        return;
    }

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/work/tamfilehis/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "일자별 PG사 대사파일 수집 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : TAM CCI Report 파일 수집 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/billing/work/tamfilehis/excel";
    var fileNm = "TAM_CCI_Report파일수집이력";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);
}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">작업관리</span> > <span name="menu">TAM CCI Report 파일 수집이력</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt class="width80">조회기간</dt>
                <dd>
                    <input name="sMonth" type="text" format="ym" class="style-input width60" title="시작월" required />
                     ~
                    <input name="eMonth" type="text" format="ym" class="style-input width60" title="종료월" required />
                </dd>
                <dd class="width20"></dd>
                <dt class="width80">파일유효성</dt>
                <dd>
                     <select name="fileChk" title="파일유효성" class="style-select width110" overall="전체" codeGroupCd="FILE_CHK" selected_value=""></select>
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

    <h3 class="style-title"><span name="title">TAM CCI Report 파일 수집이력 데이터 목록</span></h3>
    <!-- grid -->
    <div id="grid1_pager" class="pager"></div>
    <table id="grid1"></table>
    <!--// grid -->
</div>
