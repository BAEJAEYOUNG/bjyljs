<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<script type="text/javascript" language="javascript">


//대분류신규JSON
var newLclsJson;

//상품신규JSON
var newMclsJson;

//대분류grid, 상품grid
var grid1,grid1;


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

     var colModelLCls = [];
     colModelLCls.push({ label: '상품코드',name: 'prodMclsCd',width:150,fixed:true});
     colModelLCls.push({ label: '상품명',name: 'prodMclsNm', format: 'string', width:150,fixed:true });
     colModelLCls.push({ label: '비고',name: 'remark', format: 'string', width:300, fixed:true });

     var gridProp = {};
     gridProp.colModel = colModelLCls;
     gridProp.shrinkToFit = true;
     gridProp.onSelectRow = function (rowId, status, e) {

         grid1.setClickedProp(rowId);

          var rowData = grid1.clickedRowData;
          rowData.mode = "U";

          ksid.form.bindPanel("edit-panel", rowData);

//         // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
          ksid.form.applyModeStyle("edit-panel", rowData.mode);
     };

     //관리자리스트 그리드 생성
     grid1 = new ksid.grid("grid1", gridProp);
     grid1.loadGrid();

     //대분류 중복체크
    $("#edit-panel input[name='prodLclsCd']").blur(function() {
          doCheckLcls("edit-panel", this);
          });
    //상품 중복체크
    $("#edit-panel input[name='prodLclsCd']").blur(function() {
        doCheckMcls("edit-panel", this);
    });
    //id 대문자로 변경
    $("input[name $='_cd']").blur(function() {
        var val = $(this).val();
        $(this).val(val.toUpperCase());
    });

    doQuery();

    newLclsJson = ksid.form.flushPanel('edit-panel');
    newMclsJson = ksid.form.flushPanel('edit-panel');

}

/*****************************************************
* 함수명: 상품 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    var params = ksid.form.flushPanel('search-panel');

    ksid.net.ajaxJqGrid(grid1, "${pageContext.request.contextPath}/product/cls/selMclsList", params, function(result) {
      doNew();

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "상품대분류코드 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
       }

  });

}


/*****************************************************
* 함수명: 상품 신규
* 설명   :
*****************************************************/
function doNew() {
  doNewDetail();
  $("#edit-panel input[name=prodMclsCd]").focus();
}

function doNewDetail() {

  newMclsJson.mode = "I";

  ksid.form.bindPanel("edit-panel", newMclsJson);

  // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
  ksid.form.applyModeStyle("edit-panel", newMclsJson.mode);
}

/*****************************************************
* 함수명: 상품 중복 조회
* 설명   :
*****************************************************/
function doCheckMcls(panelId, el) {
  var params = ksid.form.flushPanel(panelId);

  // 상품코드 가 없다면 체크안함
  if(ksid.string.trim(params.prodMclsCd) == "") return;

  ksid.net.ajax("${pageContext.request.contextPath}/product/cls/selMcls", params, function(result) {
      if(result.resultCd == "00" && result.resultData) {
          CommonJs.setStatus(  ksid.string.replace( "해당 상품코드[{0}]가 이미 존재합니다.", "{0}", params.prodMclsCd ) );
          $(el).val("").focus();
      }
  });
}

/*****************************************************
* 함수명: 상품 저장
* 설명   :
*****************************************************/
function doSave() {
  ksid.ui.confirm("상품를 저장하시겠습니까?", function() {
      if(ksid.form.validateForm("edit-panel")) {
          var params = ksid.form.flushPanel("edit-panel");

          var url = "";

          if(params.mode == "I") {
              url = "${pageContext.request.contextPath}/product/cls/insMcls";
          } else if(params.mode == "U") {
              url = "${pageContext.request.contextPath}/product/cls/updMcls";
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
* 함수명: 상품 삭제
* 설명   :
*****************************************************/
function doDelete() {

  var rowId = $("#grid1").getGridParam("selrow");

  if(!rowId) {
      ksid.ui.alert("삭제할 상품 행을 선택하세요.");

      return;
  }

  ksid.ui.confirm("선택한 상품를 삭제하시겠습니까?", function() {

      var params = $("#grid1").getRowData(rowId);

      ksid.net.ajax("${pageContext.request.contextPath}/product/cls/delMcls", params, function(result) {
          doQuery(result.resultData);
      });
  });
}

/*****************************************************
* 함수명: 상품목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel2() {

  var excelParams = {
      file_nm         : "상품목록",
      col_model       : grid1.getExcelColModel(),
      group_header    : null,
      data            : grid1.rows
  };

  ksid.net.ajaxExcelGrid(excelParams);

}
</script>

<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">상품관리</span> > <span name="menu">상품관리</span></p>
    </div>


    <!-- 검색조건 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title"><label for="codeGroupNm">상품코드/명</label></dt>
                <dd><input type="text" maxlength="100" class="style-input width133" name="prodMclsCd" title="상품코드" class="style-input" command="doQuery()" /></dd>
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
    <!-- 검색조건 끝 -->

    <h3 class="style-title"><span name="title">상품정보</span></h3>

    <div id="edit-panel" class="edit-panel">

        <div class="styleDlTable">

            <input type="hidden" name="mode" value="I" />

            <dl>
                <dt name="title" class="title_on width70"><label for="">상품코드</label></dt>
                <dd>
                    <input type="text" class="style-input width100" name="prodMclsCd" maxlength="40" title="상품코드" next="prodMclsNm" modestyle="enable" required />
                </dd>
                <dt name="title" class="width70"><label for="">상품명</label></dt>
                <dd class="width130">
                    <input type="text" class="style-input width120" name="prodMclsNm" maxlength="40" title="상품명" command="doSave()" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width70"><label for="remark">비고</label></dt>
                <dd>
                    <input type="text" class="style-input width330" name="remark" maxlength="280" style="width:333px;" title="비고" />
                </dd>
            </dl>
        </div>

    </div>

    <!-- 입력화면 끝 -->
    <h3 class="style-title"><span name="title">상품목록</span></h3>
    <!-- 그리드 시작 -->
    <table id="grid1" ></table>
    <!-- 그리드 끝 -->

</div>
