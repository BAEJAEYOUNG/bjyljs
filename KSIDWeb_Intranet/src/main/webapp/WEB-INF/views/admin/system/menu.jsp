<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<script type="text/javascript" language="javascript">
//메뉴정보 json
var newJson1 = {};

//메뉴리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

     // 메뉴리스트 그리드 생성
    var colModel = [];
    colModel.push({label: '상위메뉴아이디', name: 'refMenuId', width:100});
    colModel.push({label: '상위메뉴명', name: 'refMenuNm', format: 'string' , width:80});
    colModel.push({label: '메뉴아이디', name: 'menuId', width:80});
    colModel.push({label: '메뉴명', name: 'menuNm', format: 'string' , width:170});
    colModel.push({label: '메뉴유형', name: 'menuTypeNm', width:60});
    colModel.push({label: '실행명령', name: 'execCmd', format: 'string' , width:150});
    colModel.push({label: '메뉴레벨', name: 'menuLvl', format: 'number', width:60});
    colModel.push({label: '정렬순번', name: 'sortSeq', format: 'number' , width:60});
    colModel.push({label: '사용여부', name: 'useYnNm', width:60});
    colModel.push({label: '등록자', name: 'regNm', width:60});
    colModel.push({label: '등록일시', name: 'regDtm', format: 'dttm' , width:120});
    colModel.push({label: '변경자', name: 'chgNm', width:60});
    colModel.push({label: '변경일시', name: 'chgDtm', format: 'dttm' , width:120});

    colModel.push({label: '메뉴유형', name: 'menuType', hidden: true});
    colModel.push({label: '등록자', name: 'regId', hidden: true});
    colModel.push({label: '변경자', name: 'chgId', hidden: true});
    colModel.push({label: '사용여부', name: 'useYn', hidden: true});

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

}

/*****************************************************
* 함수명: 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function editpanelComboAjaxAfterDoQuery() {

    //메뉴정보 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

    doQuery();
}

/*****************************************************
* 함수명: 메뉴 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_menu_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/admin/system/menu/list"
                      , params
                      , function(result) {

        //메뉴 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(ksid.string.replace( "메뉴목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }
    });
}

/*****************************************************
* 함수명: 메뉴 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson1.mode = "I";

    // edit-panel에 newJson1를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson1);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson1.mode);

    $("#edit-panel input[name=menuNm]").focus();
}

/*****************************************************
* 함수명: 메뉴 저장
* 설명   :
*****************************************************/
function doSave() {
 ksid.ui.confirm("메뉴을 저장하시겠습니까?", function() {
     if(ksid.form.validateForm("edit-panel")) {
         var params = ksid.form.flushPanel("edit-panel");

         var url = "";

         if(params.mode == "I") {
             url = "${pageContext.request.contextPath}/admin/system/menu/ins";

         } else if(params.mode == "U") {
             url = "${pageContext.request.contextPath}/admin/system/menu/upd";
         }

         ksid.net.ajax(url, params, function(result) {

             if(result.resultCd == "00") {
                 newJson1.menuType = params.menuType;
                 newJson1.menuLvl = params.menuLvl;
                 newJson1.sortSeq = ksid.number.toNumber(params.sortSeq) + 10;
                 newJson1.refMenuId = params.refMenuId;
                 doQuery(result.resultData);
              }

         });
     }
 });
}

/*****************************************************
* 함수명: 메뉴 삭제
* 설명   :
*****************************************************/
function doDelete() {
 ksid.ui.confirm("선택한 메뉴을 삭제하시겠습니까?", function() {
     var rowId = $("#grid1").getGridParam("selrow");

     if(!rowId) {
         ksid.ui.alert("삭제할 메뉴 행을 선택하세요.");

         return;
     }

     var params = $("#grid1").getRowData(rowId);

     ksid.net.ajax("${pageContext.request.contextPath}/admin/system/menu/del", params, function(result) {
         if(result.resultCd == "00") {
             doQuery(result.resultData);
          }
     });
 });
}

/*****************************************************
* 함수명: 메뉴목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

}
</script>

</head>
<body>

<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">시스템</span> > <span name="menu">메뉴관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title">메뉴아이디/명</dt>
                <dd>
                    <input type="text" maxlength="3" name="menuId" title="메뉴아이디/명" class="style-input width110" command="doQuery()" />
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
    <h3 class="style-title"><span name="title">메뉴 정보</span></h3>
    <div id="edit-panel" class="edit-panel">
        <input type="hidden" name="mode" value="I" />
        <div class="styleDlTable">
            <dl>
                <dt name="title" class="title_on width130">상위메뉴ID</dt>
                <dd class="width130">
                    <input type="text" maxlength="10" name="refMenuId" title="상위메뉴아이디" class="style-input width110" />
                </dd>
                <dt name="title" class="title_on width80">메뉴아이디</dt>
                <dd class="width130">
                    <input type="text" maxlength="10" name="menuId" title="메뉴아이디" class="style-input width110" disabled />
                </dd>
                <dt name="title" class="title_on width80">메뉴명</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="menuNm" title="메뉴명" class="style-input width110" command="doSave()" />
                </dd>
                <dt name="title" class="title_on width80">메뉴유형</dt>
                <dd class="width130">
                    <select name="menuType" title="메뉴유형" class="style-select width120" codeGroupCd="MENU_TYPE" selected_value="M" required></select>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width130">실행명령</dt>
                <dd class="width370">
                    <input type="text" name="execCmd" title="실행명령" class="style-input width350" command="doSave()" />
                </dd>
                <dt name="title" class="width80">메뉴레벨</dt>
                <dd class="width130">
                    <input type="text" maxlength="200" name="menuLvl" title="메뉴레벨" class="style-input width60" format="number" command="doSave()" />
                </dd>
                <dt name="title" class="width80">정렬순번</dt>
                <dd class="width130">
                    <input type="text" maxlength="200" name="sortSeq" title="정렬순번" class="style-input width60" format="number" command="doSave()" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width130">사용여부</dt>
                <dd class="width130">
                    <select name="useYn" title="사용여부" class="style-select width120" codeGroupCd="USE_YN" required></select>
                </dd>
            </dl>
        </div>
    </div>

    <h3 class="style-title"><span name="title">메뉴 목록</span></h3>
    <!-- grid -->
    <table id="grid1" ></table>
    <!--// grid -->
</div>
