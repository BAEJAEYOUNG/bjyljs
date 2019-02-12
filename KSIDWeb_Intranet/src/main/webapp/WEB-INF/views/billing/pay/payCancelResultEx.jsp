<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="ksid.core.webmvc.util.PayUtil
                ,kr.co.lgcns.module.lite.CnsPayWebConnector4NS"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%//@ include file="incMerchant.jsp" %>

<%
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:include page="${config.includePath}/header.jsp"/>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="euc-kr" lang="euc-kr">
<head>
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>CNSPay 결제 취소 샘플 페이지</title>
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

    function cnspayClose() {
        window.close();
    }

    $(document).ready(function(){
        try {
            $(opener.location).attr("href", "javascript:doSearchUser();");
        } catch (e) {
            console.log(e);
        }
    });

</script>

</head>
<body>
<div id="wrap">
    <div id="header">
        <h1><img src="https://pg.cnspay.co.kr:443/dlp/images/shop/logo.gif" alt="CNSPay 결제 요청" /></h1>
    </div>
    <div id="container">
        <div id="contents">
            <div class="bubble-box">결제 취소 요청이 완료되었습니다.</div>
            <div class="table-box">
                <table>
                    <caption>결제 내역입니다.</caption>
                    <colgroup>
                        <col class="nth-1" />
                        <col class="nth-2" />
                    </colgroup>
                    <tbody>
                        <tr class="nth-1">
                            <th scope="row">결과 내용 :</th>
                            <td><span class="txt-wrap">&nbsp;[${result.resultCode}] ${result.resultMsg}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">결제 수단 :</th>
                            <td><span class="txt-wrap">&nbsp;${result.payMethod}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">취소금액 :</th>
                            <td><span class="txt-wrap">&nbsp;${result.cancelAmt}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">취소일 :</th>
                            <td><span class="txt-wrap">&nbsp;${result.cancelDate}${result.cancelTime}</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="footer">
            <ul>
                <li>- 테스트 아이디인 경우 매시각 30분마다 자동 취소됩니다.
                취소가 성공한 경우에는 다시 승인상태로 복구 할 수 없습니다.
                또한, 국민카드는 테스트가 불가능하며, 체크카드는 부분취소 불가능합니다.</li>
            </ul>
        </div>
    </div>
</div>

    </body>
</html>
