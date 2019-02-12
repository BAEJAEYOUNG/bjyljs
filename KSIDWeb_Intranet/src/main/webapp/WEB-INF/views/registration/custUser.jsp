<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<script type="text/javascript" language="javascript">


//코드그룹신규JSON
var newGroupJson;

//코드신규JSON
var newCdJson;

//코드그룹grid, 코드grid
var grid1,grid2;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

     var colCust = [];
     colCust.push({ label: '서비스제공자코드', name: 'spCd', format: 'string', width:100 });
     colCust.push({ label: '서비스제공자명', name: 'spNm',format: 'string' , width:100 });
     colCust.push({ label: '고객사아이디', name: 'custId', format: 'string', width:100 });
     colCust.push({ label: '고객사명', name: 'custNm',format: 'string' , width:80 });
     colCust.push({ label: '고객사유형', name: 'custTpNm', width:70 });
     colCust.push({ label: '고객사상태', name: 'custStNm',width:70 });

     var gridProp = {};
     gridProp.colModel = colCust;
     gridProp.shrinkToFit = false;
     gridProp.onSelectRow = function (rowId, status, e) {
         grid1.setClickedProp(rowId);
         //고객사-사용자 조회
         doQuery2();
     };

     //고객사 그리드 생성
     grid1 = new ksid.grid("grid1", gridProp);
     grid1.loadGrid();


     var colUser = [];
     colUser.push({ label: '사용자아이디', name: 'userId', format: 'string', width:60 });
     colUser.push({ label: '사용자명', name: 'userNm', width:60 });
     colUser.push({ label: '생년월일', name: 'birthDay',format: 'date' , width:80 });
     colUser.push({ label: '휴대폰번호', name: 'mpNo',format: 'tel_no' , width:60 });
     colUser.push({ label: '사용자상태', name: 'userStNm', width:40 });

     var gridProp = {};
     gridProp.colModel = colUser;
     gridProp.shrinkToFit = true;
     gridProp.multiselect = true;

     //사용자 그리드 생성
     grid2 = new ksid.grid("grid2", gridProp);
     grid2.loadGrid();

     var colDialogUser = [];
     colDialogUser.push({ label: '사용자아이디', name: 'userId', width:80 });
     colDialogUser.push({ label: '사용자명', name: 'userNm', width:60 });
     colDialogUser.push({ label: '생년월일', name: 'birthDay',format: 'date' , width:80 });
     colDialogUser.push({ label: '휴대폰번호', name: 'mpNo',format: 'tel_no' , width:80 });
     colDialogUser.push({ label: '사용자상태', name: 'userStNm', width:40 });

     var gridProp = {};
     gridProp.colModel = colDialogUser;
     gridProp.shrinkToFit = true;
     gridProp.multiselect = true;
     gridProp.height = 375;

     //다이얼로그 사용자 그리드 생성
     grid3 = new ksid.grid("grid3", gridProp);
     grid3.loadGrid();

     doQuery();
}

/*****************************************************
* 함수명: 고객사 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    console.log(gParam);

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/registration/custuser/custList"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "고객사 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 고객사-사용자 목록 조회
* 설명   :
*****************************************************/
function doQuery2(resultMsg) {

    var params = {}
    params.spCd = grid1.clickedRowData.spCd;
    params.custId = grid1.clickedRowData.custId;

    ksid.net.ajaxJqGrid(grid2
                      , "${pageContext.request.contextPath}/registration/custuser/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "고객사-사용자 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 다이얼로그 사용자 목록 조회
* 설명   :
*****************************************************/
function doQueryDialog(resultMsg) {

    var params = {};
    params.spCd = grid1.clickedRowData.spCd;
    params.custId = grid1.clickedRowData.custId;

    ksid.net.ajaxJqGrid(grid3
                      , "${pageContext.request.contextPath}/registration/custuser/listDialog"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "사용자 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 사용자 신규
*****************************************************/
function doNew() {

    if(grid1.clickedRowData == null) {

        ksid.ui.alert("사용자를 등록하시려면 먼저 왼쪽 고객사목록에서 고객사을 선택하세요.");
        return;

    }

    ksid.json.mergeObject(ksid.json.dialogProp, {title:"고객사-사용자 등록", width:600, height:500});

    $("#dialog_cust_user").dialog(ksid.json.dialogProp);

    doQueryDialog();

}

/*****************************************************
* 함수명: 사용자 저장
* 설명   :
*****************************************************/
function doSave() {

    var selectedIds = $("#grid3").getGridParam("selarrrow");

    if( selectedIds.length == 0 ) {

        ksid.ui.alert("선택한 사용자가 없습니다.<br />장치에 등록할 사용자를 선택하세요");
        return;

    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {

        var selectedData = $("#grid3").getRowData(selectedIds[i]);

        var paramMap = {};

        paramMap.spCd    = grid1.clickedRowData.spCd;
        paramMap.custId  = grid1.clickedRowData.custId;
        paramMap.userId  = selectedData.userId;

        params.push(paramMap);

    }

    console.log(params);

    ksid.ui.confirm(ksid.string.replace( "선택하신 사용자를 고객사[{0}]에 등록하시겠습니까?", "{0}", grid1.clickedRowData.custNm ), function() {

        ksid.net.ajaxMulti("${pageContext.request.contextPath}/registration/custuser/ins", JSON.stringify(params), function(result) {

            console.log("### result ###");
            console.log(result);

            if(result.resultCd == "00") {
                doQuery2(result.resultData);
                doQueryDialog();
                $('#dialog_cust_user').dialog('close');
             }

        });
    });
}

/*****************************************************
* 함수명: 사용자 삭제
* 설명   :
*****************************************************/
function doDelete() {
    var selectedIds = $("#grid2").getGridParam("selarrrow");

    if( selectedIds.length == 0 ) {

        ksid.ui.alert(CommonJs.setMsgLanguage("선택한 사용자가 없습니다. 장치에 삭제할 사용자를 선택하세요"));
        return;

    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {

        var selectedData = $("#grid2").getRowData(selectedIds[i]);

        var paramMap = {};

        paramMap.spCd    = grid1.clickedRowData.spCd;
        paramMap.custId  = grid1.clickedRowData.custId;
        paramMap.userId  = selectedData.userId;

        params.push(paramMap);

    }

    ksid.ui.confirm(ksid.string.replace("선택하신 사용자를 고객사[{0}]에서 삭제하시겠습니까?", "{0}", grid1.clickedRowData.custNm ), function() {
        ksid.net.ajaxMulti("${pageContext.request.contextPath}/registration/custuser/del", JSON.stringify(params), function(result) {
            if(result.resultCd == "00") {
                doQuery2();
                doQueryDialog();
             }
        });
    });
}



</script>

<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">가입관리</span> > <span name="menu">고객사-사용자 등록</span></p>
    </div>


    <!-- 검색조건 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title"><label for="codeGroupNm">고객사아이디/명</label></dt>
                <dd><input type="text" maxlength="100" class="style-input width133" name="custId" title="고객사아이디/명" class="style-input" command="doQuery()" /></dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 검색조건 끝 -->

    <div class="variableWrapCode">
        <!-- 왼쪽 컨텐츠  -->
        <div class="fLeft">
            <h3 class="style-title"><span name="title">고객사 목록</span></h3>
            <!-- 그리드 시작 -->
            <table id="grid1" ></table>
            <!-- 그리드 끝 -->
        </div>
        <!--// 왼쪽 컨텐츠  -->

        <!-- 오른쪽 컨텐츠  -->
        <!-- 입력화면 시작 -->
        <div class="fRight">
            <div class="style-title-wrap">
                <h3 class="style-title"><span name="title">고객사-사용자 목록</span></h3>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doNew()">등록</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
                </div>
                <!--// button bar  -->
            </div>
            <table id="grid2" ></table>
        </div>
        <!--// 오른쪽 컨텐츠  -->
    </div>
</div>

<div id="dialog_cust_user" style="display:none;" class="dialog">

    <!-- 버튼 시작 -->
    <div class="button-bar">
        <button type="button" onclick="doQueryDialog()" class="style-btn">조회</button>
        <button type="button" onclick="doSave()" class="style-btn">저장</button>
        <button type="button" onclick="$('#dialog_cust_user').dialog('close')" class="style-btn">닫기</button>
    </div>
    <!-- 버튼 끝 -->

    <!-- grid -->
    <table id="grid3" ></table>

</div>
