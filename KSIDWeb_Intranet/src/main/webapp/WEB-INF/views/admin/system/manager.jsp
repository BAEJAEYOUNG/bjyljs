<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 관리자정보 json
var newJson1 = {};

// 관리자리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({label: '관리자유형', name: 'adminTpNm', format: 'string' , width:130});
    colModel.push({label: '서비스제공자', name: 'spNm', format: 'string' , width:120});
    colModel.push({label: '고객사', name: 'custNm', format: 'string' , width:120});
    colModel.push({label: '관리자아이디', name: 'adminId', format: 'string' , width:80});
    colModel.push({label: '관리자비밀번호', name: 'adminPw', format: 'string' , width:100});
    colModel.push({label: '관리자명', name: 'adminNm', format: 'string', width:80});
    colModel.push({label: '휴대폰번호', name: 'hpNo', format: 'tel_no' , width:100});
    colModel.push({label: '등록자', name: 'regNm', width:60});
    colModel.push({label: '등록일시', name: 'regDtm', format: 'dttm' , width:120});
    colModel.push({label: '변경자', name: 'chgNm', width:60});
    colModel.push({label: '변경일시', name: 'chgDtm', format: 'dttm' , width:120});

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);

        var rowData = grid1.clickedRowData;
        rowData.mode = "U";

        // edit-panel에 rowData binding 한다.
        ksid.form.bindPanel("edit-panel", rowData);

        // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
        ksid.form.applyModeStyle("edit-panel", rowData.mode);
    };

    //관리자리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();



//     ksid.file.multi_attacher_01 = new ksid.multiAttacher();
//     ksid.file.multi_attacher_01.init({refId:"multi_attacher_01", panelId:"file_upload_01", dialogId:"file_dialog_01", height:60});

//     ksid.file.multi_attacher_01.loadStore({

//         fileOwnerCd:"test001",
//         fileOwnerKey1: 'excel',
//         fileOwnerType: "ATTACH"

//     });




    //관리자 중복체크
    $("#edit-panel input[name='adminId']").blur(function() {
        doCheckAdminId("edit-panel", this);
    });

    doQuery();

    $(window).resize(function() {
        resize();
    });

    resize();
}

function resize() {
    $("#grid_file_upload_01").jqGrid('setGridHeight', 80 );
}

function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#search-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

}

function editpanelComboAjaxAfterDoQuery() {

    $("#edit-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#edit-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#edit-panel select[name=spCd]").trigger("change");

    //관리자정보 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

}

/*****************************************************
* 함수명: 관리자 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/admin/system/manager/list"
                      , params
                      , function(result) {

        //관리자 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "관리자 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 관리자 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson1.mode = "I";

    // edit-panel에 newJson1를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson1);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson1.mode);

    $("#edit-panel input[name=adminId]").focus();

}

/*****************************************************
* 함수명: 관리자 중복 조회
* 설명   :
*****************************************************/
function doCheckAdminId(panelId, el) {
    var params = ksid.form.flushPanel("edit-panel");

    // 관리자id 가 없다면 return
    if(ksid.string.trim(params.adminId) == "") return;

    ksid.net.ajax("${pageContext.request.contextPath}/admin/system/manager/sel", params, function(result) {
//         console.log(result);
        if(result.resultCd == "00" && result.resultData) {
            CommonJs.setStatus( ksid.string.replace( "해당 관리자 아이디[{0}]가 이미 존재합니다.", "{0}", params.adminId ) );
            $(el).val("").focus();
        }
    });
}

/*****************************************************
* 함수명: 관리자 저장
* 설명   :
*****************************************************/
function doSave() {

    ksid.ui.confirm("관리자을 저장하시겠습니까?", function() {
        if(ksid.form.validateForm("edit-panel")) {
            var params = ksid.form.flushPanel("edit-panel");

            var url = "";

            if(params.mode == "I") {
                url = "${pageContext.request.contextPath}/admin/system/manager/ins";

            } else if(params.mode == "U") {
                url = "${pageContext.request.contextPath}/admin/system/manager/upd";
            }

            ksid.net.ajax(url, params, function(result) {

                if(result.resultCd == "00") {
                    doQuery(result.resultData);
                }

            });
        }

//         // 파일저장정보를 세팅한다.
//         ksid.file.multi_attacher_01.config.store = {
//             fileOwnerCd:"test001",
//             fileOwnerKey1: 'excel',
//             fileOwnerType: "ATTACH"
//         };

//         // 파일정보 param 생성 시작(첨부파일 그리드 갯수)
//         var paramFiles = ksid.file.multi_attacher_01.getParamFiles(1);
//         //     console.log('param_files', param_files);

//         var paramsMulti = {};
//         paramsMulti.param = JSON.stringify({"file":paramFiles});

//         ksid.net.file(paramsMulti, function(result){

//             ksid.file.multi_attacher_01.loadStore({
//                 fileOwnerCd:"test001",
//                 fileOwnerKey1: 'excel',
//                 fileOwnerType: "ATTACH"
//             });

//         });
    });



}

/*****************************************************
* 함수명: 관리자 삭제
* 설명   :
*****************************************************/
function doDelete() {
    ksid.ui.confirm("선택한 관리자을 삭제하시겠습니까?", function() {
        var rowId = $("#grid1").getGridParam("selrow");

        if(!rowId) {
            ksid.ui.alert("삭제할 관리자 행을 선택하세요.");

            return;
        }

        var params = $("#grid1").getRowData(rowId);

        ksid.net.ajax("${pageContext.request.contextPath}/admin/system/manager/del", params, function(result) {
            if(result.resultCd == "00") {
                doQuery(result.resultData);
            }
        });
    });
}

/*****************************************************
* 함수명: 관리자목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var excelParams = {
        file_nm         : CommonJs.setMsgLanguage("관리자목록"),
        param           : {},
        col_model       : grid1.getExcelColModel()

    };

    ksid.net.ajaxExcel("${pageContext.request.contextPath}/admin/system/manager/excel", excelParams);

}
</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">시스템</span> > <span name="menu">관리자관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt>관리자유형</dt>
                <dd>
                    <select name="adminTp" title="관리자유형" class="style-select width150" codeGroupCd="ADMIN_TP" overall="전체"></select>
                </dd>
                <dt>서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" overall="전체" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
                <dt><span name="title">관리자아이디/명</span></dt>
                <dd>
                    <input type="text" maxlength="3" name="adminId" title="관리자아이디/명" class="style-input width110" command="doQuery()" />
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
            <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
            <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->
    <h3 class="style-title"><span name="title">관리자 정보</span></h3>
    <div id="edit-panel" class="edit-panel">
        <input type="hidden" name="mode" value="I" />
        <div class="styleDlTable">
            <dl>
                <dt class="title_on width80"">관리자유형</dt>
                <dd>
                    <select name="adminTp" title="관리자유형" class="style-select width150" codeGroupCd="ADMIN_TP" selected_value="T"></select>
                </dd>
                <dt class="width80">서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" overall="전체" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width80">관리자아이디</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="adminId" title="관리자아이디" class="style-input width110" modestyle="enable" required />
                </dd>
                <dt name="title" class="title_on width80">비밀번호</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="adminPw" title="비밀번호" class="style-input width110" required />
                </dd>
                <dt name="title" class="title_on width80">관리자명</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="adminNm" title="관리자명" class="style-input width110" required />
                </dd>
                <dt name="title" class="title_on width80">휴대폰번호</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" name="hpNo" title="휴대폰번호" class="style-input width110" format="tel_no" command="doSave()" />
                </dd>
            </dl>
        </div>
    </div>

    <h3 class="style-title"><span name="title">관리자 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->

<!--     <section id="file_01"> -->

<!--         <div id="file_upload_01" ></div> -->
<!--         <div id="file_dialog_01" title="파일첨부" class="pop_cnt" style="overflow:hidden"></div> -->

<!--     </section> -->

</div>
