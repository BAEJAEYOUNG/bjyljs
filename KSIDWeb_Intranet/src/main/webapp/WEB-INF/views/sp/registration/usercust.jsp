<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 사용자정보 json
var newJson1 = null;
var newJsonDialog = null;

// 사용자리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '고객사', name: 'custNm', format: 'string' , width:120});
    /* colModel.push({ label: '사용자아이디', name: 'userId', format: 'string' , width:80 }); */
    /* colModel.push({ label: '사용자명', name: 'userNm', format: 'string', width:80 }); */
    colModel.push({ label: '학번', name: 'custUserNo', format: 'string' , width:100});
    /* colModel.push({ label: '생년월일', name: 'birthDay', width:80, format: 'date' , width:100 }); */
    colModel.push({ label: '휴대폰번호', name: 'mpNo',format: 'tel_no' , width:120 });
    /* colModel.push({ label: '성별', name: 'sexNm', width:40 }); */
    /* colModel.push({ label: '가입유형', name: 'joinTpNm',  width:80 }); */
    colModel.push({ label: '사용자상태', name: 'userStNm',width:70 });
    /* colModel.push({ label: '등록자', name: 'regNm',width:80 }); */
    /* colModel.push({ label: '등록일시', name: 'regDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '변경자', name: 'chgNm',width:80 });
    colModel.push({ label: '변경일시', name: 'chgDtm',format: 'dttm' , width:120 }); */
    colModel.push({ label: '가입일시', name: 'joinDtm',format: 'dttm' , width:160 });
    /* colModel.push({ label: '해지사유', name: 'cancelRsn', format: 'string' , width:200 }); */
    colModel.push({ label: '해지일시', name: 'cancelDtm',format: 'dttm' , width:160 });

    colModel.push({ label: '등록자', name: 'regId', hidden: true });
    colModel.push({ label: '변경자', name: 'chgId', hidden: true });
    colModel.push({ label: '가입유형', name: 'joinTp', hidden: true });
    colModel.push({ label: '성별', name: 'sex', hidden: true });
    colModel.push({ label: '사용자상태', name: 'userSt', hidden: true });

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

    //사용자리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    grid1.pager = new ksid.paging({
        "var": {
            elementId: "grid1_pager"          // 페이저 id ( 임의로 지정, 같은이름만 없으면 된다. )
        },
        "prop": {
            totrowcnt: 1,       // 전체row수
            pagecnt: 100,       // 페이지당 row수
            pagenow: 1,         // 현재 page 번호
            blockcnt: 15        // 블록당페이지수
        },
        context: '${pageContext.request.contextPath}'
    });
    grid1.pager.parent      = grid1;                // 페이저 소속 GRID 를 지정한다.
    grid1.pager.selectFunc  = doQueryPaging;        // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    grid1.pager.show();

    //사용자 중복체크
    $("#edit-panel input[name='adminId']").blur(function() {
        doCheckCustId("edit-panel", this);
    });

    newJsonDialog = ksid.form.flushPanel('dialog_demo_user_reg_search-panel');

}

/*****************************************************
* 함수명 : 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function editpanelComboAjaxAfterDoQuery() {

    var params = {spCd:"${sessionScope.sessionUser.spCd}", custId:"${sessionScope.sessionUser.custId}"};
    var combo = $("#search-panel select[name=custId]");
    ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);


    //사용자정보 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

    doQuery();
}

/*****************************************************
* 함수명 : 사용자 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    grid1.pager.prop.pagenow = 1;

    doQueryPaging(resultMsg);

}

function doQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = grid1.pager.prop.pagecnt;
    params.pagenow = grid1.pager.prop.pagenow;

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/sp/registration/user/list"
                      , params
                      , function(result) {

        //사용자 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "사용자 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : 사용자 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson1.mode = "I";

//     ksid.debug.printObj(newJson1);

    // edit-panel에 newJson1를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson1);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson1.mode);

    $("#edit-panel input[name=adminId]").focus();

}

/*****************************************************
* 함수명 : 사용자 저장
* 설명   :
*****************************************************/
function doSave() {

    var params = ksid.form.flushPanel("edit-panel");

    if(params.userSt == "9") {
        ksid.ui.alert("해지된 사용자 입니다.");
        return;
    };

    ksid.ui.confirm("사용자을 저장하시겠습니까?", function() {
        if(ksid.form.validateForm("edit-panel")) {

            var url = "";

            if(params.mode == "I") {
                url = "${pageContext.request.contextPath}/sp/registration/user/ins";

            } else if(params.mode == "U") {
                url = "${pageContext.request.contextPath}/sp/registration/user/upd";
            }

            ksid.net.ajax(url, params, function(result) {

                if(result.resultCd == "00") {
                    doQuery(result.resultData);
                }

            });
        }
    });
}

/*****************************************************
* 함수명 : 사용자 해지
* 설명   :
*****************************************************/
function doCancel() {

    var rowId = $("#grid1").getGridParam("selrow");

    if(!rowId) {
        ksid.ui.alert("해지할 사용자를 선택하세요.");

        return;
    }

    var params = ksid.form.flushPanel("edit-panel");

    if(params.userSt == "9") {
        ksid.ui.alert("해지된 사용자 입니다.");
        return;
    };

    if( ksid.string.trim(params.cancelRsn) == "" ) {
        ksid.ui.alert("해지사유를 입력하세요");
        return;
    }

    ksid.ui.confirm("선택한 사용자를 해지하시겠습니까?", function() {

        ksid.net.ajax("${pageContext.request.contextPath}/sp/registration/user/cancel", params, function(result) {
            if(result.resultCd == "00") {
                doQuery(result.resultData);
            } else {
                CommonJs.setStatus(result.resultData);
            }

        });
    });
}


/*****************************************************
* 함수명 : 사용자 삭제
* 설명   :
*****************************************************/
function doDelete() {

    var rowId = $("#grid1").getGridParam("selrow");

    if(!rowId) {
        ksid.ui.alert("삭제할 사용자를 선택하세요.");

        return;
    }

    var params = ksid.form.flushPanel("edit-panel");

    if(params.userSt == "0") {
        ksid.ui.alert("먼저 사용자를 해지하세요.");
        return;
    };

    ksid.ui.confirm("선택한 사용자를 삭제하시겠습니까?", function() {

        ksid.net.ajax("${pageContext.request.contextPath}/sp/registration/user/del", params, function(result) {
            if(result.resultCd == "00") {
                doQuery(result.resultData);
            } else {
                CommonJs.setStatus(result.resultData);
            }

        });
    });
}

/*****************************************************
* 함수명 : 사용자목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/sp/registration/user/excel";
    var fileNm = "사용자목록";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">가입관리</span> > <span name="menu">사용자관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <input type="hidden" name="spCd" value="${sessionScope.sessionUser.spCd}" />
        <div class="styleDlTable">
            <dl>
                <dt class="width80">고객사</dt>
                <dd class="width160">
                    <select name="custId" title="고객사" class="style-select width150" codeGroupCd="CUST_ID"></select>
                </dd>
                 <dd class="width10">
                 </dd>
<!--                 <dt style="display:none" class="width70">가입유형</dt> -->
<!--                 <dd style="display:none" class="width120"> -->
<!--                     <select name="joinTp" title="가입유형" class="style-select width120" codeGroupCd="JOIN_TP" overall="전체" selected_value=""></select> -->
<!--                 </dd> -->
                <dt class="width80">서비스상태</dt>
                <dd class="width160">
                    <select name="userSt" title="사용자상태" class="style-select width150" codeGroupCd="USER_ST" overall="전체" selected_value=""></select>
                </dd>

            </dl>
            <dl>
<!--                 <dt style="display:none">사용자아이디</dt> -->
<!--                 <dd style="display:none"> -->
<!--                     <input type="text" maxlength="3" name="userId" title="사용자아이디" class="style-input width110" command="doQuery()" /> -->
<!--                 </dd> -->
<!--                 <dt style="display:none" class="width70">사용자명</dt> -->
<!--                 <dd style="display:none" class="width120"> -->
<!--                     <input type="text" maxlength="16" name="userNm" title="사용자명" class="style-input width110" command="doQuery()" /> -->
<!--                 </dd> -->
<!--                 <dt style="display:none" class="width60">생년월일</dt> -->
<!--                 <dd style="display:none" class="width130"> -->
<!--                     <input type="text" maxlength="8" name="birthDay" title="생년월일" class="style-input width100" format="no" command="doQuery()" /> -->
<!--                 </dd> -->
                <dt class="width80">학번</dt>
                <dd class="width160">
                    <input type="text" maxlength="20" name="custUserNo" title="학번" class="style-input width140" command="doQuery()"/>
                </dd>
                <dd class="width10">
                </dd>
                <dt class="width80">휴대폰번호</dt>
                <dd class="width160">
                    <input type="text" maxlength="20" name="mpNo" title="휴대폰번호" class="style-input width140" format="tel_no" command="doQuery()"/>
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
        </div>
        <div style="display:none" class="button-bar">
            <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
            <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
            <button type="button" class="style-btn" auth="W" onclick="doCancel()">해지</button>
            <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->
    <h3 style="display:none" class="style-title">사용자 정보</h3>
    <div style="display:none" id="edit-panel" class="edit-panel">
        <input type="hidden" name="mode" value="I" />
        <input type="hidden" name="spCd" value="${sessionScope.sessionUser.spCd}" />
        <div class="styleDlTable">
            <dl>
                <dt class="width80">사용자ID</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="userId" title="사용자ID" class="style-input width110" disabled />
                </dd>
                <dt class="title_on width80">사용자명</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="userNm" title="사용자명" class="style-input width110" required />
                </dd>
                <dt class="title_on width80">생년월일</dt>
                <dd class="width130">
                    <input type="text" maxlength="8" name="birthDay" title="생년월일" class="style-input width100" format="no" />
                </dd>
                <dt class="width80">휴대폰번호</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" name="mpNo" title="휴대폰번호" class="style-input width110" format="tel_no" command="doSave()" />
                </dd>
            </dl>
            <dl>
                <dt class="title_on width80">성별</dt>
                <dd class="width130">
                    <select name="sex" title="성별" class="style-select width120" codeGroupCd="SEX"></select>
                </dd>
                <dt class="title_on width80">가입유형</dt>
                <dd class="width130">
                    <select name="joinTp" title="가입유형" class="style-select width120" codeGroupCd="JOIN_TP"></select>
                </dd>
                <dt class="title_on width80">가입일시</dt>
                <dd class="width130">
                    <input type="text" name="joinDtm" title="가입일시" format="dttm" class="style-input width110" disabled />
                </dd>
                <dt class="title_on width80">해지일시</dt>
                <dd class="width130">
                    <input type="text" name="cancelDtm" title="해지일시" format="dttm" class="style-input width110" disabled />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">사용자상태</dt>
                <dd class="width130">
                    <select name="userSt" title="사용자상태" class="style-select width120" codeGroupCd="USER_ST" disabled></select>
                </dd>
                <dt name="title" class="width80">해지사유</dt>
                <dd class="width600">
                    <input type="text" maxlength="200" name="cancelRsn" title="해지사유" class="style-input width580" style="width:590px;"/>
                </dd>
            </dl>
        </div>
    </div>

    <h3 class="style-title"><span name="title">사용자 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <div id="grid1_pager" class="pager"></div>
    <!--// grid -->
</div>