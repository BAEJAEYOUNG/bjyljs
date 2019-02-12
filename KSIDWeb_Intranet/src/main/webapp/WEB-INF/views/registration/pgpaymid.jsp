<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// PG사 가맹점 정보 json
var newJson1 = {};

// PG사 가맹점 정보 리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: 'PG사코드', name: 'pgCd', format: 'string', width:70 });
    colModel.push({ label: 'PG사명', name: 'pgNm', format: 'string', width:120 });
    colModel.push({ label: '가맹점 ID', name: 'payMid', width:100 });
    colModel.push({ label: '가맹점명(kor)', name: 'midKorNm', width:100 });
    colModel.push({ label: '가맹점명(eng)', name: 'midEngNm', width:100 });
    colModel.push({ label: '상점 고유 IP', name: 'midIpaddr', width:100 });
    colModel.push({ label: '결제상품명', name: 'goodsNm', width:100 });
    colModel.push({ label: '취소비밀번호', name: 'cancelPwd', width:100 });
    colModel.push({ label: '취소가능기간', name: 'cancelDay', format: 'number', width:100 });
    colModel.push({ label: '부분취소금액', name: 'cancelAmt', format: 'number', width:100 });
    colModel.push({ label: '인증요청용(EncKey)', name: 'encKey', width:100 });
    colModel.push({ label: '인증요청용(HashKey)', name: 'hashKey', width:100 });
    colModel.push({ label: '상점키', name: 'midKey', width:100 });
    colModel.push({ label: '변경자', name: 'chgId', width:60 });
    colModel.push({ label: '등록일시', name: 'regDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '변경일시', name: 'chgDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '등록자', name: 'regId', hidden: true });

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

    //PG사 가맹점 리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    //PG사 가맹점 중복체크
    $("#edit-panel input[name='payMid']").blur(function() {
        doCheckPgPayMid("edit-panel", this);
    });

    //관리자정보 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

    doQuery();
}

/*****************************************************
* 함수명 : PG사 가맹점 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/registration/pgpaymid/selPgPayMidList"
                      , params
                      , function(result) {

        //PG사 가맹점 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "PG사 가맹점 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : PG사 가맹점 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson1.mode = "I";

    // edit-panel에 newJson1를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson1);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson1.mode);

    $("#edit-panel select[name=pgCd]").focus();

}

/*****************************************************
* 함수명 : PG사 가맹점 중복 조회
* 설명   :
*****************************************************/
function doCheckPgPayMid(panelId, el) {
    var params = ksid.form.flushPanel("edit-panel");

    // PG사가 없다면 return
    if(ksid.string.trim(params.pgCd) == "") return;
    if(ksid.string.trim(params.payMid) == "") return;

    ksid.net.ajax("${pageContext.request.contextPath}/registration/pgpaymid/selPgPayMid", params, function(result) {
//         console.log(result);
        if(result.resultCd == "00" && result.resultData) {
            CommonJs.setStatus( ksid.string.replace( "해당 PG사 가맹점[{0}]이 이미 존재합니다.", "{0}", params.payMid ) );
            $(el).val("").focus();
        }
    });
}

/*****************************************************
* 함수명 : PG사 가맹점 저장
* 설명   :
*****************************************************/
function doSave() {
    ksid.ui.confirm("PG사 가맹점 정보를 저장하시겠습니까?", function() {
        if(ksid.form.validateForm("edit-panel")) {
            var params = ksid.form.flushPanel("edit-panel");

            var url = "";

            if(params.mode == "I") {
                url = "${pageContext.request.contextPath}/registration/pgpaymid/insPgPayMid";

            } else if(params.mode == "U") {
                url = "${pageContext.request.contextPath}/registration/pgpaymid/updPgPayMid";
            }

            ksid.net.ajax(url, params, function(result) {

                if(result.resultCd == "00") {
                    doQuery(result.resultData);
                } else {
                    CommonJs.setStatus( ksid.string.replace( "해당 PG사 가맹점[{0}]저장 작업이 실패했습니다.", "{0}", params.payMid ) );
                }

            });
        }
    });
}

/*****************************************************
* 함수명 : PG사 가맹점 삭제
* 설명   :
*****************************************************/
function doDelete() {
    ksid.ui.confirm("선택한 PG사 가맹점을 삭제하시겠습니까?", function() {
        var rowId = $("#grid1").getGridParam("selrow");

        if(!rowId) {
            ksid.ui.alert("삭제할 PG사 가맹점 행을 선택하세요.");

            return;
        }

        var params = $("#grid1").getRowData(rowId);

        ksid.net.ajax("${pageContext.request.contextPath}/registration/pgpaymid/delPgPayMid", params, function(result) {
            if(result.resultCd == "00") {
                doQuery(result.resultData);
            }
        });
    });
}

/*****************************************************
* 함수명 : PG사 가맹점 목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var excelParams = {
        file_nm         : CommonJs.setMsgLanguage("PG사가맹점목록"),
        param           : {},
        col_model       : grid1.getExcelColModel()

    };

    ksid.net.ajaxExcel("${pageContext.request.contextPath}/registration/pgpaymid/excel", excelParams);

}
</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">고객관리</span> > <span name="menu">PG사 가맹점 관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt><span name="title">PG사명</span></dt>
                <dd>
                    <select name="pgCd" title="PG사" class="style-select" overall="전체" codeGroupCd="PG_CD" style="width:170px;"></select>
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
    <h3 class="style-title"><span name="title">PG사 가맹점 정보</span></h3>
    <div id="edit-panel" class="edit-panel">
        <input type="hidden" name="mode" value="I" />
        <div class="styleDlTable">
            <dl>
                <dt name="title" class="title_on width110">PG사코드</dt>
                <dd class="width250">
                    <select name="pgCd" title="PG사" class="style-select" codeGroupCd="PG_CD"  modestyle="enable" style="width:170px;" required></select>
                </dd>
                <dt name="title" class="title_on width110">PG가맹점 ID</dt>
                <dd class="width240">
                    <input type="text" maxlength="40" name="payMid" title="가맹점 ID" class="style-input" style="width:200px;" required />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width110">가맹점명(한글)</dt>
                <dd class="width250">
                    <input type="text" maxlength="40" name="midKorNm" title="가맹점명(한글)" class="style-input" style="width:200px;" required/>
                </dd>
                <dt name="title" class="width110">가맹점명(영어)</dt>
                <dd class="width250">
                    <input type="text" maxlength="40" name="midEngNm" title="영어" class="style-input" style="width:200px;" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width110">상점 고유 IP</dt>
                <dd class="width250">
                    <input type="text" maxlength="15" name="midIpaddr" title="상점 고유IP" class="style-input width120" />
                </dd>
                <dt name="title" class="width110">취소비밀번호</dt>
                <dd class="width250">
                    <input type="text" maxlength="15" name="cancelPwd" title="취소비밀번호" class="style-input width120" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width110">취소가능기간(일)</dt>
                <dd class="width250">
                    <input type="text" maxlength="15" name="cancelDay" title="취소가능기간" class="style-input width120" format="number"/>
                </dd>
                <dt name="title" class="width110">부분취소금액</dt>
                <dd class="width250">
                    <input type="text" maxlength="15" name="cancelAmt" title="부분취소금액" class="style-input width120" format="number"/>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width110">인증용 EncKey</dt>
                <dd class="width250">
                    <input type="text" maxlength="128" name="encKey" title="인증용 EncKey" class="style-input" style="width:200px;" />
                </dd>
                <dt name="title" class="width110">인증용 HashKey</dt>
                <dd class="width250">
                    <input type="text" maxlength="128" name="hashKey" title="인증용 HashKey" class="style-input" style="width:200px;" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width110">상점키</dt>
                <dd class="width600">
                    <input type="text" maxlength="128" name="midKey" title="상점키" class="style-input" style="width:590px;"/>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width110">결제상품명</dt>
                <dd class="width250">
                    <input type="text" maxlength="128" name="goodsNm" title="결제상품명" class="style-input" style="width:200px;" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width110">등록자</dt>
                <dd class="width250">
                    <input type="text" maxlength="16" name="regId" title="등록자" class="style-input width110" modestyle="enable" required />
                </dd>
                <dt name="title" class="title_on width110">변경자</dt>
                <dd class="width250">
                    <input type="text" maxlength="16" name="chgId" title="변경자" class="style-input width110" required />
                    <!--  <input type="text" maxlength="16" name="chgId" title="변경자" class="style-input width110" modestyle="enable" required /> -->
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width110">등록일시</dt>
                <dd class="width250">
                    <input type="text" maxlength="20" name="regDtm" title="등록일시" class="style-input width110" modestyle="enable" />
                </dd>
                <dt name="title" class="width110">변경일시</dt>
                <dd class="width250">
                    <input type="text" maxlength="20" name="chgDtm" title="변경일시" class="style-input width110" modestyle="enable" />
                </dd>
            </dl>
        </div>
    </div>

    <h3 class="style-title"><span name="title">PG사 가맹점 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
