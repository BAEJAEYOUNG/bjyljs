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
<c:set var="funcId"	value="${utils:nvl(funcId,'ERROR')}" />
<c:set var="funcUrl"	value="${contextPath}/error/" />

<head>
<title>${browserTitle}</title>
<jsp:directive.include file="/view/include/header.jsp" />
<script src="${contextPath}/js/menu.js"></script>
<script src="${contextPath}/js/move.js"></script>
<script> var url = '${url}'; </script>
<script>
   	//window.location.href	=	"/";
   	if(opener != null){
   		//opener.location.href = "";
   		//self.close();
   	}else if(parent != null){
   	 //  	parent.location.href = "";
   	}else{
   	//   	window.location.href =	"";
   	}
   	
   	function goMain() {
   		// location.href='${contextPath}/';
   	}
</script>
</head>
<body>

<!-- 여성국 새로작업 20140822-->
<div class="errorbox">
	<div class="errorbox_title">알림</div>
	<div class="error_txt">리소스를 허용하지 않습니다.</div>
	<div class="error_btn_box">
		<a class="error_btn" onclick="history.back();">
			<span class="btn_back"> < </span>
			<span class="btn_back_txt">이전 페이지로</span>
		</a>
	</div>
</div>

</body>
</html>