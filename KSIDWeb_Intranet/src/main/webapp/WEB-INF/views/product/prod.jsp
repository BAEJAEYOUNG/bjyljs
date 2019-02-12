<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 과금대상관리 데이터정보 json
var newJson1 = {};

// 과금대상관리 데이터리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '상품코드', name: 'prodMclsCd', width:100 });
    colModel.push({ label: '과금대상코드', name: 'prodCd', width:100 });
    colModel.push({ label: '과금대상명', name: 'prodNm', format:'string', width:200 });
//     colModel.push({ label: '과금대상레벨', name: 'prodLvl', width:60 });


    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;

    //과금대상관리 데이터리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

    doQuery();
}

/*****************************************************
* 함수명: 과금대상관리 데이터 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    if(ksid.form.validateForm("search-panel") == false) return;

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/product/prod/list"
                      , params
                      , function(result) {

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "과금대상관리 데이터 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 과금대상관리 데이터목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {
}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">과금대상관리</span> > <span name="menu">과금대상 데이터관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt class="width80">과금대상명</dt>
                <dd>
                    <input type="text" maxlength="3" name="prodNm" title="서비스제공자코드/명" class="style-input width110" command="doQuery()" />
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
<!--             <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button> -->
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->

    <h3 class="style-title"><span name="title">과금대상관리 데이터 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
