<jsp:directive.include file="/view/include/typedef.jsp" />
<%--
기능: 프로그램관리 
--%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<html lang="ko">
<jsp:directive.page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" />
<jsp:directive.include file="/view/include/taglib.jsp" />
<jsp:directive.include file="/view/include/var.jsp" />


<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>${BROWSER_TITLE}</title>

</head>
<body>

<!-- 여성국 새로작업 20140822-->
<div class="errorbox">
	<div class="errorbox_title">알림</div>
	<div class="error_txt">비정상적인 접근을 시도하였습니다.</div>
	<div class="error_btn_box">
		<a class="error_btn" onclick="history.back();">
			<span class="btn_back"> < </span>
			<span class="btn_back_txt">이전 페이지로</span>
		</a>
	</div>
</div>

</body>
</html>