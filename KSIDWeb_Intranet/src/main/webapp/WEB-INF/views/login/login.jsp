<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="${config.includePath}/header.jsp"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<!--
[${config}]
 -->
<jsp:include page="${config.includePath}/meta.jsp"/>
<title>${config.pageTitle}</title>
<jsp:include page="${config.includePath}/css.jsp"/>
<!--
<link rel="stylesheet" type="text/css" media="screen" href="${config.cssPath}/ksid/login.css" />
 -->
<link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/css/ksid/login.css" />
<jsp:include page="${config.includePath}/js.jsp"/>
<%--
<script type="text/javascript" src="/static/js/inc/kdk/s3i.stframework.async.api.js"></script>
--%>
<style type="text/css">
table.table_confirm {margin:10px; width: 760px;}
table.table_confirm tr th { text-align:left; font-size:18px; color:black }
table.table_confirm tr td { padding:3px; word-wrap:break-word; word-break:break-all; }
</style>

<script type="text/javascript">

    //보안프레임워크 API 객체 생성
    var fwk_api = {};//new STFRAMEWORK_API();
    //fwk_api.setFwkMethod( "POST" );             // 통신 방식 설정(GET/POST, Default=POST)
    //fwk_api.setFwkAutoStart( true );              // 프레임워크 자동실행 여부
    //fwk_api.setFwkVersion( "1.0.0.99" );    // Framework Version
    //fwk_api.setFwkSetupUrl( "http://192.168.2.161:9090/undemo/S3ISTFrameworkInstall.exe" ); // Installer Download URL

    var wavSuccess = null;
    var wavFail = null;

    var timestamp = "";

    /*****************************************************
     * 함수명 : ready
     * 설명   : onload 함수
     *****************************************************/
    $(document).ready(function() {
    <c:if test="${not empty param.fail && param.fail && not empty SPRING_SECURITY_LAST_EXCEPTION.message}">
        ksid.ui.alert("${SPRING_SECURITY_LAST_EXCEPTION.message}");
        <c:remove var="SPRING_SECURITY_LAST_EXCEPTION" scope="session"/>
    </c:if>
    });


    /*****************************************************
    * 함수명: 시작(common_head 에서 호출)
    * 설명   : onload시 호출됨
    *****************************************************/
    function init() {
        wavSuccess = $('#wav_success')[0];
        wavFail = $('#wav_fail')[0];
    }

    /*****************************************************
    * 함수명: 리사이즈(common_head 에서 호출)
    * 설명   : init 이후, window resize시 호출됨
    *        탭 추가 시 iframe 리사이징을 위해 수동으로 호출 함
    *****************************************************/
    function resize() {
        var height = $(window).height();
    }

    /*****************************************************
    * 함수명: 로그인
    * 설명   :
    *****************************************************/
    function login() {

        $("#loginfrm").submit();

        if (true) return;

        if (ksid.form.validateForm("search-panel")) {
            var params = ksid.form.flushPanel("search-panel");
            ksid.net.ajax("login.do", params, function(result) {
    //              ksid.debug.printObj("result", result);
                if(result.resultCd == "00") {
    //                alert('ksid.language = ' + ksid.language);
                    location.href = "/index.do?language="+ksid.language;
                } else {
                    ksid.ui.alert(result.resultMsg);
                }
            });
        }
    }

    /*****************************************************
    * 함수명: 카드로그인
    * 설명   :
    *****************************************************/
    function cardLogin() {

        timestamp = "" + Math.floor(new Date().getTime() / 100);
        fwk_api.Fwk_Invoke( framework_callback, "kr.co.ksid.BioSmartCardDemoJNI.KSIDBioSmartCardDemoJNI", "JNI_BSCGetSign", "String:" + timestamp );



    }

    function framework_callback( response ) {

        //status :  S - success, F - fail
        var resStatus = response.getStatus();

        if( resStatus != 'S' ) {

            ksid.ui.alert( "error code : " + response.getErrorCode() + "<br /> error text : " + response.getErrorText() );
            return;

        }

        // call success
        var result= response.getResult();
        if( result == null || result.length == 0 )
        {
            ksid.ui.alert( "error text : no response data" );
            return;
        }

        var tmp = result.split("|");

    //    alert("[timestamp]\n" + timestamp + "\n[csn]\n" +tmp[1] + "\n[signature]\n" + tmp[0] );

        var params = {};
        params.equip_no             = ksid.string.right(tmp[1], 16);
        params.sign_data            = timestamp
        params.digital_signature    = tmp[0];

    //    ksid.debug.printObj("params", params);

        ksid.net.ajax("login_card.do", params, function(result) {

            if(result.resultCd == "00") {
                wavSuccess.play();
            } else {
                wavFail.play();
            }

            openConfirmDialog();

            var resultData = {};
            ksid.json.mergeObject(resultData, result.resultData);
            resultData.resultCd     = result.resultCd;
            resultData.resultMsg    = result.resultMsg;

            ksid.form.bindPanel("confirm-panel", resultData);

        });

    }

    function openConfirmDialog() {

        ksid.json.mergeObject(ksid.json.dialogProp, {title:CommonJs.setMsgLanguage("KSID SMARTCARD LOGIN RESULT"), width:800, height:600});
        $("#dialog_device_equip").dialog(ksid.json.dialogProp);

    }

    function login_card_confirm() {

        var resultData = ksid.form.flushPanel("confirm-panel");

        $('#dialog_device_equip').dialog('close');
        if( resultData.resultCd == "00" ) {
            location.href = "/index.do?language="+ksid.language;
        }

    }

</script>
</head>
<body>
<div id="container" class="login">
    <div class="top">
        <h1>
            <img src="${config.imagePath}/ksid/ksidlogo.png" alt=""><!--
            --><span name="title">${config.pageTitle}</span>
        </h1>
    </div>
    <div id="search-panel" class="content">
        <table align="right" style="margin-top:-100px;">
        <form id="loginfrm" name="loginfrm" method="post" action="${contextPath}/j_spring_security_check">
            <tr>
                <td>
                    <div class="loginBox floatLeft">
                       <ul>
                          <li class="title"><span name="title">아이디/비밀번호 로그인</span></li>
                          <li><input type="text" class="loginInput" name="adminId" placeholder="사용자ID" title="사용자ID" value="" maxlength="9" required next="user_pw" ></li>
                          <li><input type="password" class="loginInput" name="adminPw" placeholder="비밀번호" title="비밀번호" value="" required command="login()"></li>
                          <li><a href="javascript:login();"><span name="button">로그인</span></a></li>
                       </ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="loginCardBox">
                       <ul>
                          <li class="title"><span name="title">지문스마트카드 로그인</span></li>
                          <li><a href="javascript:cardLogin();"><img src="${config.imagePath}/ksid/btn_stmartcard_login.png" alt="" style="width:300px;height:132px;" /></a></li>
                       </ul>
                    </div>
                </td>
            </tr>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>
        </table>

    </div>

    <div id="dialog_device_media" style="display:none;" class="dialog">

        <!-- 버튼 시작 -->
        <div class="button-bar" style="margin-right:10px;margin-top:5px; margin-bottom:5px; ">
            <button type="button" onclick="login_card_confirm()" class="style-btn">CONFIRM</button>
        </div>
        <!-- 버튼 끝 -->

        <table style="width:800px; border:1px solid #c5c5c5;"><tr><td></td></tr></table>

        <!-- grid -->
        <div id="confirm-panel" style="width:800px; height:520px; overflow:auto">
            <input type="hidden" name="resultCd" title="결과코드" />
            <table class="table_confirm">
                <tr><th><strong>PKI Digital Signature Verification Result</strong></th><tr>
                <tr><td><span name="resultMsg"></span></td><tr>
                <tr><th><strong>Fingerprint Smart Card No</strong></th><tr>
                <tr><td><span name="card_no" format="card_no">&nbsp;</span></td><tr>
                <tr><th><strong>Sign Data</strong></th><tr>
                <tr><td><span name="sign_data">&nbsp;</span></td><tr>
                <tr><th><strong>Digital Signature Length</strong></th><tr>
                <tr><td><span name="digital_signature_len">&nbsp;</span></td><tr>
                <tr><th><strong>Digital Signature</strong></th><tr>
                <tr><td><span name="digital_signature">&nbsp;</span></td><tr>
                <tr><th><strong>Certification DN</strong></th><tr>
                <tr><td><span name="certification_dn">&nbsp;</span></td><tr>
                <tr><th><strong>Certification Algorithm</strong></th><tr>
                <tr><td><span name="certification_algorithm">&nbsp;</span></td><tr>
                <tr><th><strong>Certification</strong></th><tr>
                <tr><td><span name="certification">&nbsp;</span></td><tr>
            </table>
        </div>
    </div>
</div>
<audio id="wav_success" src="${config.mediaPath}/wave/login_smartcard_success.wav" type="audio/wav">
<audio id="wav_fail" src="${config.mediaPath}/wave/login_smartcard_fail.wav" type="audio/wav">

</body>
</html>
<jsp:include page="${config.includePath}/footer.jsp"/>
