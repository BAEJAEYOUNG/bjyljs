<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<script type="text/javascript" language="javascript">


//신규JSON
var newJson;

//행사할인, 행사할인고객사, 행사할인고객사선택
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

     // 행사할인 그리드 생성
     var colModel = [];
     colModel.push({ label:'행사구분', name:'promoFg', hidden:true });
     colModel.push({ label:'할인금액유형', name:'promoPriceTp', hidden:true });
     colModel.push({ label:'등록자', name:'regId', hidden:true });
     colModel.push({ label:'변경자', name:'chgId', hidden:true });
     colModel.push({ label:'행사할인아이디', name:'promoId', hidden:true });

     colModel.push({ label:'행사할인명', name:'promoNm', format:'string', width:120 });
     colModel.push({ label:'행사구분', name:'promoFgNm', width:120 });
     colModel.push({ label:'행사할인금액유형', name:'promoPriceTpNm', width:120 });
     colModel.push({ label:'할인율', name:'saleRate', format:'rate', width:120 });
     colModel.push({ label:'할인금액', name:'salePrice', format:'number', width:120 });
     colModel.push({ label:'시작일자', name:'stDtm', format:'date', width:80 });
     colModel.push({ label:'종료일자', name:'edDtm', format:'date', width:80 });
     colModel.push({ label:'비고', name:'remark', format:'string', width:200 });
     colModel.push({ label:'등록일시', name:'regDtm', format:'dttm', width:120 });
     colModel.push({ label:'등록자', name:'regNm', width:120 });
     colModel.push({ label:'변경일시', name:'chgDtm', format:'dttm', width:120 });
     colModel.push({ label:'변경자', name:'chgNm', width:100 });

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


     //행사할인고객사 그리드 생성
     var colModel = [];
     colModel.push({ label:'서비스제공자코드', name:'spCd', hidden:true });
     colModel.push({ label:'고객사코드', name:'custId', hidden:true });
     colModel.push({ label:'행사할인아이디', name:'promoId', hidden:true });

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


     //행사할인고객사 그리드 생성
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
* 함수명: 행사할인 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    var params = {};

    ksid.net.ajaxJqGrid(grid1, "${pageContext.request.contextPath}/product/eventpromo/list", params, function(result) {
      doNew();

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "행사할인목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
       }

  });

}

/*****************************************************
* 함수명: 행사할인 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 행사할인 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson.mode = "I";

    // edit-panel에 newJson를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson.mode);

    //행사할인-고객사 그리드 초기화;
    grid2.initGridData();

    $("#edit-panel input[name=promoNm]").focus();

}

/*****************************************************
* 함수명: 행사할인 저장
* 설명   :
*****************************************************/
function doSave() {
  ksid.ui.confirm("행사할인을 저장하시겠습니까?", function() {
      if(ksid.form.validateForm("edit-panel")) {
          var params = ksid.form.flushPanel("edit-panel");

          var url = "";

          if(params.mode == "I") {
              url = "${pageContext.request.contextPath}/product/eventpromo/ins";
          } else if(params.mode == "U") {
              url = "${pageContext.request.contextPath}/product/eventpromo/upd";
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
* 함수명: 행사할인 삭제
* 설명   :
*****************************************************/
function doDelete() {
  ksid.ui.confirm("선택한 행사할인 삭제하시겠습니까?", function() {
      var rowId = $("#grid1").getGridParam("selrow");

      if(!rowId) {
          ksid.ui.alert("삭제할 행사할인 행을 선택하세요.");

          return;
      }

      var params = $("#grid1").getRowData(rowId);

      ksid.net.ajax("${pageContext.request.contextPath}/product/eventpromo/del", params, function(result) {
              doQuery();
      });
  });
}



/*****************************************************
* 함수명: 행사할인 목록 조회
* 설명   :
*****************************************************/
function doQuery2(resultMsg) {

    var params = {"promoId": grid1.clickedRowData.promoId};

    ksid.net.ajaxJqGrid(grid2, "${pageContext.request.contextPath}/product/eventpromo/list2", params, function(result) {

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "행사할인-고객사 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
       }

  });

}

/*****************************************************
* 함수명: 행사할인-고객사 저장
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

    ksid.ui.confirm("해당 행사할인-고객사를 저장하시겠습니까?", function() {
        ksid.net.ajax("${pageContext.request.contextPath}/product/eventpromo/updCustList", JSON.stringify(params), function(result) {
            if (result.resultCd == "00") {
                doQuery2(result.resultData);
            }
        }, {contentType:"application/json; charset=UTF-8"});
    });
}

/*****************************************************
* 함수명: 행사할인 삭제
* 설명   :
*****************************************************/
function doDelete2() {
    var selectedIds = $("#grid2").getGridParam("selarrrow");

    if (selectedIds.length == 0) {

        ksid.ui.alert("선택한 고객사가 없습니다.<br />행사할인-고객사에 삭제할 고객사를 선택하세요");
        return;

    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {

        var selectedData = $("#grid2").getRowData(selectedIds[i]);

        var params_list_01 = {};

        params_list_01.promoId = selectedData.promoId;
        params_list_01.spCd = selectedData.spCd;
        params_list_01.custId = selectedData.custId;

        params.push(params_list_01);

    }

    ksid.ui.confirm(ksid.string.replace("선택하신 고객사를 행사할인[{0}]에서 삭제하시겠습니까?", "{0}", grid1.clickedRowData.promoNm), function() {
        ksid.net.ajaxMulti("${pageContext.request.contextPath}/product/eventpromo/delCustList", JSON.stringify(params), function(result) {
            if (result.resultCd == "00") {
                doQuery2(result.resultData);

            }
        });
    });
}

/*****************************************************
* 함수명: 행사할인-고객사 등록 팝업 오픈
* 설명   :
*****************************************************/
function doNew2() {

    if(grid1.clickedRowData == null) {

        ksid.ui.alert("고객사를 등록하시려면 먼저 왼쪽 행사할인목록에서 행사할인을 선택하세요.");
        return;

    }

    ksid.json.mergeObject(ksid.json.dialogProp, {title:"행사할인-고객사 등록", width:700, height:600});

    $("#dialog_eventpromo").dialog(ksid.json.dialogProp);

    grid3.loadGrid();

    doQueryDialog();

}

/*****************************************************
* 함수명: 팝업창에서 행사할인-고객사 조회
* 설명   :
*****************************************************/

function doQueryDialog() {

    grid3.pager.prop.pagenow = 1;

    doQueryDialogPaging();

}

function doQueryDialogPaging() {

    var params = ksid.form.flushPanel('dialog_eventpromo_search-panel');
    params.promoId = grid1.clickedRowData.promoId;

    params.pagecnt = grid3.pager.prop.pagecnt;
    params.pagenow = grid3.pager.prop.pagenow;

    ksid.net.ajaxJqGrid(grid3, "${pageContext.request.contextPath}/product/eventpromo/selCustList", params, function(result) {
    });

}

/*****************************************************
* 함수명: 팝업창에서 행사할인-고객사 선택 저장
* 설명   :
*****************************************************/
function doSaveDialog() {

    var selectedIds = $("#grid3").getGridParam("selarrrow");

    if( selectedIds.length == 0 ) {

        ksid.ui.alert("선택한 고객사 없습니다. 행사할인에 등록할 고객사를 선택하세요");
        return;

    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {

        var selectedData = $("#grid3").getRowData(selectedIds[i]);

        var params_list_01 = {};

        params_list_01.promoId         = grid1.clickedRowData.promoId;
        params_list_01.spCd         = selectedData.spCd;
        params_list_01.custId       = selectedData.custId;

        params.push(params_list_01);

    }

    //  ksid.debug.printObj("params", params);

    ksid.ui.confirm( ksid.string.replace( "선택하신 고객사를 행사할인[{0}]에 등록하시겠습니까?", "{0}", grid1.clickedRowData.promoNm ) , function() {

      ksid.net.ajax("${pageContext.request.contextPath}/product/eventpromo/insCustList", JSON.stringify(params), function(result) {

          if(result.resultCd == "00") {
              doQuery2(ksid.localization.string("정상적으로 저장되었습니다."));
              doQueryDialog();
              $('#dialog_eventpromo').dialog('close');
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
           <h3 class="style-title"><span name="title">행사할인정보</span></h3>

            <!-- 입력화면 시작 -->
            <div class="edit-panel">
                <input type="hidden" name="mode" value="I" />
                <div class="styleDlTable">
                    <dl>
                        <dt name="title" class="width80"><label for="">행사할인ID</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="20" class="style-input width120" name="promoId" title="행사할인ID" disabled />
                        </dd>
                        <dt name="title" class="title_on width80"><label for="">행사할인명</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="20" class="style-input width120" name="promoNm" title="행사할인명" command="doSave()" required />
                        </dd>
                        <dt name="title" class="width80"><label for="">행사구분</label></dt>
                        <dd class="width130">
                            <select class="style-select width120" name="promoFg" title="행사구분" codeGroupCd="PROMO_FG"></select>
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="">할인금액유형</label></dt>
                        <dd class="width130">
                            <select class="style-select width120" name="promoPriceTp" title="할인금액유형" codeGroupCd="PROMO_PRICE_TP"></select>
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
            <h3 class="style-title"><span name="title">행사할인조회</span></h3>
            <!-- 그리드 시작 -->
            <table id="grid1" ></table>
            <!-- 그리드 끝 -->
        </div>
        <!--// 왼쪽 컨텐츠  -->

        <!-- 오른쪽 컨텐츠  -->
        <!-- 입력화면 시작 -->
        <div class="fRight">
            <div class="style-title-wrap bottom50Percentage">
                <h3 class="style-title"><span name="title">행사할인-고객사 등록</span></h3>
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

<div id="dialog_eventpromo" style="display:none;" class="dialog">

    <!-- 버튼 시작 -->
    <div class="button-bar">
        <button type="button" onclick="doQueryDialog()" class="style-btn">조회</button>
        <button type="button" onclick="doSaveDialog()" class="style-btn">저장</button>
        <button type="button" onclick="$('#dialog_eventpromo').dialog('close')" class="style-btn">닫기</button>
    </div>
    <!-- 버튼 끝 -->

    <div id="dialog_eventpromo_search-panel" class="box_st1">
        <div style="padding:3px 0;">
            <fieldset>
                <legend>행사할인-고객사 조회</legend>
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