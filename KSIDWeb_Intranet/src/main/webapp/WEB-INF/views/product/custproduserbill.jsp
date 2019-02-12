<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 고객사 사용자 과금 데이터정보 json
var newJson1 = {};

// 고객사 사용자 과금 데이터리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '학번', name: 'custUserNo', format:'string', width:80 });
    colModel.push({ label: '서비스제공자', name: 'spNm', format:'string', width:100 });
    colModel.push({ label: '고객사', name: 'custNm', format:'string', width:80 });
    colModel.push({ label: '서비스아이디', name: 'servId', format:'string', width:80 });
    colModel.push({ label: '서비스명', name: 'servNm', format:'string', width:100 });
    colModel.push({ label: '상품코드', name: 'prodMclsCd', width:60 });
    colModel.push({ label: '휴대폰번호', name: 'mpNo', format:'tel_no', width:100 });
    colModel.push({ label: '과금상태', name: 'billStateNm', width:60 });
    colModel.push({ label: '서비스시작일시', name: 'servStDtm', format: 'dttm', width:120 });
    colModel.push({ label: '서비스종료일시', name: 'servEdDtm', width:120
                , formatter:function(cellvalue, options, rowObject) {
                    options.colModel.align = "center";
                    if (cellvalue == '99991231235959') {
                            return "제한없음";
                    } else {
                        return ksid.string.formatDttm(cellvalue);
                    }
                }});
    /* colModel.push({ label: 'TA신규설치수', name: 'taInstallCnt', format:"number", width:100 });
    colModel.push({ label: 'TA업데이트수', name: 'taUpdateCnt', format:"number", width:100 });
    colModel.push({ label: 'TA설치제한수', name: 'limitCnt', width:100
        , formatter:function(cellvalue, options, rowObject) {
            //console.log("-----22------cellvalue::", cellvalue);
            //console.log("-----22------options::", options);
            //console.log("-----22------rowObject::", rowObject);
            options.colModel.align = "right";
            if (-1 == cellvalue) {
                return "제한없음";
            } else {
                return ksid.string.formatNumber(cellvalue);
            }
        }}); */
    colModel.push({ label: '가입일시', name: 'joinDtm', format: 'dttm', width:120 });
    colModel.push({ label: '해지일시', name: 'cancelDtm', format: 'dttm', width:120 });

    colModel.push({ label: '서비스제공자', name: 'spCd', hidden:true });
    colModel.push({ label: '고객사', name: 'custId', hidden:true });
    colModel.push({ label: '사용자', name: 'userId', hidden:true });
    colModel.push({ label: '과금상태', name: 'billState', hidden:true });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;

    gridProp.loadComplete = function() {

        // 배경색상 css 선언
        var cssGreen  = {'background-color':'#6DFF6D'};
        var cssOrange = {'background-color':'orange'};
        var cssRed    = {'color':'red'};
        var cssBlue   = {'color':'blue'};

        // 그리드 데이터의 ID 가져오기
        var ids = $('#grid1').jqGrid('getDataIDs');

        // 그리드 데이터 가져오기
        var gridData = $("#grid1").jqGrid('getRowData');

        // 데이터 확인후 색상 변경
        for (var i = 0; i < gridData.length; i++) {
            if (gridData[i].billState == '0') {
                //$('#grid1 tr[id=' + ids[i] + ']').addClass('grid-test');
                $('#grid1').jqGrid('setCell', ids[i], 'billStateNm', '', cssBlue);
            } else {
                $('#grid1').jqGrid('setCell', ids[i], 'billStateNm', '', cssRed);
            }
        }
    };

    //고객사 사용자 과금 데이터리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var sDate = new ksid.datetime().before(0,1,0).getDate("yyyy-mm-dd");
    var eDate = new ksid.datetime().getDate("yyyy-mm-dd");

    $("#search-panel input[name=sDt]").val(sDate);
    $("#search-panel input[name=eDt]").val(eDate);

}

function searchpanelComboAjaxAfterDoQuery() {

    $("#search-panel select[name=spCd]").change(function() {

        var params = {spCd:$(this).val()};
        var combo = $("#search-panel select[name=custId]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/comboList", params);

    });

    $("#search-panel select[name=spCd]").trigger("change");

}

/*****************************************************
* 함수명 : 고객사 사용자 과금 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/product/custproduserbill/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "고객사 사용자 과금 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
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
        ksid.ui.alert("해지할 사용자-서비스상품을 선택하세요.");

        return;
    }

    var params = $("#grid1").getRowData( rowId );

    var tmpNo='';
    for (var i=0, max=params.mpNo.length; i < max; i++) {
        if (params.mpNo[i] >= '0' && params.mpNo[i] <= '9')
            tmpNo = tmpNo + params.mpNo[i];
    }
    params.mpNo = tmpNo;
//     console.log("tmpNo:", tmpNo);
//     console.log("rowData:", params);

    if(params.billState == "9") {
        ksid.ui.alert("해지된 사용자-서비스상품 입니다.");
        return;
    };

    ksid.ui.confirm("선택한 사용자-서비스상품을 해지하시겠습니까?", function() {

        ksid.net.ajax("${pageContext.request.contextPath}/registration/user/deregServ", params, function(result) {
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
        ksid.ui.alert("삭제할 사용자-서비스상품을 선택하세요.");

        return;
    }

    var params = $("#grid1").getRowData( rowId );

    var tmpNo='';
    for (var i=0, max=params.mpNo.length; i < max; i++) {
        if (params.mpNo[i] >= '0' && params.mpNo[i] <= '9')
            tmpNo = tmpNo + params.mpNo[i];
    }
    params.mpNo = tmpNo;
//     console.log("tmpNo:", tmpNo);
//     console.log("rowData:", params);

    if(params.billState == "0") {
        ksid.ui.alert("먼저 사용자-서비스상품 해지하세요.");
        return;
    };

    ksid.ui.confirm("선택한 사용자-서비스상품을 삭제하시겠습니까?", function() {

        ksid.net.ajax("${pageContext.request.contextPath}/registration/user/delServ", params, function(result) {
            if(result.resultCd == "00") {
                doQuery(result.resultData);
            } else {
                CommonJs.setStatus(result.resultData);
            }

        });
    });
}


/*****************************************************
* 함수명 : 고객사 사용자 과금 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var excelParams = {
        file_nm         : CommonJs.setMsgLanguage("고객사 사용자 과금 데이터목록"),
        param           : {},
        col_model       : grid1.getExcelColModel()

    };

    ksid.net.ajaxExcel("${pageContext.request.contextPath}/product/custproduserbill/excel", excelParams);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">상품관리</span> > <span name="menu">고객사 사용자 과금 데이터관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt class="width80">조회기간</dt>
                <dd>
                    <input type="text" name="sDt" title="조회시작일자" class="style-input width80" format="date" />
                    ~
                    <input type="text" name="eDt" title="조회종료일자" class="style-input width80" format="date" />
<!--                     <select name="sYymm" title="시작월" class="style-select" codeGroupCd="yyyy_mm"></select> -->
<!--                     ~ -->
<!--                     <select name="eYymm" title="종료월" class="style-select" codeGroupCd="yyyy_mm"></select> -->
                </dd>
            </dl>
            <dl>
                <dt class="width80">서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width200" codeGroupCd="SP_CD" overall="전체"></select>
                </dd>
                <dt>고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
                <dt>학번</dt>
                <dd>
                    <input type="text" maxlength="3" name="custUserNo" title="학번" class="style-input width110" command="doQuery()" />
                </dd>
                <!-- <dt>사용자명</dt>
                <dd>
                    <input type="text" maxlength="16" name="userNm" title="사용자명" class="style-input width110" command="doQuery()" />
                </dd> -->
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="D" onclick="doCancel()" style="color:red;">해지</button>
            <button type="button" class="style-btn" auth="D" onclick="doDelete()" style="color:red;">삭제</button>
<!--             <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button> -->
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <h3 class="style-title"><span name="title">사용자-서비스상품 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
