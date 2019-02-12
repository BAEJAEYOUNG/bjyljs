<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript" language="javascript">
// 고객사정보 json
var newJson1 = {};

// 고객사서비스정책리스트 grid
var grid1 = null;

// 상품선택코드 리스트
var listProdChoiceCd = null;
var listParamsDetail = null;

/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

    var colModel = [];
    colModel.push({label:"상품선택코드", name:"prodChoiceCd", hidden: true});
    colModel.push({label:"유무료", name:"chargeFg", hidden: true});
    colModel.push({label:"과금대상유형", name:"billTarTp", hidden: true});
    colModel.push({label:"지불유형", name:"payFg", hidden: true});
    colModel.push({label:"과금유형", name:"billFg", hidden: true});
    colModel.push({label:"과금계산유형", name:"billCalcTp", hidden: true});
    colModel.push({label:"과금상태", name:"billState", hidden: true});

    colModel.push({label:"서비스제공자코드", name:"spCd", hidden: true});
    colModel.push({label:"서비스정책아이디", name:"servPolicyId", hidden: true});
    colModel.push({label:"상품코드", name:"prodMclsCd", hidden: true});

    colModel.push({label:"서비스제공자", name:"spNm", format:"string", width:100});
    colModel.push({label:"서비스정책명", name:"servPolicyNm", format:"string", width:100});
    colModel.push({label:"상품", name:"prodMclsNm", format:"string", width:60});

    colModel.push({label:"유무료", name:"chargeFgNm", width:50});
    colModel.push({label:"과금대상유형", name:"billTarTpNm", width:80});
    colModel.push({label:"지불유형", name:"payFgNm", width:60});
    colModel.push({label:"과금유형", name:"billFgNm", width:60});
    colModel.push({label:"과금액", name:"billPrice", format:"number", width:90});
    colModel.push({label:"과금계산유형", name:"billCalcTpNm", width:100});

    colModel.push({label:"등록일시", name:"regDtm", format:'dttm', width:130});
    colModel.push({label:"등록자", name:"regNm", width:80});
    colModel.push({label:"최종작업일시", name:"chgDtm", format:'dttm', width:130});
    colModel.push({label:"최종작업자", name:"chgNm", width:80});


    var gridProp = {};
    gridProp.colModel = colModel;
    gridProp.shrinkToFit = false;
    gridProp.onSelectRow = function (rowId, status, e) {
        grid1.setClickedProp(rowId);

        var rowData = grid1.clickedRowData;
        rowData.mode = "U";

        $('#chk_prodChoiceCd input[name="S-T-1"]').val('500');

        // edit-panel에 rowData binding 한다.
        ksid.form.bindPanel("edit-panel", rowData);

        // 모드 스타일에 따라 modestyle 이 존재하는 폼 element 를 세팅한다.
        ksid.form.applyModeStyle("edit-panel", rowData.mode);

        ksid.net.ajax("${pageContext.request.contextPath}/product/spservpolicy/selSpServCasePolicyList", rowData, function(result) {
            if( "00" == result.resultCd ) {
                console.log('result.resultData', result.resultData);
                var bConf = false;
                $('#chk_prodChoiceCd input[name=prodChoiceCd]').each(function(){
                    bConf = false;
                    for (var i = 0; i < result.resultData.length; i++) {
                        if($(this).val() == result.resultData[i].prodCd) {
                            bConf = true;
                            $(this).trigger('click');
                            $('#chk_prodChoiceCd input[name="' + $(this).val() + '"]').val(ksid.string.formatNumber(result.resultData[i].billPrice));
                        }
                    }
                });
            }
        });
    };

    //고객사서비스정책리스트 그리드 생성
    grid1 = new ksid.grid("grid1", gridProp);
    grid1.loadGrid();

}

/*****************************************************
* 함수명: 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function editpanelComboAjaxAfterDoQuery() {

    // 조회 서비스제공자 변경시 고객사 select binding
    $("#search-panel select[name=spCd]").change(function() {
        if($(this).val() != '') {
            $("#edit-panel select[name=spCd]").val($(this).val()).trigger('change');
            newJson1.spCd = $(this).val();
        }
        console.log(ksid.form.flushPanel('edit-panel'));
    });

    $("#search-panel select[name=spCd]").trigger("change");

    // 상품코드 변경시 과금선택박스 표시하기
    $("#edit-panel select[name=prodMclsCd]").change(function() {

        var params = {prodMclsCd:$(this).val()};

        // 상품코드 변경시 해당 과금선택 code , value 를 가져와 체크박스에 바인딩.
        ksid.net.ajax("${pageContext.request.contextPath}/billing/comm/prodChoiceCdList", params, function(result) {
            listProdChoiceCd = null;
            if(result.resultCd == '00') {
                listProdChoiceCd = result.resultData;
                option = {
                    TITLE : "과금대상선택",
                    COL_CNT: 4
                };
                // 가격을 입력할수 있는 체크박스 생성
                ksid.form.bindCheckboxPrice('chk_prodChoiceCd', listProdChoiceCd, option);

                // 해당 가격입력 input 에 format 생성
                ksid.form.applyFieldOption('chk_prodChoiceCd');

                // 체크박스 클릭시 과금유형에 따라 가격입력 input 활성화, 비활성화
                $('#chk_prodChoiceCd input[name=prodChoiceCd]').click(function(){
                    if($("#edit-panel select[name=billFg]").val() == '01') { // 건별
                        if(true == $(this).is(':checked')) {
                            $('#chk_prodChoiceCd input[name=' + $(this).val() + ']').prop('disabled', false).focus();
                        } else {
                            $('#chk_prodChoiceCd input[name=' + $(this).val() + ']').val('0').prop('disabled', true);
                        }
                    } else {
                        $('#chk_prodChoiceCd input[name=' + $(this).val() + ']').val('0').prop('disabled', true);
                    }
                });
            }
        });

    });

    $("#edit-panel select[name=prodMclsCd]").trigger("change");

    // 과금유형에 따른 과금대상 초기화
    // 과금유형이 건별일때 체크박스에 체크되어 있는 input 활성화
    // 정액일때는 모두 비활성화
    $("#edit-panel select[name=billFg]").change(function() {
        if($(this).val() == '01') {
            $("#edit-panel input[name=billPrice]").val(0).prop('disabled', true);
            $('#chk_prodChoiceCd input[name=prodChoiceCd]').each(function(){
                if(true == $(this).is(':checked')) {
                    $('#chk_prodChoiceCd input[name=' + $(this).val() + ']').prop('disabled', false);
                } else {
                    $('#chk_prodChoiceCd input[name=' + $(this).val() + ']').val('0').prop('disabled', true);
                }
            });
        } else {
            $("#edit-panel input[name=billPrice]").val("3,000").prop('disabled', false).focus();
            $('#chk_prodChoiceCd input[type=text]').val('0').prop('disabled', true);
        }

    });

    $("#edit-panel select[name=billFg]").trigger("change");



    //고객사서비스정책정보 신규 json 생성
    newJson1 = ksid.form.flushPanel("edit-panel");

    doQuery();
}

/*****************************************************
* 함수명: 고객사서비스정책 목록 조회
* 설명   :
*****************************************************/
function doQuery(resultMsg) {

    // search-panel 의 form name, value를 <k,v> 형태로 params 에 담는다.
    var params = ksid.form.flushPanel("search-panel");

    // get_admin_list.do 경로로 params 파라미터로 조회하여 받아온 데이터를 grid1에 바인딩한다.
    ksid.net.ajaxJqGrid(grid1
                      , "${pageContext.request.contextPath}/product/spservpolicy/list"
                      , params
                      , function(result) {

        //고객사서비스정책 입력 폼 초기화
        doNew();

        if(resultMsg) {
            CommonJs.setStatus(resultMsg);
        } else {
            CommonJs.setStatus(  ksid.string.replace( "고객사서비스정책 목록 <strong>{0}</strong>건이 조회 되었습니다.", "{0}", result.resultData.length ) );
        }

    });

}

/*****************************************************
* 함수명: 고객사서비스정책 신규
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



    $("#edit-panel input[name=servNm]").focus();

}

function getProdChoiceCd() {

    var prodChoiceCd = "";
    var listChoice = []

    listParamsDetail = [];

    $('#chk_prodChoiceCd input[name=prodChoiceCd]').each(function(){

        var objChoice = {};
        objChoice.prodCd = $(this).val();
        objChoice.checked = $(this).is(':checked');
        objChoice.billPrice = $('#chk_prodChoiceCd input[name=' + $(this).val() + ']').val();
        listChoice.push(objChoice);

        if( true == objChoice.checked ) {
            listParamsDetail.push({prodCd:objChoice.prodCd, billPrice:objChoice.billPrice});
        }


    });

    if(listProdChoiceCd == null) return listChoice;

//     console.log('listProdChoiceCd' , listProdChoiceCd);

    var lbChecked = false;  // 상품선택코드 체크여부
    for (var i = 0; i < listChoice.length; i++) {
        lbChecked = false;
        for (var j = 0; j < listChoice.length; j++) {
            if( listProdChoiceCd[i].codeCd == listChoice[j].prodCd ) {
//                 console.log(listProdChoiceCd[i].codeCd + '==' + listChoice[j].prodCd);
//                 console.log('listChoice[j].checked = ' + listChoice[j].checked);
                if( true == listChoice[j].checked ) {
                    lbChecked = true;
                }
                break;
            }
        }
        if(true == lbChecked) {
            prodChoiceCd += "1";
        } else {
            prodChoiceCd += "0";
        }
    }

    return prodChoiceCd;

}

/*****************************************************
* 함수명: 고객사서비스정책 저장
* 설명   :
*****************************************************/
function doSave() {

    if(ksid.form.validateForm('masterForm') == false ) return;

    var paramsMaster = ksid.form.flushPanel("masterForm");

    ksid.ui.confirm("고객사서비스정책을 저장하시겠습니까?", function() {

        var url = "";

        if(paramsMaster.mode == "I") {

            url = "${pageContext.request.contextPath}/product/spservpolicy/ins";

            var servPolicyId = null;

            ksid.net.sjax("${pageContext.request.contextPath}/product/spservpolicy/selServPolicyId", params, function(result) {

                if(result.resultCd == "00") {
                    servPolicyId = result.resultData;
                }

            });

            if( null == servPolicyId ) {
                ksid.ui.alert("서비스정책아이디 발급에 실패하였습니다");
                return;
            }

            paramsMaster.servPolicyId = servPolicyId;

        } else if(paramsMaster.mode == "U") {

            url = "${pageContext.request.contextPath}/product/spservpolicy/upd";

        }

        var prodChoiceCd = getProdChoiceCd();

        paramsMaster.prodChoiceCd = prodChoiceCd;   // 마스터에 상품선택코드 추가

        console.log('paramsMaster', paramsMaster);

        var paramsDetail = ksid.json.cloneObject(listParamsDetail);
        for (var i = 0; i < paramsDetail.length; i++) {
            paramsDetail[i].servPolicyId = paramsMaster.servPolicyId;
            paramsDetail[i].spCd = paramsMaster.spCd;
            paramsDetail[i].prodMclsCd = paramsMaster.prodMclsCd;
            paramsDetail[i].prodChoiceCd = prodChoiceCd;
        }

        console.log('paramsDetail', paramsDetail);

        var params = {
            master : JSON.stringify(paramsMaster),
            detail : JSON.stringify(paramsDetail)
        };

        console.log('params', params);

        ksid.net.ajax(url, params, function(result) {

            if(result.resultCd == "00") {
                doQuery(result.resultData);
            }

        });

    });
}

/*****************************************************
* 함수명: 고객사서비스정책 삭제
* 설명   :
*****************************************************/
function doDelete() {

    if(grid1.clickedRowData == null) {
        ksid.ui.alert("삭제할 고객사서비스정책을 선택하세요.");
        return;
    }

    var params = ksid.form.flushPanel("edit-panel");

    ksid.ui.confirm("선택한 고객사서비스정책을 삭제하시겠습니까?", function() {

        ksid.net.ajax("${pageContext.request.contextPath}/product/spservpolicy/del", params, function(result) {
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
        file_nm         : CommonJs.setMsgLanguage("고객사서비스정책 목록"),
        param           : {},
        col_model       : grid1.getExcelColModel()

    };

    ksid.net.ajaxExcel("${pageContext.request.contextPath}/product/spservpolicy/excel", excelParams);

}

</script>
<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">상품관리</span> > <span name="menu">고객사 서비스 정책 관리</span></p>
    </div>

    <!-- 입력 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt class="width80">서비스제공자</dt>
                <dd>
                    <select name="spCd" title="서비스제공자" class="style-select width130" overall="전체" codeGroupCd="SP_CD"></select>
                </dd>
        </div>
        <!--  button bar  -->
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
            <button type="button" class="style-btn" auth="W" onclick="doNew()">신규</button>
            <button type="button" class="style-btn" auth="W" onclick="doSave()">저장</button>
            <button type="button" class="style-btn" auth="D" onclick="doDelete()">삭제</button>
        </div>
        <!--// button bar  -->
    </div>
    <!-- 입력 끝 -->
    <h3 class="style-title"><span name="title">고객사서비스정책 정보</span></h3>
    <div id="edit-panel" class="edit-panel">

        <div class="styleDlTable">
            <form id="masterForm">
            <input type="hidden" name="mode" value="I" />
            <dl>
                <dt name="title" class="title_on width80">서비스제공자</dt>
                <dd class="width130">
                    <select name="spCd" title="서비스제공자" class="style-select width130" codeGroupCd="SP_CD" required></select>
                </dd>
                <dt name="title" class="title_on width80">정책아이디</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="servPolicyId" title="서비스정책아이디" class="style-input width110" disabled />
                </dd>
                <dt name="title" class="title_on width80">서비스정책명</dt>
                <dd class="width130">
                    <input type="text" maxlength="16" name="servPolicyNm" title="서비스정책명" class="style-input width110" required />
                </dd>
                <dt name="title" class="title_on width80">상품코드</dt>
                <dd class="width130">
                    <select name="prodMclsCd" title="상품코드" class="style-select width130" codeGroupCd="PROD_MCLS_CD" selected_value="TEE" required></select>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">유무료</dt>
                <dd class="width130">
                    <select name="chargeFg" title="유무료" class="style-select width130" codeGroupCd="CHARGE_FG" selected_value="P"></select>
                </dd>
                <dt name="title" class="width80">과금대상유형</dt>
                <dd class="width130">
                    <select name="billTarTp" title="과금대상유형" class="style-select width130" codeGroupCd="BILL_TAR_TP" selected_value="C"></select>
                </dd>
                <dt name="title" class="width80">지불유형</dt>
                <dd class="width130">
                    <select name="payFg" title="지불유형" class="style-select width130" codeGroupCd="PAY_FG" selected_value="A"></select>
                </dd>
                <dt name="title" class="width80">과금유형</dt>
                <dd class="width130">
                    <select name="billFg" title="과금유형" class="style-select width130" codeGroupCd="BILL_FG" selected_value="01"></select>
                </dd>
            </dl>
            <dl>
                <dt name="title" class="width80">과금계산유형</dt>
                <dd class="width130">
                    <select name="billCalcTp" title="과금계산유형" class="style-select width130" codeGroupCd="BILL_CALC_TP" selected_value="C"></select>
                </dd>
                <dt name="title" class="width80">과금액</dt>
                <dd class="width130">
                    <input type="text" name="billPrice" title="종목" class="style-input width110" format="number" value="3000" />
                </dd>
            </dl>
            </form>
            <dl>
                <dt name="title" class="width80">과금대상</dt>
                <dd class="width800" id="chk_prodChoiceCd">

                </dd>
            </dl>
        </div>
    </div>

    <h3 class="style-title"><span name="title">고객사서비스정책 목록</span></h3>
    <!-- grid -->
    <table id="grid1"></table>
    <!--// grid -->
</div>
