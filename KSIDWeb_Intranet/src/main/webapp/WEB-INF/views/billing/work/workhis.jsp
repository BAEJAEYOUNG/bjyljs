<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 작업이력 데이터정보 json
var newJson1 = {};

// 작업이력 데이터리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '작업일시', name: 'reqDtm', format: 'dttm', width:120 });
    colModel.push({ label: '작업구분명', name: 'jobTypeNm', width:100 });
    colModel.push({ label: '작업코드명', name: 'jobCdNm', format:'string', width:200 });
    //colModel.push({ label: '작업 명칭', name: 'jobNm', width:200 });
    colModel.push({ label: '선별시작일시', name: 'stDtm', format: 'dttm' , width:120 });
    colModel.push({ label: '선별종료일시', name: 'edDtm', format: 'dttm' , width:120 });
    colModel.push({ label: '작업파라미터', name: 'reqParam', width:110 });
    colModel.push({ label: '작업상태', name: 'statusNm', width:70 });
    colModel.push({ label: '진행율', name: 'progress', format: 'number', align: 'center', width:50 });
    colModel.push({ label: '작업메시지', name: 'jobMsg', align: 'left', width:400 });
    colModel.push({ label: '작업자', name: 'reqId', width:70 });

    colModel.push({ label: '작업상태', name: 'status', hidden:true });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;


    gridProp.loadComplete = function() {

        // 배경색상 css 선언
        var cssGreen = {'background-color':'#6DFF6D'};
        var cssOrange   = {'background-color':'orange'};

        // 그리드 데이터의 ID 가져오기
        var ids = $('#grid1').jqGrid('getDataIDs');

        // 그리드 데이터 가져오기
        var gridData = $("#grid1").jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {
            if (gridData[i].status != 'S') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'statusNm', '', cssOrange);
            } else {
                //$('#grid1').jqGrid('setCell', ids[i], 'statusNm', '', cssGreen);
            }
        }
    };


    //작업이력 데이터 리스트 그리드 생성
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

    $("#search-panel select[name=jobType]").change(function() {

        //var params = {jobType:$(this).val()};
        var params = {
                codeGroupCd:"JOB_CD",
                codeCd:$(this).val()
               };
        var combo = $("#search-panel select[name=jobCd]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/work/workhis/codeComboList", params);

    });

    $("#search-panel select[name=jobType]").trigger("change");

}

/*****************************************************
* 함수명: 작업이력 데이터 목록 조회
* 설명  :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);
}


/*****************************************************
* 함수명: 작업이력 목록 페이징 조회
* 설명  :
*****************************************************/
function doQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/work/workhis/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "작업이력 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 작업이력 데이터목록 엑셀다운로드
* 설명  :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/billing/work/workhis/excel";
    var fileNm = "과금작업이력";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);
}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">작업관리</span> > <span name="menu">과금작업이력</span></p>
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
            </dl>
            <dl>
                <dt class="width80">작업구분</dt>
                <dd>
                     <select name="jobType" title="작업구분" class="style-select width200" overall="전체" codeGroupCd="JOB_TYPE" selected_value=""></select>
                </dd>
                <dt>작업코드</dt>
                <dd>
                    <select name="jobCd" title="작업코드" class="style-select width200" overall="전체" codeGroupCd="JOB_CD"></select>
                </dd>
                <dt class="width80">작업상태</dt>
                <dd>
                     <select name="status" title="작업상태" class="style-select width200" overall="전체" codeGroupCd="STATUS" selected_value=""></select>
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

    <h3 class="style-title"><span name="title">과금 작업이력 데이터 목록</span></h3>
    <!-- grid -->
    <div id="grid1_pager" class="pager"></div>
    <table id="grid1"></table>
    <!--// grid -->
</div>
