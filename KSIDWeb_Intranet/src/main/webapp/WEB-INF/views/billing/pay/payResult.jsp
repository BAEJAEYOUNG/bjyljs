<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="ksid.core.webmvc.util.PayUtil
                ,kr.co.lgcns.module.lite.CnsPayWebConnectorLite"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%//@ include file="incMerchant.jsp" %>

<%
%>
<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:include page="${config.includePath}/header.jsp"/>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>CNSPay 결제 결과 페이지</title>
<jsp:include page="${config.includePath}/css.jsp"/>
<jsp:include page="${config.includePath}/js.jsp"/>
<link rel="stylesheet" type="text/css" href="https://pg.cnspay.co.kr:443/dlp/css/shop/style.css" />
<style>
html, body {
    background-color: #444444;
    font-family: '돋움', dotum, sans-serif;
    font-size: 12px;
}
</style>
<script type="text/javascript" charset="utf-8">

    $(document).ready(function(){
    });

    function payFinalOpen() {
        var params = {};
        params.payMethod =  "${resultData.payMethod}";
        params.amt =  "${resultData.amt}";
        if( ksid.form.validateForm('edit-panel') ) {
        $("#form1").attr('action', '${pageContext.request.contextPath}/${resultData.payFinalUrl}');
        $("#form1").attr('target', 'userPayFinal');

        var regWin = ksid.ui.openWindow('', 'userPayFinal', 750, 650);

        $("#form1").submit();
        regWin.focus();
        }
    }


    $(window).bind("beforeunload", function(){
        var resultClose = "${resultData.resultCode}";
        if( resultClose == "3001") {
            payFinalOpen();
        }
    });


    function cnsPayClose() {
        window.close();
    }

</script>

</head>
<body>
<form id="form1" name="form1" method="post" action="popup url" target="popup_window">
<input type="hidden" name="spCd" value="${resultData.spCd}"/>
<input type="hidden" name="custId" value="${resultData.custId}"/>
<input type="hidden" name="servId" value="${resultData.servId}"/>
<input type="hidden" name="payFinalUrl" value="${resultData.payFinalUrl}"/>
<input type="hidden" name="telNo" value="${resultData.telNo}"/>
<input type="hidden" name="amt" value="${resultData.amt}"/>
<input type="hidden" name="payMethod" value="${resultData.payMethod}"/>
<input type="hidden" name="payRstDtm" value="${resultData.sendDtm}"/>
<input type="hidden" name="custUserNo" value="${resultData.custUserNo}"/>
<div id="wrap">
    <div id="header">
        <h1><img src="https://pg.cnspay.co.kr:443/dlp/images/shop/logo.gif" alt="CNSPay 결제 요청" /></h1>
    </div>
    <div id="container">
        <div id="contents">
            <div class="bubble-box">결제 요청이 완료되었습니다.</div>
            <div id="edit-panel" class="table-box">
                <table>
                    <caption>결제 내역입니다.</caption>
                    <colgroup>
                        <col class="nth-1" />
                        <col class="nth-2" />
                    </colgroup>
                    <tbody>
                        <tr class="nth-1">
                            <th scope="row">결과 내용 :</th>
                            <td><span class="txt-wrap">&nbsp;[${resultData.resultCode}] ${resultData.resultMsg}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">결제 수단 :</th>
                            <td><span class="txt-wrap">&nbsp;${resultData.payMethod}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">상품명 :</th>
                            <td><span class="txt-wrap">&nbsp;${resultData.goodsName}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">금액 :</th>
                            <td><span class="txt-wrap">&nbsp;${resultData.amt} 원</span></td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row">거래아이디 :</th>
                            <td><span class="txt-wrap">&nbsp;${resultData.tid}</span></td>
                        </tr>
                        <c:choose>
                            <c:when test="${resultData.payMethod eq 'CARD'}">
                                <tr>
                                    <th scope="row">카드사명 :</th>
                                    <td><span class="txt-wrap">${resultData.cardName}&nbsp;</span></td>
                                </tr>
                                <tr>
                                    <th scope="row">할부개월 :</th>
                                    <td><span class="txt-wrap">${resultData.cardQuota}&nbsp;</span></td>
                                </tr>
                                <tr style="display: none;">
                                    <th scope="row">카드사 포인트 :</th>
                                    <td><span class="txt-wrap">${resultData.cardPoint}&nbsp;(0:미사용,1:포인트사용,2:세이브포인트사용)</span></td>
                                </tr>
                                <tr style="display: none;">
                                    <th scope="row">CardBin :</th>
                                    <td><span class="txt-wrap">${resultData.cardBin}&nbsp;</span></td>
                                </tr>
                            </c:when>
                            <c:when test="${resultData.payMethod eq 'BANK'}">
                                <tr>
                                <th scope="row">은행 :</th>
                                <td><span class="txt-wrap">${resultData.bankName}&nbsp;</span></td>
                                </tr>
                                <tr>
                                    <th scope="row">현금영수증 타입 :</th>
                                    <td><span class="txt-wrap">${resultData.rcptType}&nbsp;&nbsp;(0:발행안함,1:소득공제,2:지출증빙)</span></td>
                                </tr>
                            </c:when>
                            <c:when test="${resultData.payMethod eq 'CELLPHONE'}">
                                <tr>
                                    <th scope="row">이통사 구분 :</th>
                                    <td><span class="txt-wrap">${resultData.carrier}&nbsp;</span></td>
                                </tr>
                                <tr>
                                    <th scope="row">휴대폰 번호 :</th>
                                    <td><span class="txt-wrap">${resultData.dstAddr}&nbsp;</span></td>
                                </tr>
                            </c:when>
                            <c:when test="${resultData.payMethod eq 'VBANK'}">
                                <tr>
                                    <th scope="row">입금 은행 :</th>
                                    <td><span class="txt-wrap">${resultData.vbankBankName}&nbsp;</span></td>
                                </tr>
                                <tr>
                                    <th scope="row">입금 계좌 :</th>
                                    <td><span class="txt-wrap">${resultData.vbankNum}&nbsp;</span></td>
                                </tr>
                                <tr>
                                    <th scope="row">입금 기한 :</th>
                                    <td><span class="txt-wrap">${resultData.vbankExpDate}${resultData.vbankExpTime}&nbsp;</span></td>
                                </tr>
                            </c:when>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            <div class="btns">
               <a href="javascript:cnsPayClose();"><img src="${pageContext.request.contextPath}/static/image/ksid/pgCloseBtn.jpg" alt="닫기" /></a>

            </div>
        </div>
        <div class="footer" style="display: none;">
            <ul>
                <li>- 테스트 아이디인 경우 매시각 30분마다 자동 취소됩니다.
                취소가 성공한 경우에는 다시 승인상태로 복구 할 수 없습니다.
                또한, 국민카드는 테스트가 불가능하며, 체크카드는 부분취소 불가능합니다.</li>
            </ul>
        </div>
    </div>
</div>
</form>
</body>
</html>
