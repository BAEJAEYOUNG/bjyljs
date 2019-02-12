<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<script type="text/javascript" language="javascript">


//신규JSON
var newJson;

//기준할인, 기준할인고객사, 기준할인고객사선택
var grid1,grid2,grid3;


/*****************************************************
 * 함수명 : ready
 * 설명   : onload 함수
 *****************************************************/
$(document).ready(function() {
    init();
});

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

     // 기준할인 그리드 생성
     var colModel = [];
     colModel.push({ label:'기준할인대상구분', name:'pbTargetFg', hidden:true });
     colModel.push({ label:'기준할인대상유형', name:'pbTargetTp', hidden:true });
     colModel.push({ label:'할인금액유형', name:'pbPriceTp', hidden:true });
     colModel.push({ label:'등록자', name:'regId', hidden:true });
     colModel.push({ label:'변경자', name:'chgId', hidden:true });
     colModel.push({ label:'기준할인아이디', name:'pbId', hidden:true });

     colModel.push({ label:'기준할인행사명', name:'pbNm', format:'string', width:100 });
     colModel.push({ label:'기준할인대상구분', name:'pbTargetFgNm', width:100 });
     colModel.push({ label:'기준할인대상유형', name:'pbTargetTpNm', width:100 });
     colModel.push({ label:'기준할인대상수량', name:'pbTargetCnt', format:'number', width:100 });
     colModel.push({ label:'할인금액유형', name:'pbPriceTpNm', width:100 });
     colModel.push({ label:'할인율', name:'saleRate', format:'rate', width:50 });
     colModel.push({ label:'할인금액', name:'salePrice', format:'number', width:60 });
     colModel.push({ label:'시작일자', name:'stDtm', format:'date', width:80 });
     colModel.push({ label:'종료일자', name:'edDtm', format:'date', width:80 });
     colModel.push({ label:'비고', name:'remark', format:'string', width:200 });
     colModel.push({ label:'등록일시', name:'regDtm', format:'dttm', width:120 });
     colModel.push({ label:'등록자', name:'regNm', width:150 });
     colModel.push({ label:'변경일시', name:'chgDtm', format:'dttm', width:120 });
     colModel.push({ label:'변경자', name:'chgNm', width:150 });

     var gridProp = {};
     gridProp.colModel = ksid.json.cloneObject(colModel);
     gridProp.shrinkToFit = false;
     gridProp.onSelectRow = function (rowId, status, e) {

         grid1.setClickedProp(rowId);

         var rowData = grid1.clickedRowData;
         rowData.mode = "U";

         ksid.form.bindPanel("edit-panel", rowData);

         // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
         ksid.form.applyModeStyle("edit-panel", rowData.mode);

         doQuery2();
     };

     grid1 = new ksid.grid("grid1", gridProp);
     grid1.loadGrid();


     //기준할인고객사 그리드 생성
     var colModel = [];
     colModel.push({ label:'서비스제공자코드', name:'spCd', hidden:true });
     colModel.push({ label:'고객사코드', name:'custId', hidden:true });
     colModel.push({ label:'기준할인아이디', name:'pbId', hidden:true });

     colModel.push({ label:'서비스제공자', name:'spNm', format:'string', width:100 });
     colModel.push({ label:'고객사', name:'custNm', format:'string', width:100 });
     colModel.push({ label:'고객사유형', name:'custTpNm', width:80 });
     colModel.push({ label:'사업자번호', name:'bizNo', format:'biz_no', width:80 });
     colModel.push({ label:'시작일자', name:'stDtm', format:'date', edittype:'date', editable:true, editrules:{required:true}, width:80 });
     colModel.push({ label:'종료일자', name:'edDtm', format:'date', edittype:'date', editable:true, editrules:{required:true}, width:80 });
     colModel.push({ label:'비고', name:'remark', format:'string', editable:true, width:200 });
     colModel.push({ label:'등록일시', name:'regDtm', format:'dttm', width:120 });
     colModel.push({ label:'등록자', name:'regNm', width:120 });
     colModel.push({ label:'변경일시', name:'chgDtm', format:'dttm', width:120 });
     colModel.push({ label:'변경자', name:'chgNm', width:100 });

     var gridProp = {};
     gridProp.colModel = ksid.json.cloneObject(colModel);
     gridProp.shrinkToFit = false;
     gridProp.multiselect = true;
     gridProp.cellsubmit = 'clientArray';
     gridProp.cellEdit = true;
     gridProp.onSelectRow = function (rowId, status, e) {
     };

     //관리자리스트 그리드 생성
     grid2 = new ksid.grid("grid2", gridProp);
     grid2.loadGrid();


     //기준할인고객사 그리드 생성
     var colModel = [];
     colModel.push({ label:'서비스제공자코드', name:'spCd', hidden:true });
     colModel.push({ label:'고객사코드', name:'custId', hidden:true });

     colModel.push({ label:'서비스제공자', name:'spNm', format:'string', width:100 });
     colModel.push({ label:'고객사', name:'custNm', format:'string', width:100 });
     colModel.push({ label:'고객사유형', name:'custTpNm', width:80 });
     colModel.push({ label:'사업자번호', name:'bizNo', format:'biz_no', width:80 });

     var gridProp = {};
     gridProp.colModel = ksid.json.cloneObject(colModel);
     gridProp.height = 410;
     gridProp.shrinkToFit = true;
     gridProp.multiselect = true;


     //관리자리스트 그리드 생성
     grid3 = new ksid.grid("grid3", gridProp);

     var paging = {}
     paging.options = {};
     paging.options["var"] = {};
     paging.options["prop"] = {};
     paging.options["var"].elementId = "grid3_pager";
     paging.options["prop"].totrowcnt = 1;
     paging.options["prop"].pagecnt = 100;
     paging.options["prop"].pagenow = 1;
     paging.options["prop"].blockcnt = 15;
     paging.options.context = "${pageContext.request.contextPath}";

     grid3.pager = new ksid.paging(paging.options);
     grid3.pager.parent = grid3;                    // 페이저 소속 GRID 를 지정한다.
     grid3.pager.selectFunc = doQueryDialogPaging;  // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
     grid3.pager.show();

}

function editpanelComboAjaxAfterDoQuery() {

    newJson = ksid.form.flushPanel('edit-panel');

    setTimeout(function() {
        doQuery();
    }, 700);

}

/*****************************************************
* 함수명: 기준할인 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    var params = {};

    ksid.net.ajaxJqGrid(grid1, "${pageContext.request.contextPath}/product/basicpromo/list", params, function(result) {
      doNew();

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "기준할인목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
       }

  });

}

/*****************************************************
* 함수명: 기준할인 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 기준할인 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson.mode = "I";

    // edit-panel에 newJson를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson.mode);

    //기준할인-고객사 그리드 초기화;
    grid2.initGridData();

    $("#edit-panel input[name=pbNm]").focus();

}

/*****************************************************
* 함수명: 기준할인 저장
* 설명   :
*****************************************************/
function doSave() {
  ksid.ui.confirm("기준할인을 저장하시겠습니까?", function() {
      if(ksid.form.validateForm("edit-panel")) {
          var params = ksid.form.flushPanel("edit-panel");

          var url = "";

          if(params.mode == "I") {
              url = "${pageContext.request.contextPath}/product/basicpromo/ins";
          } else if(params.mode == "U") {
              url = "${pageContext.request.contextPath}/product/basicpromo/upd";
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
* 함수명: 기준할인 삭제
* 설명   :
*****************************************************/
function doDelete() {
  ksid.ui.confirm("선택한 기준할인 삭제하시겠습니까?", function() {
      var rowId = $("#grid1").getGridParam("selrow");

      if(!rowId) {
          ksid.ui.alert("삭제할 기준할인 행을 선택하세요.");

          return;
      }

      var params = $("#grid1").getRowData(rowId);

      ksid.net.ajax("${pageContext.request.contextPath}/product/basicpromo/del", params, function(result) {
              doQuery();
      });
  });
}



/*****************************************************
* 함수명: 기준할인 목록 조회
* 설명   :
*****************************************************/
function doQuery2(resultMsg) {

    var params = {"pbId": grid1.clickedRowData.pbId};

    ksid.net.ajaxJqGrid(grid2, "${pageContext.request.contextPath}/product/basicpromo/list2", params, function(result) {

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "기준할인-고객사 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
       }

  });

}

/*****************************************************
* 함수명: 기준할인-고객사 저장
* 설명   :
*****************************************************/
function doSave2() {
    var selectedIds = $("#grid2").getGridParam('selarrrow');

    if (selectedIds.length == "0") {
        ksid.ui.alert("먼저 저장할 고객사를를 선택하세요.");
        return;
    }

    //에디트 0,0으로 grid를 속인다.
    $("#grid2").editCell(0, 0, true);

    //validateRow 체크
    if (!grid2.validateRow()) {
        return;
    }

    for (i = 0; i < selectedIds.length; i++) {
        $("#grid2").jqGrid('saveRow', selectedIds[i], true);
    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {
        var selectedData = $("#grid2").getRowData(selectedIds[i]);
        params.push(selectedData);
    }

    ksid.ui.confirm("해당 기준할인-고객사를 저장하시겠습니까?", function() {
        ksid.net.ajax("${pageContext.request.contextPath}/product/basicpromo/updCustList", JSON.stringify(params), function(result) {
            if (result.resultCd == "00") {
                doQuery2(result.resultData);
            }
        }, {contentType:"application/json; charset=UTF-8"});
    });
}

/*****************************************************
* 함수명: 기준할인 삭제
* 설명   :
*****************************************************/
function doDelete2() {
    var selectedIds = $("#grid2").getGridParam("selarrrow");

    if (selectedIds.length == 0) {

        ksid.ui.alert("선택한 고객사가 없습니다.<br />기준할인-고객사에 삭제할 고객사를 선택하세요");
        return;

    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {

        var selectedData = $("#grid2").getRowData(selectedIds[i]);

        var params_list_01 = {};

        params_list_01.pbId = selectedData.pbId;
        params_list_01.spCd = selectedData.spCd;
        params_list_01.custId = selectedData.custId;

        params.push(params_list_01);

    }

    ksid.ui.confirm(ksid.string.replace("선택하신 고객사를 기준할인[{0}]에서 삭제하시겠습니까?", "{0}", grid1.clickedRowData.pbNm), function() {
        ksid.net.ajaxMulti("${pageContext.request.contextPath}/product/basicpromo/delCustList", JSON.stringify(params), function(result) {
            if (result.resultCd == "00") {
                doQuery2(result.resultData);

            }
        });
    });
}

/*****************************************************
* 함수명: 기준할인-고객사 등록 팝업 오픈
* 설명   :
*****************************************************/
function doNew2() {

    if(grid1.clickedRowData == null) {

        ksid.ui.alert("고객사를 등록하시려면 먼저 왼쪽 기준할인목록에서 기준할인을 선택하세요.");
        return;

    }

    ksid.json.mergeObject(ksid.json.dialogProp, {title:"기준할인-고객사 등록", width:700, height:600});

    $("#dialog_basicpromo").dialog(ksid.json.dialogProp);

    grid3.loadGrid();

    doQueryDialog();

}

/*****************************************************
* 함수명: 팝업창에서 기준할인-고객사 조회
* 설명   :
*****************************************************/

function doQueryDialog() {

    grid3.pager.prop.pagenow = 1;

    doQueryDialogPaging();

}

function doQueryDialogPaging() {

    var params = ksid.form.flushPanel('dialog_basicpromo_search-panel');
    params.pbId = grid1.clickedRowData.pbId;

    params.pagecnt = grid3.pager.prop.pagecnt;
    params.pagenow = grid3.pager.prop.pagenow;

    ksid.net.ajaxJqGrid(grid3, "${pageContext.request.contextPath}/product/basicpromo/selCustList", params, function(result) {
    });

}

/*****************************************************
* 함수명: 팝업창에서 기준할인-고객사 선택 저장
* 설명   :
*****************************************************/
function doSaveDialog() {

    var selectedIds = $("#grid3").getGridParam("selarrrow");

    if( selectedIds.length == 0 ) {

        ksid.ui.alert("선택한 고객사 없습니다. 기준할인에 등록할 고객사를 선택하세요");
        return;

    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {

        var selectedData = $("#grid3").getRowData(selectedIds[i]);

        var params_list_01 = {};

        params_list_01.pbId         = grid1.clickedRowData.pbId;
        params_list_01.spCd         = selectedData.spCd;
        params_list_01.custId       = selectedData.custId;

        params.push(params_list_01);

    }

    //  ksid.debug.printObj("params", params);

    ksid.ui.confirm( ksid.string.replace( "선택하신 고객사를 기준할인[{0}]에 등록하시겠습니까?", "{0}", grid1.clickedRowData.pbNm ) , function() {

      ksid.net.ajax("${pageContext.request.contextPath}/product/basicpromo/insCustList", JSON.stringify(params), function(result) {

          if(result.resultCd == "00") {
              doQuery2(ksid.localization.string("정상적으로 저장되었습니다."));
              doQueryDialog();
              $('#dialog_basicpromo').dialog('close');
          }

      }, {contentType:"application/json; charset=UTF-8"});


    });

}

</script>

<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">시스템</span> > <span name="menu">권한관리</span></p>
    </div>

    <div class="variableWrapPromo">
        <!-- 왼쪽 컨텐츠  -->
        <div id="edit-panel" class="fLeft">
           <h3 class="style-title"><span name="title">기준할인정보</span></h3>

            <!-- 입력화면 시작 -->
            <div class="edit-panel">
                <input type="hidden" name="mode" value="I" />
                <div class="styleDlTable">
                    <dl>
                        <dt name="title" class="width80"><label for="authGroupCd">기준할인ID</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="20" class="style-input width120" name="pbId" title="기준할인ID" next="authGroupNm" disabled />
                        </dd>
                        <dt name="title" class="title_on width80"><label for="authGroupNm">기준할인명</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="20" class="style-input width120" name="pbNm" title="기준할인명" next="sortSeq" command="doSave()" required />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="">할인대상구분</label></dt>
                        <dd class="width130">
                            <select class="style-select width120" name="pbTargetFg" title="할인대상구분" codeGroupCd="PB_TARGET_FG"></select>
                        </dd>
                        <dt name="title" class="width80">할인대상유형</dt>
                        <dd class="width130">
                            <select class="style-select width120" name="pbTargetTp" title="기준할인대상유형" codeGroupCd="PB_TARGET_TP"></select>
                        </dd>
                        <dt name="title" class="width80"><label for="">대상유형수량</label></dt>
                        <dd>
                            <input type="text" class="style-input width80" name="pbTargetCnt" format="number" title="할인대상유형수량" value="0" />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="">할인금액유형</label></dt>
                        <dd class="width130">
                            <select class="style-select width120" name="pbPriceTp" title="할인금액유형" codeGroupCd="PB_PRICE_TP"></select>
                        </dd>
                        <dt name="title" class="width80">할인율</dt>
                        <dd class="width130">
                            <input type="text" class="style-input width60" name="saleRate" format="rate" title="할인율" value="0" />
                        </dd>
                        <dt name="title" class="width80"><label for="">할인금액</label></dt>
                        <dd>
                            <input type="text" class="style-input width80" name="salePrice" format="number" title="할인금액" value="0" />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="">시작일자</label></dt>
                        <dd class="width130">
                            <input type="text" class="style-input width80" name="stDtm" format="date" title="시작일자" setday="0" />
                        </dd>
                        <dt name="title" class="width80">종료일자</dt>
                        <dd class="width130">
                            <input type="text" class="style-input width80" name="edDtm" format="date" title="종료일자" setday="0" />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="remark">비고</label></dt>
                        <dd>
                            <input type="text" maxlength="300" class="style-input" name="remark" title="비고" style="width:560px" />
                        </dd>
                    </dl>
                </div>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
                    <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
                    <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
<!--                     <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button> -->
                </div>
                <!--// button bar  -->

            </div>

            <!-- 입력화면 끝 -->
            <h3 class="style-title"><span name="title">기준할인조회</span></h3>
            <!-- 그리드 시작 -->
            <table id="grid1" ></table>
            <!-- 그리드 끝 -->
        </div>
        <!--// 왼쪽 컨텐츠  -->

        <!-- 오른쪽 컨텐츠  -->
        <!-- 입력화면 시작 -->
        <div class="fRight">
            <div class="style-title-wrap bottom50Percentage">
                <h3 class="style-title"><span name="title">기준할인-고객사 등록</span></h3>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doNew2()">등록</button>
                    <button type="button" class="style-btn" auth="W" onclick="doSave2()">선택항목저장</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete2()">삭제</button>
                </div>
                <!--// button bar  -->
            </div>
            <table id="grid2" ></table>
        </div>
        <!--// 오른쪽 컨텐츠  -->
    </div>
</div>

<div id="dialog_basicpromo" style="display:none;" class="dialog">

    <!-- 버튼 시작 -->
    <div class="button-bar">
        <button type="button" onclick="doQueryDialog()" class="style-btn">조회</button>
        <button type="button" onclick="doSaveDialog()" class="style-btn">저장</button>
        <button type="button" onclick="$('#dialog_basicpromo').dialog('close')" class="style-btn">닫기</button>
    </div>
    <!-- 버튼 끝 -->

    <div id="dialog_basicpromo_search-panel" class="box_st1">
        <div style="padding:3px 0;">
            <fieldset>
                <legend>기준할인-고객사 조회</legend>
                <label for="">고객사명</label>
                <input type="text" name="custNm" title="고객사명" class="style-input width100"  command="doQueryDialog();" />
                <label for="">사업자번호</label>
                <input type="text" name="bizNo" title="사업자번호" class="style-input width100" format="biz_no" command="doQueryDialog();" />
            </fieldset>
        </div>
    </div>

    <!-- grid -->
    <table id="grid3" resize="false"></table>
    <div id="grid3_pager"></div>


</div>