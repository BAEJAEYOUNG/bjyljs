<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>


<script type="text/javascript" language="javascript">


/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label:'파일아이디', name:'fileId', hidden:true });
    colModel.push({ label:'파일명', name:'logicalFileNm', format:'string', width:300 });
    colModel.push({ label:'저장위치', name:'filePath', format:'string', width:250 });
    colModel.push({ label:'파일크기(Bytes)', name:'fileSize', format:'number',  width:140 });
    colModel.push({ label:'파일생성일시', name:'regDtm', format:'dttm', width:140 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.multiselect = true;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);
    }

    gridProp.loadComplete = function() {

        // 그리드 데이터의 ID 가져오기
        var ids = $('#grid1').jqGrid('getDataIDs');


        for(var i=0;i < ids.length; i++){

            var rowId = ids[i];

            var rowData = $("#grid1").getRowData(rowId);

            var fileNmLink = rowData.logicalFileNm + '&nbsp;&nbsp;<a title="파일을 다운로드 합니다" href="javascript:doDownload(\'' + rowData.fileId + '\')"><img src="' + imagePath + '/ksid/download.png" style="width:17px; height:17px;" /></a>'

            $('#grid1').jqGrid('setCell', rowId, 'logicalFileNm', fileNmLink);

        }

    };
    //TAM CCI Report 파일 리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var sDate = new ksid.datetime().before(0,0,7).getDate("yyyy-mm-dd");
    var eDate = new ksid.datetime().getDate("yyyy-mm-dd");

    $("#search-panel input[name=sDt]").val(sDate);
    $("#search-panel input[name=eDt]").val(eDate);

 }

function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel select[name=batchTp]").change(function() {

        setTimeout(function(){
            doQuery();
        }, 100);

    });

    doQuery();

}

// 조회
function doQuery(resultMsg) {

    var params = ksid.form.flushPanel('search-panel');

    params.fileOwnerCd = "batchfile";           // 파일소유코드(파일을 그룹짓는 값이라 보면된다. 대분류 정도로)
    params.fileOwnerType = "ATTACH";            // 파일소유유형(쉼표로 구분지어 어려 유형을 지정할 수 있다. 각 최종분류 하위의 구분 정도로)
    params.fileOwnerKey1 = params.batchTp;      // 파일소유키(1 ~ 3 까지 구분할 수 있다. 중분류, 소분류, 세분류 정도로)

    console.log('params', params);

    ksid.net.ajaxJqGrid(grid1
                      , "${contextPath}/billing/work/batchfile/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            var batchTpNm = $("#search-panel select[name=batchTp] option:selected").text();
            CommonJs.setStatus(  ksid.string.replace( batchTpNm + " 첨부 파일 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

// 파일업로드
function doUpload() {

    var url = "${contextPath}/common/file/uploader";

    var params = {};

    $("#uploader").load(url, params, function(responseText, textStatus, jqXHR) {

        // upload url
        fnSetUploadURL("/billing/work/batchfile/upload");

        // 파일 이외의 추가 파라미터
        var params = ksid.form.flushPanel('search-panel');

        params.fileOwnerCd = "batchfile";           // 파일소유코드(파일을 그룹짓는 값이라 보면된다. 대분류 정도로)
        params.fileOwnerType = "ATTACH";            // 파일소유유형(쉼표로 구분지어 어려 유형을 지정할 수 있다. 각 최종분류 하위의 구분 정도로)
        params.fileOwnerKey1 = params.batchTp;      // 파일소유키(1 ~ 3 까지 구분할 수 있다. 중분류, 소분류, 세분류 정도로)

        fnSetJsonParam(params);

        fnCallBack(function() {

            closeWindow();

            doQuery("upload success !!");

        });

    }).dialog({
          title : "파일첨부"
        , modal : true
        , autoOpen : false
        , width : 416
        , height : 500
    });

}



// 파일삭제
function doDelete() {

    var selectedIds = $("#grid1").getGridParam("selarrrow");

    if( selectedIds.length == 0 ) {

        ksid.ui.alert("선택한 파일이 없습니다. 삭제할 파일을 선택하세요");
        return;

    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {

        var selectedData = $("#grid1").getRowData(selectedIds[i]);

        var params_list_01 = {};

        params_list_01.fileId = selectedData.fileId;

        params.push(params_list_01);

    }

    //  ksid.debug.printObj("params", params);

    ksid.ui.confirm( "선택하신 파일을 삭제하시겠습니까??" , function() {

      ksid.net.ajax("${contextPath}/billing/work/batchfile/delete", JSON.stringify(params), function(result) {

          if(result.resultCd == "00") {
              doQuery(result.resultData);
          } else {
              CommonJs.setStatus(result.resultData);
          }

      }, {contentType:"application/json; charset=UTF-8"});


    });

}

// 파일다운로드
function doDownload(fileId) {

    var params = ksid.form.flushPanel('search-panel');

    $("#frm_download").attr("src", "${contextPath}/billing/work/batchfile/download?fileOwnerCd=batchfile&fileOwnerType=ATTACH&fileOwnerKey1=" + params.batchTp + "&fileId=" + fileId);
}

</script>



<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">작업관리</span> > <span name="menu">배치파일관리</span></p>
    </div>

    <!-- 검색조건 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title"><label for="">파일생성일자</label></dt>
                <dd>
                    <input type="text" name="sDt" title="조회시작일자" class="style-input width80" to="eDt" format="date" required />
                    ~
                    <input type="text" name="eDt" title="조회종료일자" class="style-input width80" from="sDt" format="date" required />
                </dd>
                <dt name="title"><label for="">배치유형</label></dt>
                <dd>
                    <select class="style-select" style="width:100px;" name="batchTp" title="배치유형" codeGroupCd="BATCH_TP"></select>
                </dd>
                <dt name="title"><label for="">파일명</label></dt>
                <dd>
                    <input type="text" name="logicalFileNm" title="파일명" class="style-input width110" command="doQuery()" />
                </dd>
            </dl>
        </div>

        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="D" onclick="doUpload()">파일첨부</button>
            <button type="button" class="style-btn" auth="D" onclick="doDelete()">선택파일삭제</button>
        </div>

    </div>
    <!-- 검색조건 끝 -->

    <h3 class="style-title"><span name="title">배치 첨부 파일 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->

</div>
<div id="uploader"></div>

