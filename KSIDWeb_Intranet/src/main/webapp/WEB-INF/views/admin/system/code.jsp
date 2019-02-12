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

     var colModelGroup = [];
     colModelGroup.push({ label: '코드그룹유형', name: 'codeGroupType', hidden: true});
     colModelGroup.push({ label: '사용여부', name: 'useYn', hidden: true });
     colModelGroup.push({ label: '코드그룹ID', name: 'codeGroupCd',format: 'string',width:130 });
     colModelGroup.push({ label: '코드그룹명', name: 'codeGroupNm',format: 'string',width:100 });
     colModelGroup.push({ label: '코드그룹유형', name: 'codeGroupTypeNm', width:80});
     colModelGroup.push({ label: '사용여부', name: 'useYnNm', width:60});
     colModelGroup.push({ label: '비고',name: 'remark',format: 'string', width:300});

     var gridProp = {};
     gridProp.colModel = colModelGroup;
     gridProp.shrinkToFit = false;
     gridProp.onSelectRow = function (rowId, status, e) {
         grid1.setClickedProp(rowId);

         var rowData = grid1.clickedRowData;

         rowData.mode = "U";

         // group-edit-panel에 rowData binding 한다.
         ksid.form.bindPanel("group-edit-panel", rowData);

         // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
         ksid.form.applyModeStyle("group-edit-panel", rowData.mode);

         //코드목록조회
         doQuery2();
     };

     //관리자리스트 그리드 생성
     grid1 = new ksid.grid("grid1", gridProp);
     grid1.loadGrid();


     var colModelCode = [];
     colModelCode.push({ label: '코드그룹ID',name: 'codeGroupCd', hidden: true});
     colModelCode.push({ label: '코드유형',name: 'codeType',hidden: true});
     colModelCode.push({ label: '공통코드',name: 'codeCd', width:60,fixed:true });
     colModelCode.push({ label: '코드명',name: 'codeNm',format: 'string', width:120, fixed:true });
     colModelCode.push({ label: '코드유형',name: 'codeTypeNm', width:60,fixed:true });
     colModelCode.push({ label: '정렬순번',name: 'sortSeq',format: 'number', width:60,fixed:true });
     colModelCode.push({ label: '사용여부',name: 'useYnNm',width:60,fixed:true });
     colModelCode.push({ label: '비고',name: 'remark',format: 'string', width:300});

     var gridProp = {};
     gridProp.colModel = colModelCode;
     gridProp.shrinkToFit = true;
     gridProp.onSelectRow = function (rowId, status, e) {
         grid2.setClickedProp(rowId);

         var rowData = grid2.clickedRowData;
         rowData.mode = "U";

         ksid.form.bindPanel("cd-edit-panel", rowData);

        // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
         ksid.form.applyModeStyle("cd-edit-panel", rowData.mode);
     };

     //관리자리스트 그리드 생성
     grid2 = new ksid.grid("grid2", gridProp);
     grid2.loadGrid();

     //코드그룹 중복체크
    $("#group-edit-panel input[name='codeGroupCd']").blur(function() {
          doCheckCdGroup("group-edit-panel", this);
          });
    //코드 중복체크
    $("#cd-edit-panel input[name='codeCd']").blur(function() {
        doCheckCd("cd-edit-panel", this);
    });
    //id 대문자로 변경
    $("input[name $='_cd']").blur(function() {
        var val = $(this).val();
        $(this).val(val.toUpperCase());
    });

}

var lb_loaded = false;

/*****************************************************
* 함수명: 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function groupeditpanelComboAjaxAfterDoQuery() {

  //코드그룹신규JSON 생성
  newGroupJson = ksid.form.flushPanel("group-edit-panel");

//   console.log("groupeditpanelComboAjaxAfterDoQuery > lb_loaded = " + lb_loaded);

  if( lb_loaded == false ) {

      lb_loaded = true;

  } else {

      doQuery();

  }

}


/*****************************************************
* 함수명: 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/

function cdeditpanelComboAjaxAfterDoQuery() {

  //코드신규JSON 생성
  newCdJson = ksid.form.flushPanel("cd-edit-panel");

//   console.log("cdeditpanelComboAjaxAfterDoQuery > lb_loaded = " + lb_loaded);

  if( lb_loaded == false ) {

      lb_loaded = true;

  } else {

      doQuery();

  }

}


/*****************************************************
* 함수명: 코드그룹 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

  // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
  var params = ksid.form.flushPanel("search-panel");

  // get_code_group_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
  ksid.net.ajaxJqGrid(grid1, "admin/system/code/selGroupList", params, function(result) {

      //코드그룹 입력 폼 초기화
      doNew();

      //코드그리드 초기화;
      grid2.initGridData();

      //코드 입력 폼 초기화
      doNewDetail();

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "코드그룹 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
          CommonJs.searchMsg(result);
      }

      $("#search-panel input[name=codeGroupNm]").focus();

  });

}

/*****************************************************
* 함수명: 코드그룹 신규
*****************************************************/
function doNew() {

  grid1.reload();

  // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
  newGroupJson.mode = "I";

  //정렬순번을 10 단위로 세팅한다.
  newGroupJson.sortSeq = ( $("#grid1").jqGrid('getDataIDs').length + 1 ) * 10;

  // group-edit-panel에 newGroupJson를 binding 한다.
  ksid.form.bindPanel("group-edit-panel", newGroupJson);

  // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
  ksid.form.applyModeStyle("group-edit-panel", newGroupJson.mode);

  //코드그리드 초기화;
  grid2.initGridData();

  //코드 입력 폼 초기화
  doNewDetail();

  $("#group-edit-panel input[name=codeGroupCd]").focus();

}

/*****************************************************
* 함수명: 코드그룹 중복 조회
* 설명   :
*****************************************************/
function doCheckCdGroup(panelId, el) {
  var params = ksid.form.flushPanel("group-edit-panel");

  // 코드그룹id 가 없다면 return
  if(ksid.string.trim(params.codeGroupCd) == "") return;

  ksid.net.ajax("${pageContext.request.contextPath}/admin/system/code/selGroup", params, function(result) {
      if(result.resultCd == "00" && result.resultData) {
          CommonJs.setStatus(  ksid.string.replace( "해당 코드그룹아이디[{0}]가 이미 존재합니다.", "{0}", params.codeGroupCd ) );
          $(el).val("").focus();
      }
  });
}

/*****************************************************
* 함수명: 코드그룹 저장
* 설명   :
*****************************************************/
function doSave() {
  ksid.ui.confirm("코드그룹을 저장하시겠습니까?", function() {
      if(ksid.form.validateForm("group-edit-panel")) {
          var params = ksid.form.flushPanel("group-edit-panel");

          var url = "";

          if(params.mode == "I") {
              url = "${pageContext.request.contextPath}/admin/system/code/insGroup";
          } else if(params.mode == "U") {
              url = "${pageContext.request.contextPath}/admin/system/code/updGroup";
          }

          ksid.net.ajax(url, params, function(result) {

              if(result.resultCd == "00") {
                  doQuery("코드그룹이 정상적으로 저장되었습니다.");
               }

          });
      }
  });
}

/*****************************************************
* 함수명: 코드그룹 삭제
* 설명   :
*****************************************************/
function doDelete() {
  ksid.ui.confirm("정말 선택한 코드그룹을 삭제하시겠습니까?", function() {
      ksid.ui.confirm("정말 선택한 코드그룹을 삭제하시겠습니까?<br />확인하시면 해당 코드그룹 하위 모든 코드가 삭제됩니다.", function() {
          var rowId = $("#grid1").getGridParam("selrow");

          if(!rowId) {
              ksid.ui.alert("삭제할 코드그룹 행을 선택하세요.");

              return;
          }

          var params = {};
          params.codeGroupCd = $("#grid1").getRowData(rowId).codeGroupCd;

          ksid.net.ajax("${pageContext.request.contextPath}/admin/system/code/delGroup", params, function(result) {
              if(result.resultCd == "00") {
                  doQuery("코드그룹이 정상적으로 삭제되었습니다.");
              }
          });
      });
  });
}

/*****************************************************
* 함수명: 코드 목록 조회
* 설명   :
*****************************************************/
function doQuery2(resultMsg) {

    if(grid1.clickedRowData == null) {
        ksid.ui.alert("코드그룹이 선택되지 않았습니다.");
        return;
    }

    var params = {};
    params.codeGroupCd = grid1.clickedRowData.codeGroupCd;

  ksid.net.ajaxJqGrid(grid2, "${pageContext.request.contextPath}/admin/system/code/selCodeList", params, function(result) {

      doNew2();

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "코드 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
       }

  });

}


/*****************************************************
* 함수명: 코드 신규
* 설명   :
*****************************************************/
function doNew2() {
  doNewDetail();
  $("#cd-edit-panel input[name=codeCd]").focus();
}
function doNewDetail() {

  var rowId = $("#grid1").getGridParam("selrow");
  var rowData = $("#grid1").getRowData(rowId);

  newCdJson.codeGroupCd = rowData.codeGroupCd;
  newCdJson.mode = "I";

  //정렬순번을 10 단위로 세팅한다.
  newCdJson.sortSeq = ( $("#grid2").jqGrid('getDataIDs').length + 1 ) * 10;

  ksid.form.bindPanel("cd-edit-panel", newCdJson);

  // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
  ksid.form.applyModeStyle("cd-edit-panel", newCdJson.mode);
}

/*****************************************************
* 함수명: 코드 중복 조회
* 설명   :
*****************************************************/
function doCheckCd(panelId, el) {
  var params = ksid.form.flushPanel(panelId);

  if(params.codeGroupCd == "") {
      ksid.ui.alert("코드그룹이 선택되지 않았습니다.");
      return;
  }

  // 코드id 가 없다면 체크안함
  if(ksid.string.trim(params.codeCd) == "") return;

  ksid.net.ajax("${pageContext.request.contextPath}/admin/system/code/selCode", params, function(result) {
      if(result.resultCd == "00" && result.resultData) {
          CommonJs.setStatus(  ksid.string.replace( "해당 코드아이디[{0}]가 이미 존재합니다.", "{0}", params.codeCd ) );
          $(el).val("").focus();
      }
  });
}

/*****************************************************
* 함수명: 코드 저장
* 설명   :
*****************************************************/
function doSave2() {
  ksid.ui.confirm("코드를 저장하시겠습니까?", function() {
      if(ksid.form.validateForm("cd-edit-panel")) {
          var params = ksid.form.flushPanel("cd-edit-panel");

          var url = "";

          if(params.mode == "I") {
              url = "${pageContext.request.contextPath}/admin/system/code/insCode";
          } else if(params.mode == "U") {
              url = "${pageContext.request.contextPath}/admin/system/code/updCode";
          }

          ksid.net.ajax(url, params, function(result) {
              if(result.resultCd == "00") {
                  doQuery2("코드가 정상적으로 저장되었습니다.");
              }
          });
      }
  });
}

/*****************************************************
* 함수명: 코드 삭제
* 설명   :
*****************************************************/
function doDelete2() {

  var rowId = $("#grid2").getGridParam("selrow");

  if(!rowId) {
      ksid.ui.alert("삭제할 코드 행을 선택하세요.");

      return;
  }

  ksid.ui.confirm("선택한 코드를 삭제하시겠습니까?", function() {

      var params = $("#grid2").getRowData(rowId);

      ksid.net.ajax("${pageContext.request.contextPath}/admin/system/code/delCode", params, function(result) {
          doQuery2("해당 코드가 정상적으로 삭제되었습니다.");
      });
  });
}


/*****************************************************
* 함수명: 코드그룹목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {
}

/*****************************************************
* 함수명: 코드목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel2() {

  var rowId = $("#grid1").getGridParam("selrow"); // 선택한 코드그룹 rowId 가져오기

  if(!rowId) {
      ksid.ui.alert("코드그룹을 선택하신 후 해당 코드리스트를 엑셀다운로드 하세요.");

      return;
  }

  var excelParams = {
      file_nm         : "코드목록" + "(" + grid1.clickedRowData.codeGroupCd + ")",
      col_model       : grid2.getExcelColModel(),
      group_header    : null,
      data            : grid2.rows
  };

  ksid.net.ajaxExcelGrid(excelParams);

}

// function doTest() {

//     ksid.net.ajax("${pageContext.request.contextPath}/admin/system/code/test", {}, function(result) {
//         console.log(result);
//     });

// }
</script>

<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">시스템</span> > <span name="menu">공통코드관리</span></p>
    </div>


    <!-- 검색조건 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title"><label for="codeGroupNm">코드그룹</label></dt>
                <dd><input type="text" maxlength="100" class="style-input width133" name="codeGroupNm" title="코드그룸id 또는 코드그룹명" class="style-input" command="doQuery()" /></dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
<!--             <button type="button" class="style-btn" auth="R" onclick="doTest()">selValueTest</button> -->
        </div>
        <!--// button bar  -->
    </div>
    <!-- 검색조건 끝 -->

    <div class="variableWrapCode">
        <!-- 왼쪽 컨텐츠  -->
        <div class="fLeft">
           <h3 class="style-title"><span name="title">코드그룹정보</span></h3>

            <!-- 입력화면 시작 -->
            <div class="edit-panel">

                <div id="group-edit-panel" class="styleDlTable">

                    <input type="hidden" name="mode" value="I" />

                    <dl>
                        <dt name="title" class="title_on width80"><label for="">코드그룹ID</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="20" class="style-input width120" name="codeGroupCd" title="코드그룹ID" next="codeGroupNm" modestyle="enable" required />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="title_on width80"><label for="">코드그룹명</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="100" class="style-input width120" name="codeGroupNm" title="코드그룹명" command="doSave()" required />
                        </dd>
                        <dt name="title" class="width90"><label for="">코드그룹유형</label></dt>
                        <dd>
                            <select class="style-select width100" name="codeGroupType" title="코드그룹유형" codeGroupCd="code_group_type" selected_value="N" required></select>
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="useYn">사용여부</label></dt>
                        <dd>
                            <select class="style-select width100" name="useYn" title="사용여부" codeGroupCd="use_yn" selected_value="Y" required></select>
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="remark">비고</label></dt>
                        <dd>
                            <input type="text" maxlength="300" class="style-input width360" name="remark" title="비고" />
                        </dd>
                    </dl>
                </div>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
                    <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
<!--                     <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button> -->
                </div>
                <!--// button bar  -->

            </div>

            <!-- 입력화면 끝 -->
            <h3 class="style-title"><span name="title">코드그룹목록</span></h3>
            <!-- 그리드 시작 -->
            <table id="grid1" ></table>
            <!-- 그리드 끝 -->
        </div>
        <!--// 왼쪽 컨텐츠  -->

        <!-- 오른쪽 컨텐츠  -->
        <!-- 입력화면 시작 -->
        <div class="fRight">
            <h3 class="style-title"><span name="title">코드정보</span></h3>

            <div class="edit-panel" style="min-width:422px;">

                <div id="cd-edit-panel" class="styleDlTable">

                    <input type="hidden" name="mode" value="I" />
                    <input type="hidden" name="code_lvl" value="1" />

                    <dl>
                        <dt name="title" class="title_on width80"><label for="">코드그룹ID</label></dt>
                        <dd class="width130">
                            <input type="text" class="style-input width120" name="codeGroupCd" maxlength="20" title="코드그룹ID" disabled required />
                        </dd>
                        <dt name="title" class="title_on width80"><label for="">코드ID</label></dt>
                        <dd>
                            <input type="text" class="style-input width120" name="codeCd" maxlength="20" title="코드ID" next="codeNm" modestyle="enable" required />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="">코드명</label></dt>
                        <dd class="width130">
                            <input type="text" class="style-input width120" name="codeNm" maxlength="100" title="코드명" command="doSave2()" />
                        </dd>
                        <dt name="title" class="title_on width80" ><label for="">코드유형</label></dt>
                        <dd>
                            <select class="style-select width110" name="codeType" title="코드유형" codeGroupCd="code_type" required></select>
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="">정렬순번</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="200" class="style-input width80" name="sortSeq" format="number" title="정렬순번" />
                        </dd>
                        <dt name="title" class="width80"><label for="useYn">사용여부</label></dt>
                        <dd>
                            <select class="style-select width110" name="useYn" title="사용여부" codeGroupCd="use_yn" required></select>
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="width80"><label for="remark">비고</label></dt>
                        <dd>
                            <input type="text" class="style-input width350" name="remark" maxlength="300" title="비고" />
                        </dd>
                    </dl>
                </div>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doNew2()">신규</button>
                    <button type="button" class="style-btn" auth="W" onclick="doSave2()">저장</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete2()">삭제</button>
<!--                     <button type="button" class="style-btn" auth="P" onclick="doExcel2()">출력</button> -->
                </div>
                <!--// button bar  -->
            </div>

            <!-- 입력화면 끝 -->
            <h3 class="style-title"><span name="title">코드목록</span></h3>
            <!-- 그리드 시작 -->
            <table id="grid2" ></table>
            <!-- 그리드 끝 -->

        </div>
        <!--// 오른쪽 컨텐츠  -->
    </div>
</div>
