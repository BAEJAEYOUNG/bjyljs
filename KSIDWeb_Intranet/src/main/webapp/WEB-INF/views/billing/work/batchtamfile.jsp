<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// TAM CCI Report 파일 데이터정보 json
var newJson1 = {};

// TAM CCI Report 파일 데이터리스트 grid
var grid1 = null;

//TYL_CODE 테이블에 CODE_GROUP_CD = 'SYS_URL'에 정의했음.  (SERVER, PC)
var serverIp="https://192.168.2.100:8443/";


//데이트 포멧
function dateToYYYYMMDD(date){
    function pad(num) {
        num = num + '';
        return num.length < 2 ? '0' + num : num;
    }
    return date.getFullYear() + '-' + pad(date.getMonth()+1) + '-' + pad(date.getDate());
}


/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label:'파일명', name:'fileNm', format:'string', width:250 });
    colModel.push({ label:'파일크기(Bytes)', name:'fileSz', format:'number',  width:140 });
    colModel.push({ label:'파일생성일시', name:'fileDtm', format:'dttm', width:140 });
    colModel.push({ label:'작업여부', name:'batchFgNm', width:100 });
    colModel.push({ label:'정산월', name:'billMonth', format:'ym',  width:100 });
    colModel.push({ label:'파일유효성', name:'fileChkNm', width:100 });
    colModel.push({ label:'파일수집일시', name:'gtrDtm', format:'dttm',  width:140 });

    colModel.push({ label:'작업여부', name:'batchFg', hidden:true});
    colModel.push({ label:'파일유효성', name:'fileChk', hidden:true});

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);

        var rowData = grid1.clickedRowData;
        var billMonth = ksid.string.formatYm(rowData.billMonth);
        $('#search-panel input[name=billMonth]').val(billMonth);
    }

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
            if (gridData[i].batchFg == 'Y') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'batchFgNm', '', cssBlue);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'batchFgNm', '', cssRed);
            }

            if (gridData[i].fileChk != 'Y') {
                $('#grid1').jqGrid('setCell', ids[i], 'fileChkNm', '', cssRed);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'fileChkNm', '', cssBlue);
            }
        }
    };
    //TAM CCI Report 파일 리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

}

function searchpanelComboAjaxAfterDoQuery() {

    var params = {};
    var combo = $("#search-panel select[name=sysUrl]");
    ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/getSysUrl", params);
    serverIp = $("#search-panel select[name=sysUrl] option:selected").text().trim();

    var params = {};
    var combo = $("#search-panel select[name=fileDirNm]");
    ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/work/batchtamfile/tamFileDirList", params);

    var eMonth = new ksid.datetime().getDate("yyyy-mm");
    $("#search-panel input[name=billMonth]").val(eMonth);
}

/*****************************************************
* 함수명 : TAM CCI Report 파일 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    var filePath = $("#search-panel select[name=fileDirNm] option:selected").text();
    params.fileDir = filePath;
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/billing/work/batchtamfile/fileList"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus( ksid.string.replace( "TAM CCI Report 파일 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : TAM CCI Report 파일 목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var rownum =  $("#grid1").getGridParam("records");
    if (rownum == 0) {
        ksid.ui.alert("조회된 데이터가 없습니다!!!");
        return;
    }

    var url = "${pageContext.request.contextPath}/billing/work/batchtamfile/excel";
    var fileNm = "TAM_CCI_Report_목록";

    ksid.net.ajaxExcelGrid(url, fileNm, grid1);

}


//TAM CCI Report 파일(월)
function doTamFileToDB() {

    if(grid1.clickedRowData == null) {
        ksid.ui.alert("선택한 TAM CCI Report 파일이 없습니다.<br />DB 저장할 파일을 선택하세요");
        return;
    }

    //TAM 파일작업은 해당 파일일자로 작업함
    var params = ksid.form.flushPanel('search-panel');
    params.fileDir  = $("#search-panel select[name=fileDirNm] option:selected").text();
    params.csvFile  = grid1.clickedRowData.fileNm;
    params.svcMonth = grid1.clickedRowData.billMonth;
    if(params.svcMonth.length < 6)
        params.svcMonth = $('#search-panel input[name=billMonth]').val();

    if(params.svcMonth.length < 6) {
        ksid.ui.alert("해당 TAM CCI 파일의 정산월을 입력하세요. [yyyymm]");
        $('#search-panel input[name=billMonth]').focus();
        return;
    }

    var tmpDate='';
    for (var i=0, max=params.svcMonth.length; i < max; i++) {
        if (params.svcMonth[i] >= '0' && params.svcMonth[i] <= '9')
            tmpDate = tmpDate + params.svcMonth[i];
    }
    params.svcMonth = tmpDate;

    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));

    var url;
    var msg1, msg2;
    url  = serverIp + 'bill/batchfile/tamcci/batch';
    msg1 = "해당 TAM CCI Report 파일의 DB저장 작업을 실행하시겠습니까?" + "\n\n정산월: " + params.svcMonth + "\nTAM파일: " + params.csvFile;
    msg2 = ksid.string.replace( "선택한 TAM CCI Report 파일[{0}]의 DB저장 작업을 완료했습니다.", "{0}", params.csvFile );

    ksid.ui.confirm(msg1, function() {
        $("#formBatch").attr("action", url);
        $("#formBatch").submit();
        doQuery(msg2);
        //CommonJs.setStatus(msg2);
    });

}


//TAM TA 정산작업(월)
function doTamAcctMonth() {

    if(grid1.clickedRowData == null) {
        ksid.ui.alert("선택한 TAM CCI Report 파일이 없습니다.<br />DB 저장할 파일을 선택하세요");
        return;
    }

    //TAM 파일작업은 해당 파일일자로 작업함
    var params = ksid.form.flushPanel('search-panel');
    params.svcMonth = grid1.clickedRowData.billMonth;
    if(params.svcMonth.length < 6)
        params.svcMonth = $('#search-panel input[name=billMonth]').val();

    if(params.svcMonth.length < 6) {
        ksid.ui.alert("해당 TAM CCI 파일의 정산월을 입력하세요. [yyyymm]");
        $('#search-panel input[name=billMonth]').focus();
        return;
    }

    var tmpDate='';
    for (var i=0, max=params.svcMonth.length; i < max; i++) {
        if (params.svcMonth[i] >= '0' && params.svcMonth[i] <= '9')
            tmpDate = tmpDate + params.svcMonth[i];
    }
    params.svcMonth = tmpDate;

    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));

    var url;
    var msg1, msg2;
    url  = serverIp + 'bill/settle/tamsettle/batch';
    msg1 = "해당 TAM TA 정산 작업을 실행하시겠습니까?" + "\n\n정산월: " + params.svcMonth;
    msg2 = ksid.string.replace( "선택한 TAM TA 정산 작업을 완료했습니다. 정산월[{0}]", "{0}", params.svcMonth );

    ksid.ui.confirm(msg1, function() {
        $("#formBatch").attr("action", url);
        $("#formBatch").submit();
        CommonJs.setStatus(msg2);
    });

}


</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">작업관리</span> > <span name="menu">TAM CCI Report 파일 배치</span></p>
    </div>

    <div id="batch-panel">
    <form id="formBatch" action="" target="frmBatch" method="POST">
        <input type="hidden" name="svcDate" />
        <input type="hidden" name="svcMonth" />
        <input type="hidden" name="jobSeq" />
        <input type="hidden" name="fileDir" />
        <input type="hidden" name="csvFile" />
    </form>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title"><label for="">요청서버</label></dt>
                <dd>
                    <select class="style-select" style="width:180px;"  name="sysUrl" title="요청서버" codeGroupCd="SYS_URL" required> </select>
                </dd>
                <dt name="title"><label for="">작업디렉토리</label></dt>
                <dd>
                    <select class="style-select" style="width:300px;" name="fileDirNm" title="작업디렉토리" codeGroupCd="BATCH_DIR" required> </select>
                </dd>
                <dt name="title"><label for="">정산월</label></dt>
                <dd>
                    <input name="billMonth" type="text" format="ym" class="style-input width60" title="대사월" required />
                </dd>
            </dl>
            <dl style="display: none;">
                <dt name="title"><label for="">작업결과</label></dt>
                <dd style="width:600px;">
                    <iframe id="frmBatch" name="frmBatch" src="" title="batch" style="width:100%; height:40px; border:1px solid #000"></iframe>
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">파일조회</button>
            <button type="button" class="style-btn" auth="P" onclick="doTamFileToDB()">TAM 파일 DB 저장(월)</button>
            <button type="button" class="style-btn" auth="P" onclick="doTamAcctMonth()">TAM TA 정산(월)</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <h3 class="style-title"><span name="title">TAM CCI Report 파일 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->

</div>
