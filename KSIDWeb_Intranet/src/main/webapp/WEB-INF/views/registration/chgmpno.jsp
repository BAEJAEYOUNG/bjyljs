<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 사용자 번호변경 정보 json
var newJson1 = {};

// 사용자 번호변경 리스트 grid
var userGrid = null;
var chgGrid = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    // 사용자 목록 그리드 생성
    colModel = [];

    colModel.push({label:"서비스제공자", name:"spNm", format:"string", width:120});
    colModel.push({label:"고객사", name:"custNm", format:"string", width:120});
    colModel.push({label:"사용자명", name:"userNm", format:"string", width:80});
    colModel.push({label:"휴대폰번호", name:"mpNo", format:"tel_no", width:100});
    colModel.push({label:"학번/사번", name:"custUserNo", width:80});
    colModel.push({label:"사용자상태", name:"userStNm", width:60});
    colModel.push({label:"가입일시", name:"joinDtm", format:"dttm", width:120});
    colModel.push({label:"법인여부", name:"corpYnNm", hidden:true});
    colModel.push({label:"사업자번호", name:"bizNo", hidden:true});
    colModel.push({label:"해지일시", name:"cancelDtm", format:"dttm", width:120});
    colModel.push({label:"해지사유", name:"cancelRsn", format:"string", width:200});
    colModel.push({label:"서비스제공자코드", name:"spCd", hidden:true});
    colModel.push({label:"서비스제공자사업자번호", name:"bizNo", hidden:true});
    colModel.push({label:"고객사 ID", name:"custId", hidden:true});
    colModel.push({label:"사용자", name:"userId", hidden:true});
    colModel.push({label:"사용자유형", name:"userTp", hidden:true});
    colModel.push({label:"사용자상태", name:"userSt", hidden:true});
    colModel.push({label:"법인여부", name:"corpYn", hidden:true});
    colModel.push({label:"가입유형", name:"joinTp", hidden:true});
    colModel.push({label:"가입유형", name:"joinTpNm", hidden:true});
    colModel.push({label:"상태", name:"userSt", hidden:true});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        userGrid.setClickedProp(rowId);
        var rowData = userGrid.clickedRowData;
        $("#oldMpNo").val(rowData.mpNo);
        $("#custUserNo").val(rowData.custUserNo);
        $("#userId").val(rowData.userId);
    };

    // 고객사-사용자  목록 그리드 생성
    userGrid = new ksid.grid("userGrid", gridProp);
    userGrid.loadGrid();

    var paging = {}
    paging.options = {};
    paging.options["var"] = {};
    paging.options["prop"] = {};
    paging.options["var"].elementId = "userGrid_pager";
    paging.options["prop"].totrowcnt = 1;
    paging.options["prop"].pagecnt = 20;
    paging.options["prop"].pagenow = 1;
    paging.options["prop"].blockcnt = 15;
    paging.options.context = "${pageContext.request.contextPath}";

    userGrid.pager = new ksid.paging(paging.options);
    userGrid.pager.parent      = userGrid;                // 페이저 소속 GRID 를 지정한다.
    userGrid.pager.selectFunc  = doUserQueryPaging;        // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    userGrid.pager.show();


    var colModel = [];
    colModel.push({label:'사용자명', name: 'userNm', format: 'string', width:120 });
    colModel.push({label:'변경전 핸드폰번호', name:'oldMpNo', format:'tel_no', width:140});
    colModel.push({label:'변경후 핸드폰번호', name:'newMpNo', format:'tel_no', width:140});
    colModel.push({label:'번호변경일시', name:'chgDtm', format:'dttm', width:120});
    colModel.push({label:'번경자', name:'chgNm', width:140});

    gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
    };

    //사용자 번호변경 이력 그리드 생성
    chgGrid = new ksid.grid("chgGrid", gridProp);
    chgGrid.loadGrid();

    var paging = {}
    paging.options = {};
    paging.options["var"] = {};
    paging.options["prop"] = {};
    paging.options["var"].elementId = "chgGrid_pager";
    paging.options["prop"].totrowcnt = 1;
    paging.options["prop"].pagecnt = 100;
    paging.options["prop"].pagenow = 1;
    paging.options["prop"].blockcnt = 15;
    paging.options.context = "${pageContext.request.contextPath}";

    chgGrid.pager = new ksid.paging(paging.options);
    chgGrid.pager.parent      = chgGrid;                // 페이저 소속 GRID 를 지정한다.
    chgGrid.pager.selectFunc  = doChgQueryPaging;        // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    chgGrid.pager.show();

    //사용자 번호변경 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

    var sDate = new ksid.datetime().before(0,1,0).getDate("yyyy-mm-dd");
    var eDate = new ksid.datetime().getDate("yyyy-mm-dd");

    $("#search-panel input[name=sDt]").val(sDate);
    $("#search-panel input[name=eDt]").val(eDate);

    //doQuery();
}

/*****************************************************
* 함수명 : 사용자 번호변경 이력 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    userGrid.pager.prop.pagenow = 1;
    doUserQueryPaging(resultMsg);

    chgGrid.pager.prop.pagenow = 1;
    doChgQueryPaging(resultMsg);

}


function doChgQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = chgGrid.pager.prop.pagecnt;
    params.pagenow = chgGrid.pager.prop.pagenow;

    ksid.net.ajaxJqGrid(chgGrid
                      , "${pageContext.request.contextPath}/registration/chgmpno/selChgMpNoHisList"
                      , params
                      , function(result) {

        //사용자 번호변경 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "사용자 번호변경 이력 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }
    });

}


function doUserQueryPaging(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    params.pagecnt = userGrid.pager.prop.pagecnt;
    params.pagenow = userGrid.pager.prop.pagenow;

    ksid.net.ajaxJqGrid(userGrid
                      , "${pageContext.request.contextPath}/registration/chgmpno/selUserTelnoList"
                      , params
                      , function(result) {

          $("#oldMpNo").val("");
          $("#custUserNo").val("");

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "사용자 번호 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }
    });

}

/*****************************************************
* 함수명 : 사용자 신규
*****************************************************/
function doNew() {

    // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson1.mode = "I";

//     ksid.debug.printObj(newJson1);

    // edit-panel에 newJson1를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson1);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson1.mode);

    $("#edit-panel input[name=oldMpNo]").focus();

}


/*****************************************************
* 함수명 : 사용자 번호변경 저장
* 설명   :
*****************************************************/
function doSave() {
    var params = ksid.form.flushPanel("edit-panel");
    //ksid.debug.printObj(params);

    if(params.oldMpNo.length < 10) {
        ksid.ui.alert("변경후 핸드폰번호를 입력하세요.");
        $("#edit-panel input[name=oldMpNo]").focus();
        return;
    }
    if(params.newMpNo.length < 10) {
        ksid.ui.alert("변경후 핸드폰번호를 입력하세요.");
        $("#edit-panel input[name=newMpNo]").focus();
        return;
    }
    //console.log("params", params);

    ksid.ui.confirm("사용자 번호변경을 요청하시겠습니까?", function() {
        if(ksid.form.validateForm("edit-panel")) {
            var url = "${pageContext.request.contextPath}/registration/chgmpno/chgMpNoReq";

            ksid.net.ajax(url, params, function(result) {

                if(result.resultCd == "00") {
                    doQuery(result.resultData);
                } else {
                    CommonJs.setStatus( ksid.string.replace( "해당 사용자 번호변경 [{0}]요청 작업이 실패했습니다.", "{0}", params.newMpNo ) );
                    ksid.ui.alert("번호변경 요청 작업이 실패했습니다. " + result.resultData);
                }
            });
        }
    });
}


/*****************************************************
* 함수명 : 사용자 번호변경 이력 목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/registration/chgmpno/excel";
    var fileNm = "사용자번호변경이력";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, chgGrid);

}
</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">가입관리</span> > <span name="menu">사용자 번호변경</span></p>
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
                <dd class="width40"></dd>
                <dt><span name="title">사용자명</span></dt>
                <dd>
                    <input type="text" maxlength="3" name="userNm" title="사용자명" class="style-input width110" command="doQuery()" />
                </dd>
                <dt class="width80">휴대폰번호</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" name="mpNo" title="휴대폰번호" class="style-input width110" format="tel_no"" />
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <h3 class="style-title"><span name="title">사용자 번호 목록</span></h3>
    <!-- grid -->
    <table id="userGrid"></table>
    <div id="userGrid_pager" class="pager"></div>
    <!--// grid -->

    <div class="style-title-wrap">
        <h3 class="style-title"><span name="title">사용자 번호변경 요청 정보</span></h3>
        <!--  button bar  -->
        <div class="button-bar button-bar-abso">
            <button type="button" class="style-btn" auth="W" onclick="doSave()">번호변경</button>
        </div>
        <!--// button bar  -->
    </div>

    <div id="edit-panel" class="edit-panel">
        <input type="hidden" name="mode" value="I" />
        <input type="hidden" id="userId" name="userId" value="" />

        <div class="styleDlTable">
            <dl>
                <dt name="title" class="title_on">변경전 핸드폰번호</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" id="oldMpNo" name="oldMpNo" title="변경전 핸드폰번호" class="style-input width110" format="tel_no" disabled />
                </dd>
                <dt name="title" class="title_on">학번/사번</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" id="custUserNo" name=""custUserNo"" title="학번/사번" class="style-input width110" format="tel_no" disabled />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on">변경후 핸드폰번호</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" id="newMpNo" name="newMpNo" title="변경후 핸드폰번호" class="style-input width110" format="tel_no" modestyle="enable" required />
                </dd>
            </dl>
        </div>
    </div>

    <h3 class="style-title"><span name="title">사용자 번호변경 이력 목록</span></h3>
    <!-- grid -->
    <table id="chgGrid"></table>
    <div id="chgGrid_pager" class="pager"></div>
    <!--// grid -->
</div>
