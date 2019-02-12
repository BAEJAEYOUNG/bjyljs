<jsp:directive.include file="/view/include/typedef.jsp" />
<%--
기능: 사용자관리 
--%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<html lang="ko">
<jsp:directive.page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" />
<jsp:directive.include file="/view/include/taglib.jsp" />
<jsp:directive.include file="/view/include/var.jsp" />
<head>
<title>${browserTitle}</title>
<jsp:directive.include file="/view/include/header.jsp" />
</head>

<body>

<!-- 여성국 새로작업 20140822-->
<div class="errorbox">
	<div class="errorbox_title">알림</div>
	<div class="error_txt">요청 처리 과정에서 예외가 발생했습니다.</div>
	<div class="error_btn_box">
	<a class="error_btn" onclick="history.back();">
			<span class="btn_back"> < </span>
			<span class="btn_back_txt">이전 페이지로</span>
		</a>
	</div>
</div>

</body>
</html>