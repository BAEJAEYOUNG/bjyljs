<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 요금기준계산항목 정보 json
var newJson1 = {};

// 요금기준계산항목 리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '항목코드', name: 'bsCalcCd', width:80 });
    colModel.push({ label: '항목명칭', name: 'bsCalcNm', width:120 });
    colModel.push({ label: '사용여부', name: 'useFlagNm', width:70 });
    colModel.push({ label: '사용여부', name: 'useFlag', hidden:true });
    colModel.push({ label: '시작일', name: 'stDtm', width:80 });
    colModel.push({ label: '종료일', name: 'edDtm', width:80 });
    colModel.push({ label: '부가세(%)', name: 'bsVatRt',format:'rate', width:80 });
    colModel.push({ label: '절산단위', name: 'bsCutUnit',format:'number', width:80 });
    colModel.push({ label: '등록자', name: 'regId', width:60 });
    colModel.push({ label: '변경자', name: 'chgId', width:60 });
    colModel.push({ label: '등록일시', name: 'regDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '변경일시', name: 'chgDtm',format: 'dttm' , width:120 });

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

    //요금기준계산항목 리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    //요금기준계산항목 중복체크
    $("#edit-panel input[name='bsCalcCd']").blur(function() {
        doCheckCalcCd(this);
    });

    //요금기준계산항목 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

    doQuery();
}


/*****************************************************
* 함수명: 항목코드 중복 조회
* 설명   :
*****************************************************/
function doCheckCalcCd(el) {
    var params = ksid.form.flushPanel("edit-panel");

    // 서비스제공자id 가 없다면 return
    if(ksid.string.trim(params.bsCalcCd) == "") return;

    ksid.net.ajax("${pageContext.request.contextPath}/registration/billcalcitem/selBillCalcItem", params, function(result) {
        if(result.resultCd == "00" && result.resultData) {
            if( params.mode == 'I' || ( params.mode == 'U' && grid1.clickedRowData.bsCalcCd != params.bsCalcCd ) ) {
                CommonJs.setStatus( ksid.string.replace( "해당 요금기준계산항목의 항목코드[{0}]가 이미 존재합니다.", "{0}", params.bsCalcCd) );
                $(el).val("").focus();
            }
        } else {
            CommonJs.setStatus("입력 가능한 항목코드 입니다.");
        }

    });
}


/*****************************************************
* 함수명 : 요금기준계산항목 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/registration/billcalcitem/selBillCalcItemList"
                      , params
                      , function(result) {

        //TA버전 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "요금기준계산항목 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : 요금기준계산항목 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson1.mode = "I";

    // edit-panel에 newJson1를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson1);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson1.mode);

    $("#edit-panel input[name=bsCalcCd]").focus();

}


/*****************************************************
* 함수명 : TA버전 저장
* 설명   :
*****************************************************/
function doSave() {
    ksid.ui.confirm("요금기준계산항목 정보를 저장하시겠습니까?", function() {
        if(ksid.form.validateForm("edit-panel")) {
            var params = ksid.form.flushPanel("edit-panel");

            var url = "";

            if(params.mode == "I") {
                url = "${pageContext.request.contextPath}/registration/billcalcitem/insBillCalcItem";

            } else if(params.mode == "U") {
                url = "${pageContext.request.contextPath}/registration/billcalcitem/updBillCalcItem";
            }

            ksid.net.ajax(url, params, function(result) {

                if(result.resultCd == "00") {
                    doQuery(result.resultData);
                } else {
                    CommonJs.setStatus( ksid.string.replace( "해당 요금기준계산항목 [{0}]저장 작업이 실패했습니다.", "{0}", params.bsCalcCd ) );
                }
            });
        }
    });
}

/*****************************************************
* 함수명 : 요금기준계산항목 정보 삭제
* 설명   :
*****************************************************/
function doDelete() {
    ksid.ui.confirm("선택한 요금기준계산항목을 삭제하시겠습니까?", function() {
        var rowId = $("#grid1").getGridParam("selrow");

        if(!rowId) {
            ksid.ui.alert("삭제할 TA버전 행을 선택하세요.");

            return;
        }

        var params = $("#grid1").getRowData(rowId);

        ksid.net.ajax("${pageContext.request.contextPath}/registration/billcalcitem/delBillCalcItem", params, function(result) {
            if(result.resultCd == "00") {
                doQuery(result.resultData);
            }
        });
    });
}

/*****************************************************
* 함수명 : 요금기준계산항목 목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var excelParams = {
        file_nm         : CommonJs.setMsgLanguage("요금기준계산항목목록"),
        param           : {},
        col_model       : grid1.getExcelColModel()

    };

    ksid.net.ajaxExcel("${pageContext.request.contextPath}/registration/billcalcitem/excel", excelParams);

}
</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">고객관리</span> > <span name="menu">요금기준계산항목관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt><span name="title">항목코드</span></dt>
                <dd>
                    <input type="text" maxlength="8" name="bsCalcCd" title="항목코드" class="style-input width110" command="doQuery()" />
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
    <h3 class="style-title"><span name="title">요금기준계산항목 정보</span></h3>
    <div id="edit-panel" class="edit-panel">
        <input type="hidden" name="mode" value="I" />
        <div class="styleDlTable">
            <dl>
                <dt name="title" class="title_on width80">항목코드</dt>
                <dd class="width130">
                    <input type="text" maxlength="8" name="bsCalcCd" title="항목코드" class="style-input width110" modestyle="enable" required />
                </dd>
                <dt name="title" class="title_on width80">항목명칭</dt>
                <dd class="width130">
                    <input type="text" maxlength="50" name="bsCalcNm" title="항목명칭" class="style-input width150" required />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width80">사용여부</dt>
                <dd class="width130">
                    <select name="useFlag" title="사용여부" class="style-select" codeGroupCd="USE_YN"  modestyle="enable" style="width:110px;" required></select>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width80">시작일</dt>
                <dd class="width130">
                    <input type="text" maxlength="8" name="stDtm" title="시작일" class="style-input width80" to="edDtm" format="date" required />
                </dd>
                <dt name="title" class="title_on width80">종료일</dt>
                <dd class="width130">
                    <input type="text" maxlength="8" name="edDtm" title="종료일" class="style-input width80" from="stDtm" format="date" required />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width80">부가세(%)</dt>
                <dd class="width130">
                    <input type="text" maxlength="8" name="bsVatRt" title="부가세" class="style-input width110" format="rate" required/>
                </dd>
                <dt name="title" class="title_on width80">절산단위</dt>
                <dd class="width130">
                    <input type="text" maxlength="6" name="bsCutUnit" title="절산단위" class="style-input width110" format="number" required/>
                </dd>
                <dt name="title" class="width250">(-2:십단위, -1:원단위, 0:소수점 1자리)</dt>
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
        </div>
    </div>

    <h3 class="style-title"><span name="title">요금기준계산항목 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
