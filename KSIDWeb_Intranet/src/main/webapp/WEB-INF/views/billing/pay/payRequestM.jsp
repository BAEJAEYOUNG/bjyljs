<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ksid.core.webmvc.util.PayUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:useBean id="payUtil" class="ksid.core.webmvc.util.PayUtil"/>
<jsp:useBean id="dateLib" class="ksid.core.webmvc.util.DateLib"/>
<%//@ include file="incMerchant.jsp" %>
<%
String ediDate = PayUtil.getDate("yyyyMMddHHmmss"); // 전문생성일시
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:include page="${config.includePath}/header.jsp"/>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>CNSPay 모바일 결제 페이지(OCU)</title>
<jsp:include page="${config.includePath}/css.jsp"/>
<jsp:include page="${config.includePath}/js.jsp"/>
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="content-type" content="text/html; charset=utf-8" />

<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
<link rel="stylesheet" type="text/css" href="https://pg.cnspay.co.kr:443/dlp/css/shop/styleM.css" />
<link rel="stylesheet" href="https://pg.cnspay.co.kr:443/dlp/css/mobile/cnspay.css" type="text/css" />

<script src="https://pg.cnspay.co.kr:443/dlp/scripts/lib/easyXDM.min.js" type="text/javascript"></script>
<script src="https://pg.cnspay.co.kr:443/dlp/scripts/lib/json3.min.js" type="text/javascript"></script>
<script src="https://pg.cnspay.co.kr:443/dlp/cnspay_tr.js" type="text/javascript"></script>


<script type="text/javascript" charset="utf-8">

    /**
    최종 결제 요청하는 함수
    */
    function cnspaySubmit(){
        //모바일앱으로 결제창 호출인 경우
        if(m_device_type === 'APP'){
            if(getMobileDeviceOS() === 'android'){
                window.isdlpshown.setMessage('NO');
            }else{
                window.location = 'isdlpshown://NO';
            }
        }

        document.payForm.target = "_self";
        document.payForm.action = "resultM";
        document.payForm.method = "post";
        document.payForm.submit();
    }

    /**
    cnspay	를 통해 결제를 시작합니다.
    */
    function cnspay() {
        var payForm = document.payForm;
        var params = {};
        if(document.payForm.BuyerName.value == "") {
            ksid.ui.alert("구매자명을 입력하셔야 합니다.");
            return;
        }

        if(document.payForm.BuyerTel.value == "") {
            ksid.ui.alert("구매자 전화번호를 입력하셔야 합니다.");
            return;
        }
        document.payForm.PayMethod.value = selectedPayMethod('selectType');

        // 필수 사항들을 체크하는 로직을 삽입해주세요.
        goPay(payForm);

    }

    /**
    결제 취소시 호출하게 되는 함수
    */
    function cnspayClose(){
        //모바일앱으로 결제창 호출인 경우
        if(m_device_type === 'APP'){
            if(getMobileDeviceOS() === 'android'){
                window.isdlpshown.setMessage('NO');
            }else{
                window.location = 'isdlpshown://NO';
            }
        }
        ksid.ui.alert("결제가 취소 되었습니다.");
    }

    /**
    팝업창내 레이어 DLP인경우 팝업 리사이즈시 호출하게 되는 함수
    */
    function p_dlpReSize(){
        if(typeof(p_win) !== "undefined" && p_win != null) {
            p_win.resizeTo(p_w_pop_ex, p_h_pop_ex);
        }
    }

    /**
    모바일 APP의 BACK 버튼 클릭시 호출하게 되는 함수
    */
    function cnspayAppClose(){
        //모바일앱으로 결제창 호출인 경우
        if(m_device_type === 'APP'){
            if(getMobileDeviceOS() === 'android'){
                window.isdlpshown.setMessage('NO');
            }else{
                window.location = 'isdlpshown://NO';
            }
        }

        mnCloseDlp();
    }

    $(document).ready(function(){
        var params = {};
        //document.payForm.BuyerTel.value = "${resultData.spNo}" + "-" + "${resultData.kookBun}" + "-" + "${resultData.junBun}";
        document.payForm.GoodsName.value = "${resultData.servNm}";
        document.payForm.Amt.value = "${resultData.billPrice}";
        document.payForm.CustUserNo.value = "${resultData.custUserNo}";
        ksid.net.ajax("${pageContext.request.contextPath}/cnspay/oidGet", params, function(result) {
            document.payForm.Moid.value = result.resultCd;
        });
    });


</script>

</head>

<body>
<form name="payForm" action="cnspay/resultM"  method="post">
<input type="hidden" name="spCd" value="${resultData.spCd}"/>
<input type="hidden" name="custId" value="${resultData.custId}"/>
<input type="hidden" name="servId" value="${resultData.servId}"/>
<input type="hidden" name="payFinalUrl" value="${resultData.payFinalUrl}"/>
<input type="hidden" name="ediDate" value="<%= ediDate %>"/>
<input type="hidden" name="CustUserNo" value="${resultData.custUserNo}">
<%-- <input type="hidden" name="billPrice" value="${resultData.billPrice}"/> --%>
<div id="wrap">
    <div id="header">
        <h1><img src="https://pg.cnspay.co.kr:443/dlp/images/shop/logo.gif" alt="CNSPay 결제 요청" /></h1>
    </div>
    <div id="container">
        <div id="contents">

            <div class="table-box">
                <table>
                    <caption>정보를 기입하신 후 확인버튼을 눌러주십시오.</caption>
                    <colgroup>
                        <col class="nth-1" />
                        <col class="nth-2" />
                    </colgroup>
                    <tbody>
                        <tr class="nth-1">
                            <th scope="row">결제수단</th>
                            <td>
                                <select name="selectType" id="">
                                    <option value="CARD">신용카드</option>
                                    <option value="BANK">계좌이체</option>
<!--                                     <option value="VBANK">가상계좌</option> -->
<!--                                     <option value="CELLPHONE">휴대폰결제</option> -->
<!--                                     <option value="KAKAOPAY">카카오페이</option> -->
<!--                                     <option value="">전체선택</option> -->
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="">결제타입 :</label></th>
                            <td>
                                <select name="TransType">
                                    <option value="0" selected>일반결제</option>
<!--                                     <option value="1">에스크로</option> -->
                                </select>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row"><label for="">학번 :</label></th>
                            <td><input name="CustUserNo" type="text" value=""/></td>
                        </tr>

                        <tr>
                            <th scope="row" class="require"><label for=""><span class="dot"></span>상품명 :</label></th>
                            <td><input name="GoodsName" type="text" value="" readonly="readOnly"/></td>
                        </tr>
                        <tr>
                            <th scope="row" class="require"><label for=""><span class="dot"></span>상품가격 :</label></th>
                            <td><input name="Amt" type="text" value="" readonly="readOnly"/></td>
                        </tr>
                       <tr style="display: none;">
                            <th scope="row"><label for="">상품주문번호 :</label></th>
                            <td><input name="Moid" type="text" value=""/></td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row" class="require"><label for=""><span class="dot"></span>가상계좌수취인명 :</label></th>
                            <td><input name="VbankAccountName" type="text" value="" maxlength="7"/></td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row" class="require"><label for=""><span class="dot"></span>가상계좌입금만료일 :</label></th>
                            <td><input name="VbankExpDate" type="text" value="<%= ediDate.substring(0,8) %>" maxlength="12"/></td>
                        </tr>
                        <tr>
                            <th scope="row" class="require"><label for=""><span class="dot"></span>구매자명 :</label></th>
                            <td><input name="BuyerName" type="text" value=""/></td>
                        </tr>
                        <tr>
                            <th scope="row" class="require"><label for=""><span class="dot"></span>구매자 이메일 :</label></th>
                            <td><input name="BuyerEmail" type="text" value=""/></td>
                        </tr>
                        <tr>
                            <th scope="row" class="require"><label for=""><span class="dot"></span>구매자 전화번호 :</label></th>
                            <td><input name="BuyerTel" type="text" value=""/></td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row" class="require"><label for=""><span class="dot"></span>상점아이디 :</label></th>
                            <td><input name="MID" type="text" value="${resultData.mid}" /></td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row"><label for="">테마 :</label></th>
                            <td>
                                <select name ="SkinType">
                                    <option value=""></option>
                                    <option value="blue">블루</option>
                                    <option value="red">레드</option>
                                    <option value="black">블랙</option>
                                    <option value="green">그린</option>
                                </select>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row"><label for="">상품제공기간 구분 :</label></th>
                            <td>
                                <select name ="OfferPeriodFlag">
                                    <option value="Y">사용</option>
                                    <option value="N">미사용</option>
                                    <option value="">별도제공기간없음</option>
                                </select>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row"><label for="">상품제공기간 :</label></th>
                            <td><input name="OfferPeriod" type="text" value="<%= ediDate.substring(0,4) %>.<%= ediDate.substring(4,6) %>.<%= ediDate.substring(6,8) %>" maxlength="30"/></td>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row"><label for="">가맹점 접근타입(모바일) :</label></th>
                            <td>
                                <select name ="MerDeviceType">
                                    <option value="WEB">모바일 웹</option>
                                    <option value="APP">모바일 앱</option>
                                </select>
                            </td>
                        </tr>
                        <tr style="display: none;">
                              <th colspan="2">휴대폰소액결제 부가정보</th>
                        </tr>
                        <tr style="display: none;">
                            <th scope="row"><label for="">상품구분 :</label></th>
                            <td id="borderBottom" >
                                <select name ="GoodsCl">
                                    <option value="1">실물</option>
                                    <option value="0">컨텐츠</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btns">
                <a href="javascript:cnspay();"><img src="https://pg.cnspay.co.kr:443/dlp/images/shop/btn-ask.gif" alt="결제 요청하기" /></a>
            </div>
        </div>
        <div class="footer" style="display: none;">
            <ul>
                <li>- <strong>필수입력 항목 </strong></li>
                <li>* 신용카드 : 상품명, 상품가격, 구매자명, 구매자이메일, 구매자전화번호, 상점아이디</li>
                <li>* 계좌이체 : 상품명, 상품가격, 구매자명, 구매자이메일, 구매자전화번호, 상점아이디</li>
                <li>* 가상계좌 : 상품명, 상품가격, 구매자명, 구매자이메일, 구매자전화번호, 상점아이 </li>
                <li>* 휴대폰결제 : 상품명, 상품가격, 구매자명, 구매자이메일, 구매자전화번호, 상점아이디, 상품구분('실물'선택)</li>
                <li>* 카카오페이 : 상품명, 상품가격, 구매자명, 상점아이디</li>
                <li>- <strong>테스트 아이디로 결제된 건에대해서는 당일 오후 11:30분에 일괄 취소됩니다.</strong></li>
                <li>- 실제아이디 적용시 테스트아이디가 적용되지 않도록 각별한 주의를 부탁드립니다.</li>
            </ul>
        </div>
    </div>
</div>
    <input type="hidden" name="PayMethod" value="">
    <!-- 주소 -->
    <input type="hidden" name="BuyerAddr" value="서울시 강남구 역삼동 9-11">
    <!-- 상품 갯수 -->
    <input type="hidden" name="GoodsCnt" value="1">

    <!-- 결제 옵션  -->
    <input type="hidden" name="optionList" value="">
    <!-- 구매자 고객 ID -->
    <input type="hidden" name="MallUserID" value="">
    <input type="hidden" name="SUB_ID" value="">

    <input type="hidden" name="EdiDate" value="${resultData.ediDate}">
    <input type="hidden" name="EncryptData" value="${resultData.hashString}">
</form>
    </body>
</html>
