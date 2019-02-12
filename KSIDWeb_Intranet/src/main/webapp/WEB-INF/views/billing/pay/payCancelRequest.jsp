<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ksid.core.webmvc.util.PayUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<jsp:include page="${config.includePath}/header.jsp"/>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

    <jsp:include page="${config.includePath}/meta.jsp"/>
    <title>CNSPay 결제 샘플 페이지</title>
    <jsp:include page="${config.includePath}/css.jsp"/>
    <jsp:include page="${config.includePath}/js.jsp"/>
    <title>CNSPay 결제 샘플 페이지</title>
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />

    <link rel="stylesheet" type="text/css" href="https://pg.cnspay.co.kr:443/common/css/style.css" />

    <script type="text/javascript">

    var requestParam = null;

    $(document).ready(function(){

        requestParam = ${requestParam};
        var params = {};

        params.MID = requestParam.payMid;
        params.TID = requestParam.payTid;
        params.CancelAmt = requestParam.payCancelAmt;
        params.PartialCancelCode = (requestParam.payCancelFg == 'T') ? '0' : '1';
//         params.CancelPwd = requestParam.cancelPwd;

        ksid.form.bindPanel('tranMgr', requestParam);
        ksid.form.bindPanel('tranMgr', params);

        $("#tranMgr select[name=PartialCancelCode] option").not(":selected").attr("disabled", "disabled");
        $("#tranMgr select[name=PreCancelCode] option").not(":selected").attr("disabled", "disabled");

    });

    function goCancel() {

        var formNm = document.tranMgr;

        // TID validation
        if(formNm.TID.value == "") {
            alert("TID를 확인하세요.");
            return ;
        } else if(formNm.TID.value.length > 30 || formNm.TID.value.length < 30) {
            alert("TID 길이를 확인하세요.");
            return ;
        }
        // 취소금액
        if(formNm.CancelAmt.value == "") {
            alert("금액을 입력하세요.");
            return ;
        } else if(formNm.CancelAmt.value.length > 12 ) {
            alert("금액 입력 길이 초과.");
            return ;
        }

        if(formNm.PartialCancelCode.value == '1'){
            if(formNm.TID.value.substring(10,12) != '01' &&  formNm.TID.value.substring(10,12) != '02' &&  formNm.TID.value.substring(10,12) != '03'){
                alert("신용카드결제, 계좌이체, 가상계좌만 부분취소/부분환불이 가능합니다");
                return false;
            }
        }

//         ksid.debug.printObj(ksid.form.flushPanel('tranMgr'));

//         return;

        ksid.ui.confirm('취소하시겠습니까?', function(){
            formNm.submit();
        });

    }
    </script>

</head>
<body>
    <form id="tranMgr" name="tranMgr" method="post" action="${pageContext.request.contextPath}/cnspaycancel/result">


    <input type="hidden" name="CancelPwd" title="취소비밀번호" />
    <input type="hidden" name="spCd" title="서비스제공자코드" />
    <input type="hidden" name="custId" title="고객사아이디" />
    <input type="hidden" name="servId" title="서비스아이디" />
    <input type="hidden" name="telNo" title="휴대폰번호" />
    <input type="hidden" name="userId" title="사용자아이디" />

    <input type="hidden" name="MID" />
    <input type="hidden" name="TID" />

    <div id="wrap">
        <div id="header">
            <h1><img src="https://pg.cnspay.co.kr:443/images/logo-cancel.gif" alt="CNSPay 취소 요청" /></h1>
        </div>
        <div id="container">
            <div id="contents">
<!--                 <div class="bubble-box">취소 요청페이지 샘플입니다.</div> -->
                <div class="table-box">
                    <table>
                        <caption>정보를 기입하신 후 확인버튼을 눌러주십시오.</caption>
                        <colgroup>
                            <col class="nth-1" />
                            <col class="nth-2" />
                        </colgroup>
                        <tbody>
                            <tr class="nth-1">
                                <th scope="row" class="require"><label for=""><span class="dot">*</span>상품명 :</label></th>
                                <td><input type="text" name="goodsName" maxlength="30" readonly /></td>
                            </tr>
<!--                             <tr> -->
<!--                                 <th scope="row" class="require"><label for=""><span class="dot">*</span>TID :</label></th> -->
<!--                                 <td><input type="text" name="TID" id="" value="" maxlength="30" readonly /></td> -->
<!--                             </tr> -->
                            <tr>
                                <th scope="row" class="require"><label for=""><span class="dot">*</span>취소 금액 :</label></th>
                                <td><input type="text" name="CancelAmt" id="" value="" readonly /></td>
                            </tr>
<!--                             <tr> -->
<!--                                 <th scope="row"><label for=""><span class="dot"></span>잔액 :</label></th> -->
<!--                                 <td><input type="text" name="CheckRemainAmt" id="" value="" readonly /></td> -->
<!--                             </tr> -->
                            <tr>
                                <th scope="row" class="require"><label for=""><span class="dot">*</span>취소 사유 :</label></th>
                                <td><input type="text" name="CancelMsg" id="" value="고객 요청" readonly /></td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="">부분취소 여부 :</label></th>
                                <td>
                                    <select name="PartialCancelCode" readonly>
                                        <option value="0">전체 취소</option>
                                        <option value="1">부분 취소</option>
                                    </select>
                                </td>
                            </tr>
<!--                             <tr> -->
<!--                                 <th scope="row"><label for="">전/후취소 여부 :</label></th> -->
<!--                                 <td> -->
<!--                                     <select name="PreCancelCode"> -->
<!--                                         <option value="0">전취소</option> -->
<!--                                         <option value="1">후취소</option> -->
<!--                                         <option value="">null</option> -->
<!--                                     </select> -->
<!--                                 </td> -->
<!--                             </tr> -->
                        </tbody>
                    </table>
                </div>
                <div class="btns">
                    <a href="javascript:goCancel();"><img src="https://pg.cnspay.co.kr:443/images/btn-cancel.gif" alt="취소하기" /></a>
                </div>
            </div>
            <div class="footer">
                <ul>
                    <li>- <span class="dot">*</span> 표 항목은 반드시 기입해주시길 바랍니다.</li>
                    <li>- <strong>취소가 이루어진 후에는 다시 되돌릴 수 없으니 이점 참고하시기 바랍니다.</strong></li>
                </ul>
            </div>
        </div>
    </div>
    </form>
</body>
</html>

