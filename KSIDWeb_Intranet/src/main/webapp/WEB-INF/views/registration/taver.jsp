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
    colModel.push({ label: 'TA버전', name: 'taVer', hidden: true });
    colModel.push({ label: '등록자', name: 'regId', hidden: true });

    colModel.push({ label: 'TA버전', name: 'taVer', format: 'string', width:80 });
    colModel.push({ label: '등록자', name: 'regId', width:60 });
    colModel.push({ label: '변경자', name: 'chgId', width:60 });
    colModel.push({ label: '등록일시', name: 'regDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '변경일시', name: 'chgDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '비고', name: 'remark', format: 'string' , width:200 });

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

    //TA버전 리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    //TA버전 중복체크
    $("#edit-panel input[name='taVer']").blur(function() {
        doCheckTaVer("edit-panel", this);
    });

    //관리자정보 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

    doQuery();
}

/*****************************************************
* 함수명 : TA버전 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_taver_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/registration/taver/selTaverList"
                      , params
                      , function(result) {

        //TA버전 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "TA버전 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : TA버전 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson1.mode = "I";

    // edit-panel에 newJson1를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson1);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson1.mode);

    $("#edit-panel input[name=taVer]").focus();

}

/*****************************************************
* 함수명 : TA버전 중복 조회
* 설명   :
*****************************************************/
function doCheckTaVer(panelId, el) {
    var params = ksid.form.flushPanel("edit-panel");

    // TA버전이 없다면 return
    if(ksid.string.trim(params.taVer) == "") return;

    ksid.net.ajax("${pageContext.request.contextPath}/registration/taver/selTaver", params, function(result) {
//         console.log(result);
        if(result.resultCd == "00" && result.resultData) {
            CommonJs.setStatus( ksid.string.replace( "해당 TA버전[{0}]이 이미 존재합니다.", "{0}", params.taVer ) );
            $(el).val("").focus();
        }
    });
}

/*****************************************************
* 함수명 : TA버전 저장
* 설명   :
*****************************************************/
function doSave() {
    ksid.ui.confirm("TA버전 정보를 저장하시겠습니까?", function() {
        if(ksid.form.validateForm("edit-panel")) {
            var params = ksid.form.flushPanel("edit-panel");

            var url = "";

            if(params.mode == "I") {
                url = "${pageContext.request.contextPath}/registration/taver/insTaver";

            } else if(params.mode == "U") {
                url = "${pageContext.request.contextPath}/registration/taver/updTaver";
            }

            ksid.net.ajax(url, params, function(result) {

                if(result.resultCd == "00") {
                    doQuery(result.resultData);
                } else {
                    CommonJs.setStatus( ksid.string.replace( "해당 TA버전 [{0}]저장 작업이 실패했습니다.", "{0}", params.taVer ) );
                }
            });
        }
    });
}

/*****************************************************
* 함수명 : TA버전정보 삭제
* 설명   :
*****************************************************/
function doDelete() {
    ksid.ui.confirm("선택한 TA버전을 삭제하시겠습니까?", function() {
        var rowId = $("#grid1").getGridParam("selrow");

        if(!rowId) {
            ksid.ui.alert("삭제할 TA버전 행을 선택하세요.");

            return;
        }

        var params = $("#grid1").getRowData(rowId);

        ksid.net.ajax("${pageContext.request.contextPath}/registration/taver/delTaver", params, function(result) {
            if(result.resultCd == "00") {
                doQuery(result.resultData);
            }
        });
    });
}

/*****************************************************
* 함수명 : TA버전목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var excelParams = {
        file_nm         : CommonJs.setMsgLanguage("TA버전목록"),
        param           : {},
        col_model       : grid1.getExcelColModel()

    };

    ksid.net.ajaxExcel("${pageContext.request.contextPath}/registration/taver/excel", excelParams);

}
</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">가입관리</span> > <span name="menu">TA버전관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt><span name="title">TA버전명</span></dt>
                <dd>
                    <input type="text" maxlength="3" name="taVer" title="TA버전명" class="style-input width110" command="doQuery()" />
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
            <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
            <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
<!--             <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button> -->
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->
    <h3 class="style-title"><span name="title">TA버전 정보</span></h3>
    <div id="edit-panel" class="edit-panel">
        <input type="hidden" name="mode" value="I" />
        <div class="styleDlTable">
            <dl>
                <dt name="title" class="title_on width80">TA버전</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="taVer" title="TA버전" class="style-input width110" modestyle="enable" required />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width80">등록자</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="regId" title="등록자" class="style-input width110" modestyle="enable" required />
                </dd>
                <dt name="title" class="title_on width80">변경자</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="chgId" title="변경자" class="style-input width110"  />
                    <!--  <input type="text" maxlength="16" name="chgId" title="변경자" class="style-input width110" modestyle="enable" required /> -->
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">등록일시</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" name="regDtm" title="등록일시" class="style-input width110" modestyle="enable" />
                </dd>
                <dt name="title" class="width80">변경일시</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" name="chgDtm" title="변경일시" class="style-input width110" modestyle="enable" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">비고</dt>
                <dd class="width600">
                    <input type="text" maxlength="200" name="remark" title="비고" class="style-input width580" style="width:590px;"/>
                </dd>
            </dl>
        </div>
    </div>

    <h3 class="style-title"><span name="title">TA버전 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
