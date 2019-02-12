<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<style type="text/css">
.dialog .button-bar {
    margin-top: 2px;
    margin-bottom: 10px;
}
</style>

<script type="text/javascript" language="javascript">
//권한그룹신규JSON
var newJson1;

//권한그룹grid, 권한그룹-관리자grid, 권한그룹-메뉴grid
var grid1,grid2,grid3;

var menuType;

var dialog2W  = 900;
var dialog2H  = 600;

var dialog1W  = 700;
var dialog1H  = 500;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {
  //권한그룹 그리드 생성
  grid1 = new ksid.grid("grid1",
      {
          colModel: [

              { label: '사용여부',         name: 'useYn',                   hidden: true     },

              { label: '권한그룹코드',     name: 'authGroupCd',            format: 'string' , width:80 },
              { label: '권한그룹명',       name: 'authGroupNm',            format: 'string' , width:80 },
              { label: '정렬순번',         name: 'sortSeq',                format: 'number' , width:60  },
              { label: '비고',             name: 'remark',                 format: 'string' , width:200 }

           ],
           shrinkToFit: false,
           height: 100,
           onSelectRow: function (rowId, status, e) {

                  grid1.setClickedProp(rowId);

                  var rowData = grid1.clickedRowData;

                  rowData.mode = "U";

                  // edit-panel에 rowData binding 한다.
                  ksid.form.bindPanel("edit-panel", rowData);

                  // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
                  ksid.form.applyModeStyle("edit-panel", rowData.mode);

                  //권한그룹-관리자 조회
                  doQuery2();

                  //권한그룹-메뉴 조회
                  doQuery3();
           }
      }
  );

  grid1.loadGrid();

  //권한그룹-관리자 그리드 생성
  grid2 = new ksid.grid("grid2",
      {
          colModel: [

              { label: '관리자유형',      name: 'adminTpNm',  format: 'string' , width:130 },
              { label: '서비스제공자',     name: 'spNm',      format: 'string' , width:120 },
              { label: '고객사',           name: 'custNm',    format: 'string' , width:120 },
              { label: '관리자아이디',     name: 'adminId',   format: 'string' , width:100 },
              { label: '관리자명',         name: 'adminNm',   format: 'string' , width:100 },
              { label: '휴대폰번호',       name: 'hpNo',      format: 'tel_no' , width:100 }

          ],
          shrinkToFit: false,
          height: 160,
          multiselect: true
      }
  );

  grid2.loadGrid();

  var paramsMenuType = { "codeGroupCd":"MENU_TYPE" };
  ksid.net.sjax("${pageContext.request.contextPath}/admin/system/code/comboList", paramsMenuType, function(result) {

      if( result.resultData.length > 0 ) {

          menuType = "";

          for (var i = 0; i < result.resultData.length; i++) {

              if(i == result.resultData.length-1){
                  menuType += result.resultData[i].codeCd + ":" + result.resultData[i].codeNm;
              }else{
                  menuType += result.resultData[i].codeCd + ":" + result.resultData[i].codeNm + ";";
              }

          }

      }

  });

//   colModel: [

//              { label: '멘뉴아이디',       name: 'menuId',          hidden: true     },
//              { label: '권한그룹코드',     name: 'authGroupCd',      hidden: true     },

//              { label: '상위메뉴아이디',   name: 'refMenuId',        width:100,  editable:true, edittype:'text', editrules:{required:true}       },
//              { label: '상위메뉴명',       name: 'refMenuNm',       format: 'string' ,   width:80 },
//              { label: '메뉴아이디',       name: 'menuId',          width:80 },
//              { label: '메뉴명',           name: 'menuNm',         format: 'string' ,   width:160,  editable:true, edittype:'text', editrules:{required:true}       },
//              { label: '메뉴유형',         name: 'menuType',       width:60,   editable:true, editrules:{required:true}, edittype:"select", formatter: "select", editoptions:{value:menuType}},
//              { label: '실행명령',         name: 'execCmd',         format: 'string' ,   width:150,  editable:true, edittype:'text', editrules:{required:true} },
//              { label: '읽기',             name: 'authR',                                width:40,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    },
//              { label: '저장',             name: 'authW',                                width:40,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    },
//              { label: '삭제',             name: 'authD',                                width:40,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    },
//              { label: '인쇄',             name: 'authP',                                width:40,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    },
//              { label: '메뉴레벨',         name: 'menuLvl',                              width:60,   editable:true, editrules:{number:true, required:true}          },
//              { label: '정렬순번',         name: 'sortSeq',         format: 'number' ,   width:60,   editable:true, editrules:{number:true, required:true}          },
//              { label: '사용여부',         name: 'useYn',                                width:60,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    }

//              ],
  //권한그룹-메뉴 그리드 생성
  grid3 = new ksid.grid("grid3",
      {
          colModel: [

              { label: '멘뉴아이디',       name: 'menuId',          hidden: true     },
              { label: '권한그룹코드',     name: 'authGroupCd',     hidden: true     },

              { label: '상위메뉴아이디',   name: 'refMenuId',       width:100,  editable:true, edittype:'text', editrules:{required:true}       },
              { label: '상위메뉴명',       name: 'refMenuNm',       format: 'string' ,   width:80 },
              { label: '메뉴아이디',       name: 'menuId',          width:80 },
              { label: '메뉴명',           name: 'menuNm',          format: 'string' ,   width:160,  editable:true, edittype:'text', editrules:{required:true}       },
              { label: '메뉴유형',         name: 'menuType',        width:60,   editable:true, editrules:{required:true}, edittype:"select", formatter: "select", editoptions:{value:menuType}},
              { label: '실행명령',         name: 'execCmd',         format: 'string' ,   width:150,  editable:true, edittype:'text', editrules:{required:true} },
              { label: '읽기',             name: 'authR',                                width:40,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    },
              { label: '저장',             name: 'authW',                                width:40,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    },
              { label: '삭제',             name: 'authD',                                width:40,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    },
              { label: '인쇄',             name: 'authP',                                width:40,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    },
              { label: '메뉴레벨',         name: 'menuLvl',                              width:60,   editable:true, editrules:{number:true, required:true}          },
              { label: '정렬순번',         name: 'sortSeq',         format: 'number' ,   width:60,   editable:true, editrules:{number:true, required:true}          },
              { label: '사용여부',         name: 'useYn',                                width:60,   editable:true, edittype:'checkbox',editoptions:{value:'Y:N'}    }

              ],
          shrinkToFit: false,
          multiselect: true,
          cellsubmit: "clientArray",  // 클라이언트에서 처리
          cellEdit: true,             //  셀의 값변경을 정함 트루하면 바껴짐
          afterEditCell: function (id,name,val,iRow,iCol){
          },
          afterSaveCell : function(rowid,name,val,iRow,iCol) {

          }
      }
  );

  grid3.loadGrid();

  //권한그룹 중복체크
  $("#edit-panel input[name='authGroupCd']").blur(function() {
      var val = $(this).val();
      $(this).val(val.toLowerCase());    // 소문자로 변경
      doCheckAuthGroup("edit-panel", this);
  });


  //권한그룹-관리자 팝업 그리드 생성
  grid4 = new ksid.grid("grid4",
      {
          colModel: [

              { label: '관리자유형',       name: 'adminTpNm',  format: 'string' , width:130 },
              { label: '서비스제공자',     name: 'spNm',       format: 'string' , width:120 },
              { label: '고객사',           name: 'custNm',     format: 'string' , width:120 },
              { label: '관리자아이디',     name: 'adminId',    format: 'string' , width:100 },
              { label: '관리자명',         name: 'adminNm',    format: 'string' , width:100 },
              { label: '휴대폰번호',       name: 'hpNo',       format: 'tel_no' , width:100 }

          ],
          shrinkToFit: true,
          multiselect: true,
          height: 375
      }
  );




  //권한그룹-메뉴 팝업 그리드 생성
  grid5 = new ksid.grid("grid5",
      {
          colModel: [

              { label: '멘뉴아이디',       name: 'menuId',           hidden: true     },

              { label: '상위메뉴아이디',   name: 'refMenuId',                           width:100 },
              { label: '상위메뉴명',       name: 'refMenuNm',        format: 'string' , width:100 },
              { label: '메뉴아이디',       name: 'menuId',                              width:100 },
              { label: '메뉴명',           name: 'menuNm',           format: 'string' , width:130 },
              { label: '메뉴유형',         name: 'menuTypeNm',                          width:60  },
              { label: '실행명령',         name: 'execCmd',          format: 'string' , width:200 },
              { label: '메뉴레벨',         name: 'menuLvl',                             width:60  },
              { label: '정렬순번',         name: 'sortSeq',          format: 'number' , width:60  },
              { label: '사용여부',         name: 'useYnNm',                             width:60  }

              ],
          shrinkToFit: false,
          multiselect: true,
          height: 475
      }
  );

  //setDialogWH();

}

function setDialogWH() {

//   $("#grid4").jqGrid('setGridWidth', dialog1W-2);
//   $("#grid4").jqGrid('setGridHeight', dialog1H-110);

//   $("#grid5").jqGrid('setGridWidth', dialog2W-2);
//   $("#grid5").jqGrid('setGridHeight', dialog2H-110);

}

/*****************************************************
* 함수명: 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function editpanelComboAjaxAfterDoQuery() {

    //관리자정보 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

    doQuery();


}

/*****************************************************
* 함수명: 권한그룹 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

  // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
  var params = ksid.form.flushPanel("search-panel");

//   alert('${pageContext.request.contextPath}');

  // get_auth_group_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
  ksid.net.ajaxJqGrid(grid1, "${pageContext.request.contextPath}/admin/system/auth/list", params, function(result) {

      //권한그룹 입력 폼 초기화
      doNew();

      //권한그룹-관리자 그리드 초기화;
      grid2.initGridData();

      //권한그룹-메뉴 그리드 초기화;
      grid3.initGridData();

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "권한그룹 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
          CommonJs.searchMsg(result);
      }

  });
}

/*****************************************************
* 함수명: 권한그룹 신규
*****************************************************/
function doNew() {

  grid1.reload();

  // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
  newJson1.mode = "I";

  //정렬순번을 10 단위로 세팅한다.
  newJson1.sortSeq = ( $("#grid1").jqGrid('getDataIDs').length + 1 ) * 10;

  // edit-panel에 newJson1를 binding 한다.
  ksid.form.bindPanel("edit-panel", newJson1);

  // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
  ksid.form.applyModeStyle("edit-panel", newJson1.mode);

  //권한그룹-관리자 그리드 초기화;
  grid2.initGridData();

  //권한그룹-메뉴 그리드 초기화;
  grid3.initGridData();

  $("#edit-panel input[name=authGroupCd]").focus();

}

/*****************************************************
* 함수명: 권한그룹 중복 조회
* 설명   :
*****************************************************/
function doCheckAuthGroup(panelId, el) {
  var params = ksid.form.flushPanel("edit-panel");

  // 권한그룹id 가 없다면 return
  if(ksid.string.trim(params.authGroupCd) == "") return;

  ksid.net.ajax("${pageContext.request.contextPath}/admin/system/auth/sel", params, function(result) {
      if(result.resultCd == "00" && result.resultData) {
          CommonJs.setStatus(  ksid.string.replace( "해당 권한그룹코드[{0}]가 이미 존재합니다.", "{0}", params.authGroupCd ) );
          $(el).val("").focus();
      }
  });
}

/*****************************************************
* 함수명: 권한그룹 저장
* 설명   :
*****************************************************/
function doSave() {
  ksid.ui.confirm("권한그룹을 저장하시겠습니까?", function() {
      if(ksid.form.validateForm("edit-panel")) {
          var params = ksid.form.flushPanel("edit-panel");

          var url = "";

          if(params.mode == "I") {
              url = "${pageContext.request.contextPath}/admin/system/auth/ins";
          } else if(params.mode == "U") {
              url = "${pageContext.request.contextPath}/admin/system/auth/upd";
          }

          ksid.net.ajax(url, params, function(result) {

              if(result.resultCd == "00") {
                  doQuery("권한그룹이 정상적으로 저장되었습니다.");
               }

          });
      }
  });
}

/*****************************************************
* 함수명: 권한그룹 삭제
* 설명   :
*****************************************************/
function doDelete() {
  ksid.ui.confirm("선택한 권한그룹을 삭제하시겠습니까?", function() {
      var rowId = $("#grid1").getGridParam("selrow");

      if(!rowId) {
          ksid.ui.alert("삭제할 권한그룹 행을 선택하세요.");

          return;
      }

      var params = $("#grid1").getRowData(rowId);

      ksid.net.ajax("${pageContext.request.contextPath}/admin/system/auth/del", params, function(result) {
              doQuery();
      });
  });
}

/*****************************************************
* 함수명: 권한그룹목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {
}

/*****************************************************
* 함수명: 권한그룹-관리자 목록 조회
* 설명   :
*****************************************************/
function doQuery2(resultMsg) {

  var params = {"authGroupCd": grid1.clickedRowData.authGroupCd};

  ksid.net.ajaxJqGrid(grid2, "${pageContext.request.contextPath}/admin/system/auth/selAdminList", params, function(result) {

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(  ksid.string.replace( "권한그룹-관리자 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
//              CommonJs.searchMsg(result);
       }

  });

}


/*****************************************************
* 함수명: 권한그룹-관리자 등록 팝업 오픈
* 설명   :
*****************************************************/
function doNew2() {

  if(grid1.clickedRowData == null) {

      ksid.ui.alert("관리자를 등록하시려면 먼저 왼쪽 권한그룹조회에서 권한그룹을 선택하세요.");
      return;

  }

  ksid.json.mergeObject(ksid.json.dialogProp, {title:"권한그룹-관리자 등록", width:dialog1W, height:dialog1H});

  grid4.loadGrid();

  $("#dialog_auth_group_admin").dialog(ksid.json.dialogProp);

  doQueryDialog1();

}


/*****************************************************
* 함수명: 권한그룹-관리자 선택 삭제
* 설명   :
*****************************************************/
function doDelete2() {

  var selectedIds = $("#grid2").getGridParam("selarrrow");

  if( selectedIds.length == 0 ) {

      ksid.ui.alert("선택한 관리자가 없습니다. 권한그룹에 삭제할 관리자를 선택하세요");
      return;

  }

  var params = [];

  for (var i = 0; i < selectedIds.length; i++) {

      var selectedData = $("#grid2").getRowData(selectedIds[i]);

      var params_list_01 = {};

      params_list_01.authGroupCd    = grid1.clickedRowData.authGroupCd;
      params_list_01.adminId         = selectedData.adminId;

      params.push(params_list_01);

  }

  //  ksid.debug.printObj("params", params);

  ksid.ui.confirm( ksid.string.replace( "선택하신 관리자를 권한그룹[{0}]에서 삭제하시겠습니까?", "{0}", grid1.clickedRowData.authGroupNm ), function() {

      ksid.net.ajax("${pageContext.request.contextPath}/admin/system/auth/delAdminList", JSON.stringify(params), function(result) {

          if(result.resultCd == "00") {
              doQuery2(result.resultData);
              doQueryDialog1();
           }

      }, {contentType:"application/json; charset=UTF-8"});

  });

}

/*****************************************************
* 함수명: 팝업창에서 권한그룹 관리자 조회
* 설명   :
*****************************************************/
function doQueryDialog1() {

  var params = {};
  params.authGroupCd = grid1.clickedRowData.authGroupCd;

  ksid.net.ajaxJqGrid(grid4, "${pageContext.request.contextPath}/admin/system/auth/selPopupAdminList", params, function(result) {
  });

}

/*****************************************************
* 함수명: 팝업창에서 관리자 선택 저장
* 설명   :
*****************************************************/
function doSaveDialog1() {

    var selectedIds = $("#grid4").getGridParam("selarrrow");

    if( selectedIds.length == 0 ) {

        ksid.ui.alert("선택한 관리자가 없습니다. 권한그룹에 등록할 관리자를 선택하세요");
        return;

    }

    var params = [];

    for (var i = 0; i < selectedIds.length; i++) {

        var selectedData = $("#grid4").getRowData(selectedIds[i]);

        var params_list_01 = {};

        params_list_01.authGroupCd    = grid1.clickedRowData.authGroupCd;
        params_list_01.adminId         = selectedData.adminId;

        params.push(params_list_01);

    }

    //  ksid.debug.printObj("params", params);

    ksid.ui.confirm( ksid.string.replace( "선택하신 관리자를 권한그룹[{0}]에 등록하시겠습니까?", "{0}", grid1.clickedRowData.authGroupNm ) , function() {

      ksid.net.ajax("${pageContext.request.contextPath}/admin/system/auth/insAdminList", JSON.stringify(params), function(result) {

          if(result.resultCd == "00") {
              doQuery2(ksid.localization.string("정상적으로 저장되었습니다."));
              doQueryDialog1();
              $('#dialog_auth_group_admin').dialog('close');
           }

      }, {contentType:"application/json; charset=UTF-8"});


    });

}

/*****************************************************
* 함수명: 권한그룹-메뉴 목록 조회
* 설명   :
*****************************************************/
function doQuery3(resultMsg) {

  var params = {"authGroupCd": grid1.clickedRowData.authGroupCd};

  ksid.net.ajaxJqGrid(grid3, "${pageContext.request.contextPath}/admin/system/auth/selMenuList", params, function(result) {

      if(resultMsg) {
          CommonJs.setStatus(resultMsg);
      } else {
          CommonJs.setStatus(ksid.string.replace( "권한그룹-메뉴 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ));
//              CommonJs.searchMsg(result);
      }

  });

}



/*****************************************************
* 함수명: 권한그룹-메뉴 등록 팝업 오픈
* 설명   :
*****************************************************/
function doNew3() {

  if(grid1.clickedRowData == null) {
      ksid.ui.alert("메뉴를 등록하시려면 먼저 왼쪽 권한그룹조회에서 권한그룹을 선택하세요.");
      return;
  }

  ksid.json.mergeObject(ksid.json.dialogProp, {title:"권한그룹-메뉴 등록", width:dialog2W, height:dialog2H})
  grid5.loadGrid();
  $("#dialog_auth_group_menu").dialog(ksid.json.dialogProp);

  doQueryDialog2();

}



    /*****************************************************
     * 함수명: 권한그룹-메뉴 등록
     * 설명   :
     *****************************************************/
    function doSave3() {

        var selectedIds = $("#grid3").getGridParam('selarrrow');

        if (selectedIds.length == "0") {
            ksid.ui.alert("저장할 데이타를 먼저 추가해주세요.");
            return;
        }

        //에디트 0,0으로 grid를 속인다.
        $("#grid3").editCell(0, 0, true);

        //validateRow 체크
        if (!grid2.validateRow()) {
            return;
        }

        for (i = 0; i < selectedIds.length; i++) {
            $("#grid3").jqGrid('saveRow', selectedIds[i], true);
        }

        var params = [];

        for (var i = 0; i < selectedIds.length; i++) {
            var selectedData = $("#grid3").getRowData(selectedIds[i]);
            params.push(selectedData);
        }

        ksid.ui.confirm("해당 메뉴를 저장하시겠습니까?", function() {
            ksid.net.ajax("${pageContext.request.contextPath}/admin/system/auth/updMenuList", JSON.stringify(params), function(result) {
                if (result.resultCd == "00") {
                    doQuery3(result.resultData);
                }
            }, {contentType:"application/json; charset=UTF-8"});
        });
    }

    function doExcel3() {

        var url = "${pageContext.request.contextPath}/admin/system/auth/excel3";
        var fileNm = "권한그룹-메뉴 목록";

        ksid.net.ajaxExcelGrid(url, fileNm, grid3);

    }

    /*****************************************************
     * 함수명: 권한그룹-메뉴 선택 삭제
     * 설명   :
     *****************************************************/
    function doDelete3() {

        var selectedIds = $("#grid3").getGridParam("selarrrow");

        if (selectedIds.length == 0) {

            ksid.ui.alert("선택한 메뉴가 없습니다. 권한그룹에 삭제할 메뉴를 선택하세요");
            return;

        }

        var params = [];

        for (var i = 0; i < selectedIds.length; i++) {

            var selectedData = $("#grid3").getRowData(selectedIds[i]);

            var params_list_01 = {};

            params_list_01.authGroupCd = grid1.clickedRowData.authGroupCd;
            params_list_01.menuId = selectedData.menuId;

            params.push(params_list_01);

        }

        ksid.ui.confirm(ksid.string.replace("선택하신 메뉴를 권한그룹[{0}]에서 삭제하시겠습니까?", "{0}", grid1.clickedRowData.authGroupNm), function() {
            ksid.net.ajaxMulti("${pageContext.request.contextPath}/admin/system/auth/delMenuList", JSON.stringify(params), function(result) {
                if (result.resultCd == "00") {
                    doQuery3(result.resultData);
                    doQueryDialog2();
                }
            });
        });

    }

    /*****************************************************
     * 함수명: 팝업창에서 권한그룹 메뉴 조회
     * 설명   :
     *****************************************************/
    function doQueryDialog2() {

        var params = {};
        params.authGroupCd = grid1.clickedRowData.authGroupCd;

        ksid.net.ajaxJqGrid(grid5, "${pageContext.request.contextPath}/admin/system/auth/selPopupMenuList", params);
    }

    /*****************************************************
     * 함수명: 팝업창에서 메뉴 선택 저장
     * 설명   :
     *****************************************************/
    function doSaveDialog2() {

        var selectedIds = $("#grid5").getGridParam("selarrrow");

        if (selectedIds.length == 0) {

            ksid.ui.alert("선택한 메뉴가 없습니다. 권한그룹에 등록할 메뉴를 선택하세요");
            return;

        }

        var params = [];

        for (var i = 0; i < selectedIds.length; i++) {

            var selectedData = $("#grid5").getRowData(selectedIds[i]);

            var params_list_01 = {};

            params_list_01.authGroupCd = grid1.clickedRowData.authGroupCd;
            params_list_01.menuId = selectedData.menuId;

            params.push(params_list_01);

        }

        ksid.ui.confirm(ksid.string.replace("선택하신 메뉴를 권한그룹[{0}]에 등록하시겠습니까?", "{0}", grid1.clickedRowData.authGroupNm), function() {
            ksid.net.ajax("${pageContext.request.contextPath}/admin/system/auth/insMenuList", JSON.stringify(params), function(result) {
                if (result.resultCd == "00") {
                    doQuery3(result.resultData);
                    doQueryDialog2();
                    $('#dialog_auth_group_menu').dialog('close');
                }
            }, {contentType:"application/json; charset=UTF-8"});
        });

    }
</script>

<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">시스템</span> > <span name="menu">권한관리</span></p>
    </div>

    <div class="variableWrapAuth">
        <!-- 왼쪽 컨텐츠  -->
        <div id="edit-panel" class="fLeft">
           <h3 class="style-title"><span name="title">권한그룹정보</span></h3>

            <!-- 입력화면 시작 -->
            <div class="edit-panel">
                <input type="hidden" name="mode" value="I" />
                <div class="styleDlTable" style="min-width:500px;width:500px;">
                    <dl>
                        <dt name="title" class="title_on width80"><label for="authGroupCd">권한그룹코드</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="20" class="style-input width120" name="authGroupCd" title="권한그룹ID" next="authGroupNm" modestyle="enable" required />
                        </dd>
                        <dt name="title" class="title_on width80"><label for="authGroupNm">권한그룹명</label></dt>
                        <dd class="width130">
                            <input type="text" maxlength="20" class="style-input width120" name="authGroupNm" title="권한그룹ID" next="sortSeq" command="doSave()" required />
                        </dd>
                    </dl>
                    <dl>
                        <dt name="title" class="title_on width80">정렬순번</dt>
                        <dd class="width130">
                            <input type="text" maxlength="200" class="style-input width60" name="sortSeq" format="number" title="정렬순번" command="doSave()" required />
                        </dd>
                        <dt name="title" class="title_on width80"><label for="">사용여부</label></dt>
                        <dd>
                            <select class="style-select width100" name="useYn" title="사용여부" codeGroupCd="USE_YN" selected_value="Y" required></select>
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
                    <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
                    <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
                    <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
<!--                     <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button> -->
                </div>
                <!--// button bar  -->

            </div>

            <!-- 입력화면 끝 -->
            <h3 class="style-title"><span name="title">권한그룹조회</span></h3>
            <!-- 그리드 시작 -->
            <table id="grid1" ></table>
            <!-- 그리드 끝 -->
        </div>
        <!--// 왼쪽 컨텐츠  -->

        <!-- 오른쪽 컨텐츠  -->
        <!-- 입력화면 시작 -->
        <div class="fRight">
            <div class="style-title-wrap">
                <h3 class="style-title"><span name="title">권한그룹-관리자 등록</span></h3>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doNew2()">등록</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete2()">삭제</button>
                </div>
                <!--// button bar  -->
            </div>
            <table id="grid2" resize="false"></table>
            <div class="style-title-wrap bottom50Percentage">
                <h3 class="style-title"><span name="title">권한그룹-메뉴 등록</span></h3>
                <!--  button bar  -->
                <div class="button-bar button-bar-abso">
                    <button type="button" class="style-btn" auth="W" onclick="doNew3()">등록</button>
                    <button type="button" class="style-btn" auth="W" onclick="doSave3()">선택항목저장</button>
                    <button type="button" class="style-btn" auth="D" onclick="doDelete3()">삭제</button>
                    <button type="button" class="style-btn" auth="P" onclick="doExcel3()">출력</button>
                </div>
                <!--// button bar  -->
            </div>
            <table id="grid3" ></table>
        </div>
        <!--// 오른쪽 컨텐츠  -->
    </div>
</div>

<div id="dialog_auth_group_admin" style="display:none;" class="dialog">

    <!-- 버튼 시작 -->
    <div class="button-bar">
        <button type="button" onclick="doQueryDialog1()" class="style-btn">조회</button>
        <button type="button" onclick="doSaveDialog1()" class="style-btn">저장</button>
        <button type="button" onclick="$('#dialog_auth_group_admin').dialog('close')" class="style-btn">닫기</button>
    </div>
    <!-- 버튼 끝 -->

    <!-- grid -->
    <table id="grid4" resize="false"></table>

</div>

<div id="dialog_auth_group_menu" style="display:none;" class="dialog">

    <!-- 버튼 시작 -->
    <div class="button-bar">
        <button type="button" onclick="doQueryDialog2()" class="style-btn">조회</button>
        <button type="button" onclick="doSaveDialog2()" class="style-btn">저장</button>
        <button type="button" onclick="$('#dialog_auth_group_menu').dialog('close')" class="style-btn">닫기</button>
    </div>
    <!-- 버튼 끝 -->

    <!-- grid -->
    <table id="grid5" ></table>

</div>
