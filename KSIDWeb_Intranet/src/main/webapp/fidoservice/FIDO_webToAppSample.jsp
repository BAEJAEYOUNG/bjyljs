<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="apple-itunes-app" content="app-id=426081742, affiliate-data=myAffiliateData, app-argument=myURL">
<script language=javascript src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
<script language=javascript src="./UniSignFIDOW2AUtil.js"></script>
<script language=javascript src="./UniSignFIDOW2AExtension.js"></script>

<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.parser.JSONParser" %>

<%@ page import="sun.misc.BASE64Decoder" %>

<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.io.BufferedReader" %>

<%
    String resultState = request.getParameter("resultState");
	String result = request.getParameter("result");
	String rtnParam = request.getParameter("rtnParam");
	String sidResult = request.getParameter("sidResult");
	
    String productType = request.getParameter("product_type");
	String errCode = request.getParameter("ErrCode");
	String authToken = request.getParameter("AuthToken");

	if (result != null) {
		result = java.net.URLDecoder.decode(result);
		out.print("result length : " + result.length() + "<p>");
		out.print("result : " + result + "<p>");
	}

	if (resultState != null) {
		out.print("result state : " + resultState + "<p>");
	}

	if (rtnParam != null) {
		out.print("rtnParam : " + rtnParam + "<p>");
	}
	if (sidResult != null) {
		out.print("sidResult : " + sidResult + "<p>");
		out.print("<p>");
	}
    
    if (productType != null) {
        out.print("productType : " + productType + "<p>");
        out.print("<p>");
    }
	if (errCode != null) {
        if ("FIDO".equals(productType) || "FIDO_PINPAD".equals(productType)) {
            // urlsafe
            errCode = errCode.replaceAll("[-]", "+");
            errCode = errCode.replaceAll("[_]", "/");
            while (errCode.length() % 4 != 0) {
                errCode += "=";
            }
            out.print("urlsafe decode base64 : " + errCode + "<p>");

            // base64decoder
            BASE64Decoder decoder = new BASE64Decoder();
            String jsonStr = new String(decoder.decodeBuffer(errCode));
            out.print("decoding json : " + jsonStr + "<p>");

            // json parsings
            try {
                JSONParser jsonParser = new JSONParser();
                JSONObject jsonObj = (JSONObject) jsonParser.parse(jsonStr);

                out.print("errCode : " + jsonObj.get("errCode") + "<p>");
                out.print("errMessage : " + jsonObj.get("errMessage") + "<p>");
                out.print("authToken : " + jsonObj.get("authToken") + "<p>");
                if (jsonObj.get("authToken") != null) {
                    %>
                    <p><a href="javascript:authTokenValidate('<%= jsonObj.get("authToken") %>')">authToken 검증 정보 획득</a></p>
                    <p><iframe name="iFrame_authToken_validate" width="550px;" height="70px;"></iframe></p>
                    <%
                }
                if (jsonObj.get("extension") != null) {
                    out.print("extension : " + new String(decoder.decodeBuffer(jsonObj.get("extension").toString())) + "<p>");   
                } else {
                    out.print("extension : " + jsonObj.get("extension") + "<p>");
                }
                out.print("<p>");

            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            
        } else {
            out.print("errCode : " + errCode + "<p>");
            out.print("<p>");
        }
	}
%>

<title>UniSign Web to App</title>
</head>
<!-- <body onLoad="javascript:showResult('result');"> -->
<body onLoad="javascript:mobileLicense();">

    <p align='left'>원문</p>
    <textarea id='plainText' rows='10' cols='100'>88d4266fd4e6338d13b845fcf289579d209c897823b9217da3e161936f031589</textarea>

    <p>SERVICETYPE
        <input TYPE="radio" id="serviceType1" name="serviceType" value="0" checked="checked"/><label for="serviceType1">FIDO(0)</label><br/>
        <input TYPE="radio" id="serviceType2" name="serviceType" value="1"/><label for="serviceType2">K_FIDO(1)</label>
    </p>
    <p>BIOTYPE
        <input TYPE="radio" id="bioType1" name="bioType" value="2" checked="checked"/><label for="bioType1">지문("2",USER_VERIFY_FINGERPRINT)</label><br/>
        <input TYPE="radio" id="bioType2" name="bioType" value="4"/><label for="bioType2">핀("4",USER_VERIFY_PASSCODE)</label>
    </p>
    <p>
        <a href="javascript:FIDOW2A.reg(_RET_SELF_URL, _APPKEY_FIDO, genCCFIDOProtocol('Reg', false));">FIDO Reg</a>
    </p>
    <p>
        <a href="javascript:FIDOW2A.reg(_RET_SELF_URL, _APPKEY_ERROR, genCCFIDOProtocol('Reg', false));">FIDO Reg(license error)</a>
    </p>
    <p>
        <a href="javascript:FIDOW2A.auth(_RET_SELF_URL, _APPKEY_FIDO, genCCFIDOProtocol('Auth', false));">FIDO Auth</a>
    </p>
    <p>
        <a href="javascript:FIDOW2A.auth(_RET_SELF_URL, _APPKEY_FIDO, genCCFIDOProtocol('Auth', true));">FIDO TC</a>
    </p>
    <p>
        <a href="javascript:FIDOW2A.dereg(_RET_SELF_URL, _APPKEY_FIDO, genCCFIDOProtocol('Dereg', false));">FIDO Dereg</a>
    </p>
 

</body>

<script type="text/javascript" language=javascript>
    _RET_SELF_URL = window.location.href.split(/[?#]/)[0];;
    //_RET_VERIFY_ESIGN_URL = 'http://auth.crosscert.com/unisign/verify.jsp';               // 전자서명 검증 
    _RET_VERIFY_ESIGN_URL = 'http://203.248.34.71:9999/unisign-sample/websample.jsp';// 전자서명 검증
    _RET_VERIFY_ESIGN_NO_CONTENT_URL = 'http://203.248.34.71:9999/unisign-sample/websample.jsp';// 전자서명 검증  
    //_RET_VERIFY_ESIGN_R_URL = 'http://auth.crosscert.com/unisign/verify_vidr.jsp';    // 전자서명 + R 검증 
    _RET_VERIFY_ESIGN_R_URL = 'http://203.248.34.71:9999/unisign-sample/websample.jsp'; // 전자서명 + R 검증 
    _RET_VERIFY_URL = 'http://auth.crosscert.com/ccc-sample/server/verify3.jsp';    // 전자서명 검증 페이지 : Server Toolkit
	
	/* WebToApp type */
    _APPKEY = '';
	_APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuOzYgNzkHGgUaCgIAfnRya3xlY3J2Z2R1f253fmJyc2Z+Zy8Fc3ZnaHlnfR4hFjYuLR42dD1qPCUMJHQdNhIrHX0ZPBJwNWlx';
	_APPKEY_IOS_UNISIGN = 'zitZkT9Juxxa+e415nyjmA==';
	_APPKEY_FIDO = 'FjwmADokKwE5LTs3FSY8KyYuiILi+oWulJaJjYS7LxANGxwaFA1oZGN4eXR9e2ZzdWN7fmFzdGVkenlyORphdXJlf2pgc2FkcH1tc2F9JioQMDMLNDI1aw0UBwsGGWoHCDwpJz0PDCUVcXQ=';
	_APPKEY_ERROR = "AAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    
    _ETAX_DATA = 'PFRheEludm9pY2UgeG1sbnM9InVybjprcjpvcjprZWM6c3RhbmRhcmQ6VGF4OlJldXNhYmxlQWdncmVnYXRlQnVzaW5lc3NJbmZvcm1hdGlvbkVudGl0eVNjaGVtYU1vZHVsZToxOjAiIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0idXJuOmtyOm9yOmtlYzpzdGFuZGFyZDpUYXg6UmV1c2FibGVBZ2dyZWdhdGVCdXNpbmVzc0luZm9ybWF0aW9uRW50aXR5U2NoZW1hTW9kdWxlOjE6MCBodHRwOi8vd3d3LmtlYy5vci5rci9zdGFuZGFyZC9UYXgvVGF4SW52b2ljZVNjaGVtYU1vZHVsZV8xLjAueHNkIj4KCTxFeGNoYW5nZWREb2N1bWVudD4KCQk8SUQ+MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0PC9JRD4KCQk8SXNzdWVEYXRlVGltZT4yMDA5MDQwMjEwNDUyMjwvSXNzdWVEYXRlVGltZT4KCQk8UmVmZXJlbmNlZERvY3VtZW50PgoJCQk8SUQ+MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0PC9JRD4KCQk8L1JlZmVyZW5jZWREb2N1bWVudD4KCTwvRXhjaGFuZ2VkRG9jdW1lbnQ+Cgk8VGF4SW52b2ljZURvY3VtZW50PgoJCTxJc3N1ZUlEPjIwMDkwNDAyMDAwMDAwMDAxMTExMTExMTwvSXNzdWVJRD4KCQk8VHlwZUNvZGU+MDEwMTwvVHlwZUNvZGU+CgkJPERlc2NyaXB0aW9uVGV4dD7lravmsJHnm7g8L0Rlc2NyaXB0aW9uVGV4dD4KCQk8SXNzdWVEYXRlVGltZT4yMDA5MDQwMjwvSXNzdWVEYXRlVGltZT4KCQk8UHVycG9zZUNvZGU+MDE8L1B1cnBvc2VDb2RlPgoJCTxSZWZlcmVuY2VkSW1wb3J0RG9jdW1lbnQ+CgkJCTxJRD4xMjM0NTY3ODkwMTIzNDU8L0lEPgoJCQk8SXRlbVF1YW50aXR5PjEyMzQ1NjwvSXRlbVF1YW50aXR5PgoJCQk8QWNjZXB0YWJsZVBlcmlvZD4KCQkJCTxTdGFydERhdGVUaW1lPjIwMDkwNDAyPC9TdGFydERhdGVUaW1lPgoJCQkJPEVuZERhdGVUaW1lPjIwMDkwNDAyPC9FbmREYXRlVGltZT4KCQkJPC9BY2NlcHRhYmxlUGVyaW9kPgoJCTwvUmVmZXJlbmNlZEltcG9ydERvY3VtZW50PgoJPC9UYXhJbnZvaWNlRG9jdW1lbnQ+Cgk8VGF4SW52b2ljZVRyYWRlU2V0dGxlbWVudD4KCQk8SW52b2ljZXJQYXJ0eT4KCQkJPElEPjEyMzQ1Njc4OTA8L0lEPgoJCQk8VHlwZUNvZGU+6riI7Jy1LOuztO2XmCzrtoAxPC9UeXBlQ29kZT4KCQkJPE5hbWVUZXh0PuyghOusuOqxtOyEpOqzteygnOyhsO2VqeqwleumieyngOygkDwvTmFtZVRleHQ+CgkJCTxDbGFzc2lmaWNhdGlvbkNvZGU+64yA67aALOuztOymnSzsnoTrjIAxPC9DbGFzc2lmaWNhdGlvbkNvZGU+CgkJCTxTcGVjaWZpZWRPcmdhbml6YXRpb24+CgkJCQk8VGF4UmVnaXN0cmF0aW9uSUQ+MTIzNDwvVGF4UmVnaXN0cmF0aW9uSUQ+CgkJCTwvU3BlY2lmaWVkT3JnYW5pemF0aW9uPgoJCQk8U3BlY2lmaWVkUGVyc29uPgoJCQkJPE5hbWVUZXh0PjEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvTmFtZVRleHQ+CgkJCTwvU3BlY2lmaWVkUGVyc29uPgoJCQk8RGVmaW5lZENvbnRhY3Q+CgkJCQk8RGVwYXJ0bWVudE5hbWVUZXh0PjEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTA8L0RlcGFydG1lbnROYW1lVGV4dD4KCQkJCTxQZXJzb25OYW1lVGV4dD4xMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTA8L1BlcnNvbk5hbWVUZXh0PgoJCQkJPFRlbGVwaG9uZUNvbW11bmljYXRpb24+MTIzNDU2Nzg5MDEyMzQ1Njc4OTA8L1RlbGVwaG9uZUNvbW11bmljYXRpb24+CgkJCQk8VVJJQ29tbXVuaWNhdGlvbj4xMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwPC9VUklDb21tdW5pY2F0aW9uPgoJCQk8L0RlZmluZWRDb250YWN0PgoJCQk8U3BlY2lmaWVkQWRkcmVzcz4KCQkJCTxMaW5lT25lVGV4dD4xMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTA8L0xpbmVPbmVUZXh0PgoJCQk8L1NwZWNpZmllZEFkZHJlc3M+CgkJPC9JbnZvaWNlclBhcnR5PgoJCTxJbnZvaWNlZVBhcnR5PgoJCQk8SUQ+MTIzNDU2Nzg5MDwvSUQ+CgkJCTxUeXBlQ29kZT4xMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwPC9UeXBlQ29kZT4KCQkJPE5hbWVUZXh0PjEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvTmFtZVRleHQ+CgkJCTxDbGFzc2lmaWNhdGlvbkNvZGU+MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvQ2xhc3NpZmljYXRpb25Db2RlPgoJCQk8U3BlY2lmaWVkT3JnYW5pemF0aW9uPgoJCQkJPFRheFJlZ2lzdHJhdGlvbklEPjEyMzQ8L1RheFJlZ2lzdHJhdGlvbklEPgoJCQkJPEJ1c2luZXNzVHlwZUNvZGU+MDE8L0J1c2luZXNzVHlwZUNvZGU+CgkJCTwvU3BlY2lmaWVkT3JnYW5pemF0aW9uPgoJCQk8U3BlY2lmaWVkUGVyc29uPgoJCQkJPE5hbWVUZXh0PjEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvTmFtZVRleHQ+CgkJCTwvU3BlY2lmaWVkUGVyc29uPgoJCQk8UHJpbWFyeURlZmluZWRDb250YWN0PgoJCQkJPERlcGFydG1lbnROYW1lVGV4dD4xMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwPC9EZXBhcnRtZW50TmFtZVRleHQ+CgkJCQk8UGVyc29uTmFtZVRleHQ+MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwPC9QZXJzb25OYW1lVGV4dD4KCQkJCTxUZWxlcGhvbmVDb21tdW5pY2F0aW9uPjEyMzQ1Njc4OTAxMjM0NTY3ODkwPC9UZWxlcGhvbmVDb21tdW5pY2F0aW9uPgoJCQkJPFVSSUNvbW11bmljYXRpb24+MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvVVJJQ29tbXVuaWNhdGlvbj4KCQkJPC9QcmltYXJ5RGVmaW5lZENvbnRhY3Q+CgkJCTxTZWNvbmRhcnlEZWZpbmVkQ29udGFjdD4KCQkJCTxEZXBhcnRtZW50TmFtZVRleHQ+MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvRGVwYXJ0bWVudE5hbWVUZXh0PgoJCQkJPFBlcnNvbk5hbWVUZXh0PjEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvUGVyc29uTmFtZVRleHQ+CgkJCQk8VGVsZXBob25lQ29tbXVuaWNhdGlvbj4xMjM0NTY3ODkwMTIzNDU2Nzg5MDwvVGVsZXBob25lQ29tbXVuaWNhdGlvbj4KCQkJCTxVUklDb21tdW5pY2F0aW9uPjEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTA8L1VSSUNvbW11bmljYXRpb24+CgkJCTwvU2Vjb25kYXJ5RGVmaW5lZENvbnRhY3Q+CgkJCTxTcGVjaWZpZWRBZGRyZXNzPgoJCQkJPExpbmVPbmVUZXh0PjEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvTGluZU9uZVRleHQ+CgkJCTwvU3BlY2lmaWVkQWRkcmVzcz4KCQk8L0ludm9pY2VlUGFydHk+CgkJPFNwZWNpZmllZFBheW1lbnRNZWFucz4KCQkJPFR5cGVDb2RlPjEwPC9UeXBlQ29kZT4KCQkJPFBhaWRBbW91bnQ+MjQ2OTEzNTc4MDI0NjkxMjwvUGFpZEFtb3VudD4KCQk8L1NwZWNpZmllZFBheW1lbnRNZWFucz4KCQk8U3BlY2lmaWVkTW9uZXRhcnlTdW1tYXRpb24+CgkJCTxDaGFyZ2VUb3RhbEFtb3VudD4xMjM0NTY3ODkwMTIzNDU2PC9DaGFyZ2VUb3RhbEFtb3VudD4KCQkJPFRheFRvdGFsQW1vdW50PjEyMzQ1Njc4OTAxMjM0NTY8L1RheFRvdGFsQW1vdW50PgoJCQk8R3JhbmRUb3RhbEFtb3VudD4yNDY5MTM1NzgwMjQ2OTEyPC9HcmFuZFRvdGFsQW1vdW50PgoJCTwvU3BlY2lmaWVkTW9uZXRhcnlTdW1tYXRpb24+Cgk8L1RheEludm9pY2VUcmFkZVNldHRsZW1lbnQ+Cgk8VGF4SW52b2ljZVRyYWRlTGluZUl0ZW0+CgkJPFNlcXVlbmNlTnVtZXJpYz4wMTwvU2VxdWVuY2VOdW1lcmljPgoJCTxEZXNjcmlwdGlvblRleHQ+MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDwvRGVzY3JpcHRpb25UZXh0PgoJCTxJbnZvaWNlQW1vdW50PjEyMzQ1Njc4OTAxMjM0NTY8L0ludm9pY2VBbW91bnQ+CgkJPENoYXJnZWFibGVVbml0UXVhbnRpdHk+OTk5OTk5OTk5Ljk5PC9DaGFyZ2VhYmxlVW5pdFF1YW50aXR5PgoJCTxJbmZvcm1hdGlvblRleHQ+MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwPC9JbmZvcm1hdGlvblRleHQ+CgkJPE5hbWVUZXh0PjEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTA8L05hbWVUZXh0PgoJCTxQdXJjaGFzZUV4cGlyeURhdGVUaW1lPjIwMDkwNDAyPC9QdXJjaGFzZUV4cGlyeURhdGVUaW1lPgoJCTxUb3RhbFRheD4KCQkJPENhbGN1bGF0ZWRBbW91bnQ+MTIzNDU2Nzg5MDEyMzQ1NjwvQ2FsY3VsYXRlZEFtb3VudD4KCQk8L1RvdGFsVGF4PgoJCTxVbml0UHJpY2U+CgkJCTxVbml0QW1vdW50PjEyMzQ1Njc4OTAxMjM1Ljk5PC9Vbml0QW1vdW50PgoJCTwvVW5pdFByaWNlPgoJPC9UYXhJbnZvaWNlVHJhZGVMaW5lSXRlbT4KPC9UYXhJbnZvaWNlPg==';
    //retUrl
    _RET_PROC_URL = 'http://m.kcu.ac/jsp/user/crosscert/procurl.jsp?rtnParam=<%=session.getId()%>';
    //fido_info
    _FIDO_ID_IOS = "testUser_iOS";
    _FIDO_ID_ANDROID = "testUser_ANDROID";
    _FIDO_SERVICE_NAME= 'BLOG';

    function id(elem) {
        return document.getElementById(elem);
    };

    function mobileLicense() {
        if (true == _USUtil.OS.isAndroid()) {
            _APPKEY = _APPKEY_ANDROID;
        } else if (true == _USUtil.OS.isiOS()) {
            _APPKEY = _APPKEY_IOS_UNISIGN;
        }
    };
    // mobileLicense();

    function showResult(panel) {
        //  var parser = document.createElement('a');
        //  parser.href = location.href;

        //  document.getElementById(panel).innerHTML = "user agent : " + navigator.userAgent + "<br>";
        //  document.getElementById(panel).innerHTML += "url length : " + location.href.length + "<br>";

        //  document.getElementById(panel).innerHTML += "result : " + _USUtil.getQueryVariable('result') + "<br>";
        //  document.getElementById(panel).innerHTML += "result length : " + _USUtil.getQueryVariable('result').length + "<br>";

        //  if(_USUtil.OS.isAndroid()) {
        //      document.getElementById(panel).innerHTML += "retParam : " + _USUtil.getQueryVariable('retParam') + "<br>";
        //  } else if(_USUtil.OS.isiOS()) {
        //      document.getElementById(panel).innerHTML += "callback : " + _USUtil.getQueryVariable('callback') + "<br>";
        //  } else {}

        //  document.getElementById(panel).innerHTML += "sidCheck : " + _USUtil.getQueryVariable('sidCheck') + "<br>";
        //  document.getElementById(panel).innerHTML += "sidResult : " + _USUtil.getQueryVariable('sidResult') + "<br><br><br>";

        //      alert(_RET_SELF_URL);
    }

    function genCCFIDOProtocol(operation, flag) {
		
        var base64UrlCCFIDOProtocol = '';

        var CCFidoProtocol = new Object();
        CCFidoProtocol.op = operation;
        if (flag) {
            CCFidoProtocol.content = id('plainText').value;
        } else {
            CCFidoProtocol.content = "";
        }
        if (true == _USUtil.OS.isAndroid()) {
            CCFidoProtocol.id = _FIDO_ID_ANDROID;
        } else if (true == _USUtil.OS.isiOS()) {
            CCFidoProtocol.id = _FIDO_ID_IOS;
        }
        //CCFidoProtocol.id = _FIDO_ID; // 고객이 넣어주는 ID
        CCFidoProtocol.serviceName = _FIDO_SERVICE_NAME; // 고객이 넣어주는 서비스명
        CCFidoProtocol.serviceType = parseInt(getServiceTypeValue()); // FIDO/K_FIDO(선택)
        CCFidoProtocol.bioType = decimalToHexString(parseInt(getBioTypeValue())); // BIOTYPE(선택)
        //CCFidoProtocol.appKey = _APPKEY;
        
        base64UrlCCFIDOProtocol = 
            encodeUrl(_USUtil.Base64.encode(JSON.stringify(CCFidoProtocol)));
        
        return base64UrlCCFIDOProtocol;
    }
    
    function genCCPINPADProtocol(operation) {
        var base64UrlCCPINPADProtocol = '';

        var CCPinpadProtocol = new Object();
        CCPinpadProtocol.op = operation;
        //CCPinpadProtocol.appKey = _APPKEY;
        
        base64UrlCCPINPADProtocol = 
            encodeUrl(_USUtil.Base64.encode(JSON.stringify(CCPinpadProtocol)));
        
        return base64UrlCCPINPADProtocol;
    }

    function encodeUrl(str) {
        return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');
    }
    
    function getServiceTypeValue() {
        var rst = '';
        var obj = document.getElementsByName("serviceType");
        for (var i = 0; i < obj.length; i++) {
            if (obj[i].checked) {
                rst = obj[i].value;
            }
        }
        return rst;
    }
    
    function getBioTypeValue() {
        var rst = '';
        var obj = document.getElementsByName("bioType");
        for (var i = 0; i < obj.length; i++) {
            if (obj[i].checked) {
                rst = obj[i].value;
            }
        }
        return rst;
    }
    
    function decimalToHexString(number) {
        if (number < 0) {
            number = 0xFFFFFFFF + number + 1;
        }

        return number.toString(16).toUpperCase();
    }
    
    function authTokenValidate(authToken) {
        iFrame_authToken_validate.location.href = "https://fidotestserver.crosscert.com:8080/RPS/SA/Interface?authToken="+authToken;
    }
</script>
</html>