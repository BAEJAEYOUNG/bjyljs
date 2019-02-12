<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 고객사정보 json
var newJson1 = {};

// 고객사리스트 grid
var grid1 = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({ label: '고객사유형', name: 'custTp', hidden: true });
    colModel.push({ label: '등록자', name: 'regId', hidden: true });
    colModel.push({ label: '변경자', name: 'chgId', hidden: true });
    colModel.push({ label: '사용여부', name: 'useYn', hidden: true });
    colModel.push({ label: '고객사상태', name: 'custSt', hidden: true });
    colModel.push({ label: '메뉴레벨', name: 'menu_lvl',hidden: true});

    colModel.push({ label: '서비스제공자코드', name: 'spCd', format: 'string', width:100 });
    colModel.push({ label: '서비스제공자명', name: 'spNm',format: 'string' , width:100 });
    colModel.push({ label: '고객사아이디', name: 'custId', format: 'string', width:80 });
    colModel.push({ label: '고객사명', name: 'custNm',format: 'string' , width:80 });
    colModel.push({ label: '고객사유형', name: 'custTpNm', width:80 });
    colModel.push({ label: '고객사상태', name: 'custStNm',width:80 });
    colModel.push({ label: '사업자번호', name: 'bizNo', format: 'biz_no' , width:80 });
    colModel.push({ label: '상호', name: 'tradeNm', format: 'string' , width:100 });
    colModel.push({ label: '대표자명', name: 'ceoNm',width:60 });
    colModel.push({ label: '전화번호', name: 'telNo', format: 'tel_no' , width:100 });
    colModel.push({ label: '주소', name: 'addr', format: 'string' , width:200 });
    colModel.push({ label: '업태', name: 'bizCond', format: 'string' , width:80 });
    colModel.push({ label: '종목', name: 'bizItem', format: 'string' , width:80 });
    colModel.push({ label: '담당자명', name: 'mngrNm', format: 'string' , width:100 });
    colModel.push({ label: '담당자연락처', name: 'mngrMpNo', format: 'tel_no' , width:150 });
    colModel.push({ label: '담당자이메일1', name: 'mngrEmail1', format: 'string' , width:150 });
    colModel.push({ label: '담당자이메일2', name: 'mngrEmail2', format: 'string' , width:150 });

    colModel.push({ label: '등록자', name: 'regNm',width:80 });
    colModel.push({ label: '최초등록일시', name: 'regDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '변경자', name: 'chgNm',width:80 });
    colModel.push({ label: '변경일시', name: 'chgDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '해지일시', name: 'cancelDtm',format: 'dttm' , width:120 });
    colModel.push({ label: '해지사유', name: 'cancelRsn', format: 'string' , width:200 });
    colModel.push({ label: '비고', name: 'remark', format: 'string' , width:200 });

    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);

        var rowData = grid1.clickedRowData;
        rowData.mode = "U";

        // edit-panel에 rowData binding 한다.
        ksid.form.bindPanel("edit-panel", rowData);

        // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
        ksid.form.applyModeStyle("edit-panel", rowData.mode);
    };

    //고객사리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

  //사업자번호 중복체크
    $("#edit-panel input[name=bizNo]").blur(function() {
        doCheckBizNo(this);
    });

}

/*****************************************************
* 함수명: 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function editpanelComboAjaxAfterDoQuery() {

  //고객사정보 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

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
                      , "${pageContext.request.contextPath}/registration/cust/list"
                      , params
                      , function(result) {

        //고객사 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "고객사 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 고객사 신규
*****************************************************/
function doNew() {

    grid1.reload();

    // 그룹 신규 json 의 mode 를 I(insert) 로 세팅한다.
    newJson1.mode = "I";

//     ksid.debug.printObj(newJson1);

    // edit-panel에 newJson1를 binding 한다.
    ksid.form.bindPanel("edit-panel", newJson1);

    // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
    ksid.form.applyModeStyle("edit-panel", newJson1.mode);

    $("#edit-panel input[name=adminId]").focus();

}

/*****************************************************
* 함수명: 서비스제공자 중복 조회
* 설명   :
*****************************************************/
function doCheckBizNo(el) {
    var params = ksid.form.flushPanel("edit-panel");

    // 서비스제공자id 가 없다면 return
    if(ksid.string.trim(params.bizNo) == "") return;

    ksid.net.ajax("${pageContext.request.contextPath}/registration/cust/sel", params, function(result) {
        if(result.resultCd == "00" && result.resultData) {
            // DB에 해당 사업자번호의 데이터가 존재하면서 등록 이거나, 변경이고 동일한 서비스제공자이면서 클릭한 사업자번호와 입력한 사업자번호가 일치하지 않는다면
            if( params.mode == 'I' || ( params.mode == 'U' && grid1.clickedRowData.spCd == params.spCd && grid1.clickedRowData.bizNo != params.bizNo ) ) {
                CommonJs.setStatus( ksid.string.replace( "해당 서비스제공자 의 고객사 사업자번호[{0}]가 이미 존재합니다.", "{0}", ksid.string.formatBizNo(params.bizNo) ) );
                var sVal = ( params.mode == 'U' ) ? grid1.clickedRowData.bizNo : "";
                $(el).val(ksid.string.formatBizNo(sVal)).focus();
            }
        }
    });
}

/*****************************************************
* 함수명: 고객사 저장
* 설명   :
*****************************************************/
function doSave() {

    var params = ksid.form.flushPanel("edit-panel");

    if(params.custSt == "9") {
        ksid.ui.alert("해지된 고객사 입니다.");
        return;
    };

    ksid.ui.confirm("고객사을 저장하시겠습니까?", function() {
        if(ksid.form.validateForm("edit-panel")) {

            var url = "";

            if(params.mode == "I") {
                url = "${pageContext.request.contextPath}/registration/cust/ins";

            } else if(params.mode == "U") {
                url = "${pageContext.request.contextPath}/registration/cust/upd";
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
* 함수명: 고객사 해지
* 설명   :
*****************************************************/
function doDelete() {

    var rowId = $("#grid1").getGridParam("selrow");

    if(!rowId) {
        ksid.ui.alert("해지할 고객사를 선택하세요.");

        return;
    }

    var params = ksid.form.flushPanel("edit-panel");

    if(params.custSt == "9") {
        ksid.ui.alert("해지된 고객사 입니다.");
        return;
    };

    if( ksid.string.trim(params.cancelRsn) == "" ) {
        ksid.ui.alert("해지사유를 입력하세요");
        return;
    }

    ksid.ui.confirm("선택한 고객사을 해지하시겠습니까?", function() {

        ksid.net.ajax("${pageContext.request.contextPath}/registration/cust/del", params, function(result) {
            if(result.resultCd == "00") {
                doQuery(result.resultData);
            }
        });
    });
}

/*****************************************************
* 함수명: 고객사목록 엑셀다운로드
* 설명   :
*****************************************************/
function doExcel() {

    var excelParams = {
        file_nm         : CommonJs.setMsgLanguage("고객사목록"),
        param           : {},
        col_model       : grid1.getExcelColModel()

    };

    ksid.net.ajaxExcel("${pageContext.request.contextPath}/registration/cust/excel", excelParams);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">가입관리</span> > <span name="menu">고객사관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt><span name="title">고객사아이디/명</span></dt>
                <dd>
                    <input type="text" maxlength="10" name="custId" title="고객사아이디/명" class="style-input width110" command="doQuery()" />
                </dd>
            </dl>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
            <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
            <button type="button" class="style-btn" auth="D" onclick="doDelete()">해지</button>
<!--             <button type="button" class="style-btn" auth="P" onclick="doExcel()">출력</button> -->
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->
    <h3 class="style-title"><span name="title">고객사 정보</span></h3>
    <div id="edit-panel" class="edit-panel">
        <input type="hidden" name="mode" value="I" />
        <div class="styleDlTable">
            <dl>
                <dt name="title" class="title_on width80">서비스제공자</dt>
                <dd class="width130">
                    <select name="spCd" title="서비스제공자" class="style-select width120" codeGroupCd="SP_CD" required></select>
                </dd>
                <dt name="title" class="title_on width80">고객사아이디</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="custId" title="고객사아이디" class="style-input width110" disabled />
                </dd>
                <dt name="title" class="title_on width80">고객사 명</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="custNm" title="고객사 명" class="style-input width110" required />
                </dd>
                <dt name="title" class="title_on width80">고객사 유형</dt>
                <dd class="width130">
                    <select name="custTp" title="고객사 유형" class="style-select width120" codeGroupCd="CUST_TP" selected_value="S" required></select>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="title_on width80">사업자번호</dt>
                <dd class="width130">
                    <input type="text" name="bizNo" title="사업자번호" class="style-input width110" format="biz_no" required />
                </dd>
                <dt name="title" class="width80">상호</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" name="tradeNm" title="상호" class="style-input width110" />
                </dd>
                <dt name="title" class="width80">대표자명</dt>
                <dd class="width130">
                    <input type="text" maxlength="50" name="ceoNm" title="대표자명" class="style-input width110" />
                </dd>
                <dt name="title" class="width80">전화번호</dt>
                <dd class="width130">
                    <input type="text" maxlength="20" name="telNo" title="전화번호" class="style-input width110" format="tel_no" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">주소</dt>
                <dd class="width370">
                    <input type="text" name="addr" title="주소" class="style-input width350" />
                </dd>
                <dt name="title" class="width80">업태</dt>
                <dd class="width130">
                    <input type="text" maxlength="30" name="bizCond" title="업태" class="style-input width110" />
                </dd>
                <dt name="title" class="width80">종목</dt>
                <dd class="width130">
                    <input type="text" maxlength="30" name="bizItem" title="종목" class="style-input width110" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">담당자명</dt>
                <dd class="width130">
                    <input type="text" maxlength="30" name="mngrNm" title="담당자명" class="style-input width110" />
                </dd>
                <dt name="title" class="width80">담당자연락처</dt>
                <dd class="width130">
                    <input type="text" maxlength="30" name="mngrMpNo" title="담당자연락처" format="tel_no" class="style-input width110" />
                </dd>
                <dt name="title" class="width80">이메일1</dt>
                <dd class="width130">
                    <input type="text" maxlength="30" name="mngrEmail1" title="전자세금계산서 이메일1" class="style-input width110" />
                </dd>
                <dt name="title" class="width80">이메일2</dt>
                <dd class="width130">
                    <input type="text" maxlength="30" name="mngrEmail2" title="전자세금계산서 이메일2" class="style-input width110" />
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">비고</dt>
                <dd class="width600">
                    <input type="text" maxlength="200" name="remark" title="비고" class="style-input width580" style="width:830px;"/>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">고객사상태</dt>
                <dd class="width130">
                    <select name="custSt" title="고객사상태" class="style-select width120" codeGroupCd="CUST_ST" disabled></select>
                </dd>
                <dt name="title" class="width80">해지사유</dt>
                <dd class="width600">
                    <input type="text" maxlength="200" name="cancelRsn" title="해지사유" class="style-input width580" style="width:590px;"/>
                </dd>
            </dl>
        </div>
    </div>

    <h3 class="style-title"><span name="title">고객사 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
