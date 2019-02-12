<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>


<script type="text/javascript" language="javascript">

var initParmas;
//var serverIp="http://192.168.2.100:82/";
//var serverIp="http://127.0.0.1:8080/";
//var serverIp="https://localhost:8443/";

//TYL_CODE 테이블에 CODE_GROUP_CD = 'SYS_URL'에 정의했음.  (SERVER, PC)
var serverIp="https://192.168.2.100:8443/";



/*****************************************************
 * 함수명 : init
 * 설명   : onload 시 ready 함수에서 호출
 *****************************************************/
function init() {

     initParmas = ksid.form.flushPanel('search-panel');

     var svcMonth = new ksid.datetime().getDate("yyyy-mm");
     $("#search-panel input[name=svcMonth]").val(svcMonth);

     var batchDate = new ksid.datetime().getDate('yyyy-mm-dd');
     $('#search-panel input[name=svcDate]').val(batchDate);

 }


/*****************************************************
* 함수명 : 모든 edit-panel 의 element 가 세팅이 끝난 후 호출
* 설명   : ksid.form.applyFieldOption() 내에 세팅되어 있음
*****************************************************/
function searchpanelComboAjaxAfterDoQuery() {

    var params = {};
    var combo = $("#search-panel select[name=sysUrl]");
    ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/getSysUrl", params);
    serverIp = $("#search-panel select[name=sysUrl] option:selected").text().trim();

    var combo = $("#search-panel select[name=fileDirNm]");
    ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/fileDirList", params);

    $("#search-panel select[name=fileDirNm]").change(function() {

        var filePath = $("#search-panel select[name=fileDirNm] option:selected").text();
        var params = {fileDir:filePath};
        $("#search-panel select[name=csvFileNm] option").remove();
        var combo = $("#search-panel select[name=csvFileNm]");
        ksid.net.ajaxCombo(combo, "${pageContext.request.contextPath}/billing/comm/fileList", params);

    });
    $("#search-panel select[name=fileDirNm]").trigger("change");

}


/*****************************************************/
//TA 과금 UDR 변환(분)
function doMakeTaUdr() {
    var params = ksid.form.flushPanel('search-panel');
    params.cnvFlag = '0';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/makeudr/tadownudr/batch');
}

//FIDO 과금 UDR 변환(분)
function doMakeFidoUdr() {
    var params = ksid.form.flushPanel('search-panel');
    params.cnvFlag = '0';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/makeudr/masterudr/batch');
}

//TA 요금 계산(일)
function doCalcTaUdr() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/calcudr/tadownudr/batch');
}

// FIDO 요금 계산(일
function doCalcFidoUdr() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/calcudr/masterudr/batch');
}

/*****************************************************/
//개인 월정액 요금 계산(월)
function doCalcUserMo() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/calcudr/usermofee/batch');
}

//고객사 월정액 요금 계산(월)
function doCalcCustMo() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/calcudr/custmofee/batch');
}

/*****************************************************/
//고객사 종량요금 청구(월)
function doCustWtBill() {
    var params = ksid.form.flushPanel('search-panel');
    params.payFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/makebill/wtbillcust/batch');
}

//법인 종량요금 청구(월)
function doBizWtBill() {
    var params = ksid.form.flushPanel('search-panel');
    params.payFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/makebill/wtbillbiz/batch');
}

//개인 종량요금 청구(월)
function doUserWtBill() {
    var params = ksid.form.flushPanel('search-panel');
    params.payFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/makebill/wtbilluser/batch');
}

/*****************************************************/
//고객사 정액요금 청구(월)
function doCustMoBill() {
    var params = ksid.form.flushPanel('search-panel');
    params.payFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/makebill/mobillcust/batch');
}

//법인 정액요금 청구(월)
function doBizMoBill() {
    var params = ksid.form.flushPanel('search-panel');
    params.payFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/makebill/mobillbiz/batch');
}

//개인 정액요금 청구(월)
function doUserMoBill() {
    var params = ksid.form.flushPanel('search-panel');
    params.payFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/makebill/mobilluser/batch');
}

/*****************************************************/

//서비스 요금 매출 집계(일)
function doServFeeStats() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/servfee/batch');
}

//PG 요금 매출 집계(일)<
function doSalesPgStats() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/salespg/batch');
}

//서비스 매출 현황 집계(일)
function doSalesServStats() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/salesserv/batch');
}

//PG 수익 현황 집계(일)
function doSettlePgStats() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/settlepg/batch');
}

/*****************************************************/
//서비스 요금 매출 집계(월)
function doServFeeStatsMon() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/servfee/batchmonth');
}

//PG 요금 매출 집계(월)
function doSalesPgStatsMon() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/salespg/batchmonth');
}

//서비스 매출 현황 집계(월)
function doSalesServStatsMon() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/salesserv/batchmonth');
}

//PG 수익 현황 집계(월)
function doSettlePgStatsMon() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/settlepg/batchmonth');
}

/*****************************************************/
//사용자 가입/해지 집계(일)
function doUserJoinStats() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/userjoin/batch');
}

//서비스 가입/해지 집계(일)
function doServJoinStats() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/servjoin/batch');
}

//서비스 트래픽 집계(일)
function doServTrfStats() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/servtrf/batch');
}

//원시 데이터 수집 집계(일)
function doRawGtrStats() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/rawgtr/batch');
}


/*****************************************************/
//사용자 가입/해지 집계(월)
function doUserJoinStatsMon() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/userjoin/batchmonth');
}

//서비스 가입/해지 집계(월)
function doServJoinStatsMon() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/servjoin/batchmonth');
}

//서비스 트래픽 집계(월)
function doServTrfStatsMon() {
    var params = ksid.form.flushPanel('search-panel');
    params.calcFlag = '1';
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/servtrf/batchmonth');
}

//원시 데이터 수집 집계(월)
function doRawGtrStatsMon() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/stats/rawgtr/batchmonth');
}

/*****************************************************/

//PG 거래파일 수집(일)
function doGetPgTradeFile() {
    var params = ksid.form.flushPanel('search-panel');
    params.svcType = 'T';

    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/batchfile/getpgfile/batch');
}

//PG 정산파일 수집(일)
function doGetPgSettleFile() {
    var params = ksid.form.flushPanel('search-panel');
    params.svcType = 'S';

    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/batchfile/getpgfile/batch');
}

//PG 거래파일 수집(월)
function doGetPgTradeFileMon() {
    var params = ksid.form.flushPanel('search-panel');
    params.svcType = 'T';

    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/batchfile/getpgfile/batchmonth');
}

//PG 정산파일 수집(월)
function doGetPgSettleFileMon() {
    var params = ksid.form.flushPanel('search-panel');
    params.svcType = 'S';

    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/batchfile/getpgfile/batchmonth');
}

//PG 거래파일 배치(일)
function doPgTradeGtrData() {
    var params = ksid.form.flushPanel('search-panel');
    params.fileDir = $("#search-panel select[name=fileDirNm] option:selected").text();
    params.csvFile = $("#search-panel select[name=csvFileNm] option:selected").text();

    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    //submitBatch(serverIp + 'bill/batchfile/pgtrade/batch');
    submitBatch(serverIp + 'bill/batchfile/getpgfile/batchtrade');
}

//PG 정산파일 배치(일)
function doPgSettleGtrData() {
    var params = ksid.form.flushPanel('search-panel');
    params.fileDir = $("#search-panel select[name=fileDirNm] option:selected").text();
    params.csvFile = $("#search-panel select[name=csvFileNm] option:selected").text();

    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    //submitBatch(serverIp + 'bill/batchfile/pgsettle/batch');
    submitBatch(serverIp + 'bill/batchfile/getpgfile/batchsettle');
}

/*****************************************************/

//PG 거래대사 정산(월)
function doPgTrade() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/settle/pgtrade/batch');
}

//PG 거래대사 비교내역(월)
function doPgTradeHisMon() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/settle/pgtrade/batchhismonth');
}

//PG 거래대사 비교내역(일)
function doPgTradeHis() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/settle/pgtrade/batchhis');
}

//PG 정산대사 정산(월)
function doPgSettle() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/settle/pgsettle/batch');
}

//PG 정산대사 비교내역(월)
function doPgSettleHisMon() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/settle/pgsettle/batchhismonth');
}

//PG 정산대사 비교내역(일)
function doPgSettleHis() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/settle/pgsettle/batchhis');
}

/*****************************************************/

//41. TAM CCI 배치(월)
function doTamCciGtrData() {
    var params = ksid.form.flushPanel('search-panel');
    params.fileDir = $("#search-panel select[name=fileDirNm] option:selected").text();
    params.csvFile = $("#search-panel select[name=csvFileNm] option:selected").text();

    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/batchfile/tamcci/batch');
}

//4.2 TA 내역 정산(월)
function doTamSettle() {
    var params = ksid.form.flushPanel('search-panel');
    ksid.form.bindPanel('batch-panel', initParmas);
    ksid.form.bindPanel('batch-panel', params);
    //ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));
    submitBatch(serverIp + 'bill/settle/tamsettle/batch');
}


/*****************************************************/

function submitBatch(url) {
    ksid.debug.printObj(ksid.form.flushPanel('batch-panel'));

    ksid.ui.confirm("해당 배치 작업을 실행하시겠습니습니까?", function() {
        $("#formBatch").attr("action", url);
        $("#formBatch").submit();
    });
}


</script>



<div class="contents-wrap">

    <div class="location-wrap">
        <p class="location"><span class="btn_home"></span>&nbsp;> <span name="menu">작업관리</span> > <span name="menu">과금생성</span></p>
    </div>

    <!-- 검색조건 시작 -->
    <div id="search-panel" class="search-panel">
        <div class="styleDlTable">
            <dl>
                <dt name="title"><label for="">작업월</label></dt>
                <dd>
                    <input name="svcMonth" type="text" format="ym" class="style-input width60" title="작업월" required />
                </dd>
                <dt name="title"><label for="">작업일</label></dt>
                <dd>
                    <input type="text" name="svcDate" title="작업일" class="style-input width80" to="svcDate" format="date" required/>
                </dd>
                <dt name="title"><label for="">요청서버</label></dt>
                <dd>
                    <select class="style-select" style="width:180px;"  name="sysUrl" title="요청서버" codeGroupCd="SYS_URL" required> </select>
                </dd>
                <dt name="title"><label for="">작업디렉토리</label></dt>
                <dd>
                    <select class="style-select" style="width:250px;" name="fileDirNm" title="작업디렉토리" codeGroupCd="BATCH_DIR" required> </select>
                </dd>
                <dd>
                    <select class="style-select width220" name="csvFileNm" title="CSV파일명" codeGroupCd=""  required> </select>
                </dd>
            </dl>
        </div>
        <!--
        <div class="button-bar">
            <button type="button" class="style-btn" auth="R" onclick="doQuery()">조회</button>
        </div>
        -->
    </div>
    <!-- 검색조건 끝 -->


    <div class="variableWrapCode">
        <br /><br />
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doMakeTaUdr()">1. TA 과금 UDR 변환(분)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doMakeFidoUdr()">2. FIDO 과금 UDR 변환(분)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doCalcTaUdr()">3. TA 요금 계산(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doCalcFidoUdr()">4. FIDO 요금 계산(일)</button>
        <br /><br />
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doCustWtBill()">5. 고객사 종량요금 청구(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doBizWtBill()">6. 법인 종량요금 청구(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doUserWtBill()">7. 개인 종량요금 청구(월)</button>
        <br /><br />
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doCalcUserMo()">8. 개인 월정액 요금 계산(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doCalcCustMo()">9. 고객사 월정액 요금 계산(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doCustMoBill()">10. 고객사 정액요금 청구(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doBizMoBill()">11. 법인 정액요금 청구(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doUserMoBill()">12. 개인 정액요금 청구(월)</button>
        <br /><br />
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doServFeeStats()">13. 서비스 요금 매출 집계(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doSalesPgStats()">14. PG 요금 매출 집계(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doSalesServStats()">15. 서비스 매출 현황 집계(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doSettlePgStats()">16. PG 수익 현황 집계(일)</button>
        <br /><br />
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doServFeeStatsMon()">17. 서비스 요금 매출 집계(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doSalesPgStatsMon()">18. PG 요금 매출 집계(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doSalesServStatsMon()">19. 서비스 매출 현황 집계(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doSettlePgStatsMon()">20. PG 수익 현황 집계(월)</button>
        <br /><br />
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doUserJoinStats()">21. 사용자 가입/해지 집계(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doServJoinStats()">22. 서비스 가입/해지 집계(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doServTrfStats()">23. 서비스 트래픽 집계(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doRawGtrStats()">24. 원시 데이터 수집 집계(일)</button> &nbsp;&nbsp;
        <br /><br />
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doUserJoinStatsMon()">25. 사용자 가입/해지 집계(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doServJoinStatsMon()">26. 서비스 가입/해지 집계(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doServTrfStatsMon()">27. 서비스 트래픽 집계(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doRawGtrStatsMon()">28. 원시 데이터 수집 집계(월)</button>
        <br /><br />
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doGetPgTradeFile()">29. PG 거래파일 수집+DB(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doGetPgSettleFile()">30. PG 정산파일 수집+DB(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doGetPgTradeFileMon()">31. PG 거래파일 수집+DB(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doGetPgSettleFileMon()">32. PG 정산파일 수집+DB(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doPgTradeGtrData()">33. PG 거래파일 DB 저장(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doPgSettleGtrData()">34. PG 정산파일 DB 저장(일)</button> &nbsp;&nbsp;
        <br /><br />
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doPgTrade()">35. PG 거래대사 정산(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doPgTradeHisMon()">36. PG 거래대사 비교내역(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doPgTradeHis()">37. PG 거래대사 비교내역(일)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doPgSettle()">38. PG 정산대사 정산(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doPgSettleHisMon()">39. PG 정산대사 비교내역(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doPgSettleHis()">40. PG 정산대사 비교내역(일)</button> &nbsp;&nbsp;
        <br /><br />
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doTamCciGtrData()">41. TAM CCI DB 저장(월)</button> &nbsp;&nbsp;
        <button type="button" class="style-btn" style="color:blue; width:170px; height:25px; font-size:13px; fonw-weight:bold; text-align:left;" auth="C" onclick="doTamSettle()">42. TAM & TA 내역 정산(월)</button> &nbsp;&nbsp;

    </div>

    <br /><br /><br />

    <div id="batch-panel">
    <form id="formBatch" action="" target="frmBatch" method="POST">
        <input type="hidden" name="cnvFlag" />
        <input type="hidden" name="calcFlag" />
        <input type="hidden" name="payFlag" />
        <input type="hidden" name="svcDate" />
        <input type="hidden" name="svcMonth" />
        <input type="hidden" name="jobSeq" />
        <input type="hidden" name="svcType" />
        <input type="hidden" name="fileDir" />
        <input type="hidden" name="csvFile" />
    </form>
    </div>
    <iframe id="frmBatch" name="frmBatch"  src="" title="batch" style="width:100%; height:50px; border:1px solid #000"></iframe>

</div>

