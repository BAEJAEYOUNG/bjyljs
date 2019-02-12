<jsp:directive.include file="/view/include/typedef.jsp" />
<%--
기능: 에러시 포워딩 되서 에러메시지를 보여주는 페이지 
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

/**
 * 이전 페이지로 이동
 */
function goBack(){
	history.go(-1);
}   	
   	
</script>
</head>
<body>
	
	<style type="text/css">
	#errWrap {
		width:370px; margin:200px auto; position:relative; 
	}
	#title_msg {
		font-size:18px
	}
	#contents_msg {
		font-size:13px; font-weight:normal
	}
	</style>
	
	
	<div id="errWrap" class="popup_box info_popup_350">
		<div class="popuptitle_box">
	    	<ul>
	        	<li class="popup_title_text">
	            	<span id="title_msg">Error</span>
	            </li>
	        </ul>
	    </div>
	    <div class="contents_box_time_02">
	    	<ul>
	        	<li class="pop_text_area">
	            	<span id="contents_msg" class="pop_text_area">${error_message}</span>
	            </li>
	        </ul>
	    </div>
	    <div id="infoBtnWrap" class="popup_btn_box_02">
	    	<ul>
	        	<li id="btnGoBack" class="btn_avo"><a onclick="goBack()">이전 페이지로</a></li>
	        </ul>
	     </div>
	</div>
	
	
</body>
</html>