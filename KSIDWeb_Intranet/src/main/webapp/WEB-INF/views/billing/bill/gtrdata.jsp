<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 원시 데이터정보 json
var newJson1 = {};

// 원시 데이터리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];

    colModel.push({ label: '인증 TYPE', name: 'RecvTp', hidden:true });
    colModel.push({ label: '서비스제공자', name: 'spCd', hidden:true });
    colModel.push({ label: '고객사', name: 'custId', hidden:true });
    colModel.push({ label: '서비스', name: 'servId', hidden:true });
    colModel.push({ label: '사용자', name: 'userId', hidden:true });

    colModel.push({ label: '서비스제공자', name: 'spNm', format:"string", width:150 });
    colModel.push({ label: '고객사', name: 'custNm', format:"string", width:150 });
    colModel.push({ label: '서비스명', name: 'servNm', format:"string", width:150 });
    colModel.push({ label: '학번', name: 'userId', format:"string", width:100 });

    //colModel.push({ label: '트랜잭션아이디', format:"string", name: 'tId', width:120 });
    //colModel.push({ label: '휴대폰', name: 'telNo', format:"tel_no", width:80 });
    colModel.push({ label: '작업시각', name: 'stDtm', format:"dttm", width:130 });
    //colModel.push({ label: '작업종료시각', name: 'edDtm', format:"dttm", width:120 });
    colModel.push({ label: '요청명령', name: 'cmd', width:100 });
    colModel.push({ label: '작업구분', name: 'authMethod', width:150 });

    //colModel.push({ label: '과금분류코드', name: 'prodCd', width:75 });
    //colModel.push({ label: '과금분류', name: 'prodNm', format:"string", width:110 });

    colModel.push({ label: '처리결과', name: 'resultCd', width:70 });
    colModel.push({ label: '상태코드', name: 'statusCd', width:50 });

    //colModel.push({ label: '연동서버아이디', name: 'serverId', format:"string", width:120 });
    //colModel.push({ label: '수신위치', name: 'recvLoc', format:"string", width:70 });

    //colModel.push({ label: 'Ta버전', name: 'taVer', width:50 });
    //colModel.push({ label: 'App버전', name: 'appVer', width:50 });
    //colModel.push({ label: 'UUID', name: 'uuid', format:"string", width:150 });
    //colModel.push({ label: 'SUID', name: 'suid', format:"string", width:150 });

    //colModel.push({ label: '송신위치', name: 'sendLoc', format:"string", width:70 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;

    //원시 데이터리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    var paging = {}
    paging.options = {};
    paging.options["var"] = {};
    paging.options["prop"] = {};
    paging.options["var"].elementId = "grid1_pager";
    paging.options["prop"].totrowcnt = 1;
    paging.options["prop"].pagecnt = 100;
    paging.options["prop"].pagenow = 1;
    paging.options["prop"].blockcnt = 15;
    paging.options.context = "${pageContext.request.contextPath}";

    grid1.pager = new ksid.paging(paging.options);
    grid1.pager.parent = grid1;                 // 페이저 소속 GRID 를 지정한다.
    grid1.pager.selectFunc = doQueryPaging;     // 페이징을 클릭하였을때 호출(페이지 클래스에 해당 함수를 추가해야 한다.)
    grid1.pager.show();

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

    $("#search-panel input[name=telNo]").focus();
}

/*****************************************************
* 함수명 : 원시 데이터 목록 조회
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
                      , "${pageContext.request.contextPath}/billing/bill/gtrdata/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "원시 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명 : 원시 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var url = "${pageContext.request.contextPath}/billing/bill/gtrdata/excel";
    var fileNm = "원시데이터목록";
    var params = ksid.form.flushPanel("search-panel");

    ksid.net.ajaxExcel(url, fileNm, params, grid1);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">과금조회</span> > <span name="menu">원시 데이터</span></p>
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
<!--                     <select name="sYymm" title="시작월" class="style-select" codeGroupCd="yyyy_mm"></select> -->
<!--                     ~ -->
<!--                     <select name="eYymm" title="종료월" class="style-select" codeGroupCd="yyyy_mm"></select> -->
                </dd>
<!--                 <dt class="width60">과금분류</dt> -->
<!--                 <dd> -->
<!--                     <select name="prodCd" title="과금분류" class="style-select width200" overall="전체" codeGroupCd="PROD_CD"></select> -->
<!--                 </dd> -->
<!--                 <dt class="width70">인증유형</dt> -->
<!--                 <dd> -->
<!--                      <select name="recvTp" title="인증유형" class="style-select width100" overall="전체" codeGroupCd="RECV_TP" selected_value=""></select> -->
<!--                 </dd> -->
            </dl>
            <dl>
                <dt class="width80">서비스제공자</dt>
                <dd style="width:245px;">
                     <select name="spCd" title="서비스제공자" class="style-select width200" codeGroupCd="SP_CD" selected_value=""></select>
                </dd>
                <dt class="width60">고객사</dt>
                <dd>
                    <select name="custId" title="고객사" class="style-select width200" overall="전체" codeGroupCd="CUST_ID"></select>
                </dd>
                <dt class="width70">학번</dt>
                <dd>
                    <input type="text" maxlength="16" name="telNo" title="학번" class="style-input width110" command="doQuery()" />
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

    <h3 class="style-title"><span name="title">원시 데이터 목록</span></h3>
    <!-- grid -->
    <div id="grid1_pager" class="pager"></div>
    <table id="grid1"></table>
    <!--// grid -->
</div>
