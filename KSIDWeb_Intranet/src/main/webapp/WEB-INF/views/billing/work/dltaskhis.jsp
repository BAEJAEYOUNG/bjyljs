<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 일/월 마감 데이터정보 json
var newJson1 = {};

// 일/월 마감 데이터리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label:'마감기준일자', name:'jobDate', format:'ymd', width:120 });
    colModel.push({ label:'작업구분명', name:'jobTypeNm', width:100 });
    colModel.push({ label:'작업코드명', name:'jobCdNm', width:200 });
    colModel.push({ label:'작업결과', name:'resultCdNm', width:70 });
    colModel.push({ label:'마감여부', name:'dlFlagNm', width:70 });
    colModel.push({ label:'작업메시지', name:'jobMsg', align:'left', width:400 });
    colModel.push({ label:'작업일시', name:'dlDtm', format:'dttm', width:120 });

    colModel.push({ label:'작업구분명', name:'jobType', hidden:true  });
    colModel.push({ label:'작업코드명', name:'jobCd', hidden:true  });
    colModel.push({ label:'작업결과', name:'resultCd', hidden:true });
    colModel.push({ label:'마감여부', name:'dlFlag', hidden:true });

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
            if (gridData[i].resultCd == 'SUCC') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'resultCdNm', '', cssBlue);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'resultCdNm', '', cssRed);
            }

            if (gridData[i].dlFlag == '1') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'dlFlagNm', '', cssBlue);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'dlFlagNm', '', cssRed);
            }
        }
    };

    //일/월 마감 데이터 리스트 그리드 생성
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
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/work/dltaskhis/codeComboList", params);

    });

    $("#search-panel select[name=jobType]").trigger("change");

}

/*****************************************************
* 함수명 : 일/월 마감 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);
}


/*****************************************************
* 함수명 : 일/월 마감 목록 페이징 조회
* 설명   :
*****************************************************/
function doQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/work/dltaskhis/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "일/월 마감 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : 일/월 마감 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/billing/work/dltaskhis/excel";
    var fileNm = "과금마감자료";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);
}


/*****************************************************
* 함수명 : 일/월 마감 처리 설정
* 설명   :
*****************************************************/
function doSetDlFlagOn() {

    var rowId = $("#grid1").getGridParam("selrow");

    if(!rowId) {
        ksid.ui.alert("마감처리 설정할 행을 선택하세요.");
        return;
    }

    var params = {};

    params.jobDate  = $("#grid1").getRowData(rowId).jobDate;
    var tmpDate='';
    for (var i=0, max=params.jobDate.length; i < max; i++) {
        if (params.jobDate[i] >= '0' && params.jobDate[i] <= '9')
            tmpDate = tmpDate + params.jobDate[i];
    }
    params.jobDate  = tmpDate;
    params.jobType  = $("#grid1").getRowData(rowId).jobType;
    params.jobCd    = $("#grid1").getRowData(rowId).jobCd;
    params.jobType  = $("#grid1").getRowData(rowId).jobType;
    params.resultCd = $("#grid1").getRowData(rowId).resultCd;
    params.dlFlag   = $("#grid1").getRowData(rowId).dlFlag;

    if (params.dlFlag == '1') {
        ksid.ui.alert("현재 마감처리 설정된 데이터 입니다.");
        return;
    }

    ksid.ui.confirm("해당 작업을 마감처리 하시겠습니까?", function() {

        var url = "${pageContext.request.contextPath}/billing/work/dltaskhis/setdlflagon";

        params.dlFlag = '1';
        ksid.net.ajax(url, params, function(result) {

            if(result.resultCd == "00") {
                //doQuery(result.resultData);
                doQueryPaging(result.resultData);
            }

        });
    });

}


/*****************************************************
* 함수명 : 일/월 마감 처리 해제
* 설명   :
*****************************************************/
function doSetDlFlagOff() {

    var rowId = $("#grid1").getGridParam("selrow");

    if(!rowId) {
        ksid.ui.alert("마감처리 해제할 행을 선택하세요.");
        return;
    }

    var params = {};

    params.jobDate  = $("#grid1").getRowData(rowId).jobDate;
    var tmpDate='';
    for (var i=0, max=params.jobDate.length; i < max; i++) {
        if (params.jobDate[i] >= '0' && params.jobDate[i] <= '9')
            tmpDate = tmpDate + params.jobDate[i];
    }
    params.jobDate  = tmpDate;
    params.jobType  = $("#grid1").getRowData(rowId).jobType;
    params.jobCd    = $("#grid1").getRowData(rowId).jobCd;
    params.jobType  = $("#grid1").getRowData(rowId).jobType;
    params.resultCd = $("#grid1").getRowData(rowId).resultCd;
    params.dlFlag   = $("#grid1").getRowData(rowId).dlFlag;

    if (params.dlFlag == '0') {
        ksid.ui.alert("현재 마감처리 해제된 데이터 입니다.");
        return;
    }

    ksid.ui.confirm("해당 작업을 마감해제 하시겠습니까?", function() {

        var url = "${pageContext.request.contextPath}/billing/work/dltaskhis/setdlflagoff";

        params.dlFlag = '0';
        ksid.net.ajax(url, params, function(result) {

            if(result.resultCd == "00") {
                //doQuery(result.resultData);
                doQueryPaging(result.resultData);
            }

        });
    });

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
                <dt class="width60">마감여부</dt>
                <dd>
                     <select name="dlFlag" title="마감여부" class="style-select width100" overall="전체" codeGroupCd="DL_FLAG" selected_value=""></select>
                </dd>
                <dt class="width60">작업결과</dt>
                <dd>
                     <select name="resultCd" title="작업결과" class="style-select width100" overall="전체" codeGroupCd="DL_RESULT_CD" selected_value=""></select>
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
            &nbsp;&nbsp;
            <button type="button" class="style-btn" style="color:blue;" auth="W" onclick="doSetDlFlagOn()">마감처리</button>
            <button type="button" class="style-btn" style="color:red;" auth="W" onclick="doSetDlFlagOff()">마감해제</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <h3 class="style-title"><span name="title">일/월 과금마감 데이터 목록</span></h3>
    <!-- grid -->
    <div id="grid1_pager" class="pager"></div>
    <table id="grid1"></table>
    <!--// grid -->
</div>
