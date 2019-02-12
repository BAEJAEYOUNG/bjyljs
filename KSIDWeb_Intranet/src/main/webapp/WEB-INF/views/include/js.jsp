<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:forEach items="${config.js}" var="js" varStatus="status">
    <script type="text/javascript" src="${config.jsPath}/${js}" charset="utf-8"></script>
</c:forEach>

<%--
<!-- jquery -->
<script type="text/javascript" src="${config.jsPath}/jquery.min.js?version=3.1.1.001" charset="utf-8"></script>

<!-- jquery plugins js file include -->
<c:set var="path">${config.jsPathReal}/plugins</c:set>
<c:set var="jsNames" value="${util:listFiles(pageContext.servletContext, path, fn:split('js', '|'), false)}"/>
<c:forEach items="${jsNames}" var="jsName" varStatus="status">
    <script type="text/javascript" src="${config.jsPath}/plugins/${jsName}?version=1.0.0.001" charset="utf-8"></script>
</c:forEach>

<!-- etc library js file include -->
<c:set var="path">${config.jsPathReal}/lib</c:set>
<c:set var="jsNames" value="${util:listFiles(pageContext.servletContext, path, fn:split('js', '|'), false)}"/>
<c:forEach items="${jsNames}" var="jsName" varStatus="status">
    <script type="text/javascript" src="${config.jsPath}/lib/${jsName}?version=1.0.0.001" charset="utf-8"></script>
</c:forEach>

<!-- ksid -->
<script type="text/javascript" src="${config.jsPath}/ksid.js" charset="utf-8"></script>

<!-- ksid js file include -->
<c:set var="path">${config.jsPathReal}/ksid</c:set>
<c:set var="jsNames" value="${util:listFiles(pageContext.servletContext, path, fn:split('js', '|'), false)}"/>
<c:forEach items="${jsNames}" var="jsName" varStatus="status">
    <script type="text/javascript" src="${config.jsPath}/ksid/${jsName}?version=1.0.0.001" charset="utf-8"></script>
</c:forEach>

<!-- ksid 공통팝업 관련 -->
<script type="text/javascript" src="${config.jsPath}/common.js" charset="utf-8"></script>   <!-- 프로젝트 공통 함수 -->
 --%>

