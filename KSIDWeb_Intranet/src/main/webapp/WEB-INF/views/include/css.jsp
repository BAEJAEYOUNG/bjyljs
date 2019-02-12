<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%--
<link rel="stylesheet" type="text/css" media="screen" href="${config.cssPath}/ksid.css" />
 --%>
<c:forEach items="${config.css}" var="css" varStatus="status">
    <link rel="stylesheet" type="text/css" media="screen" href="${config.cssPath}/${css}" />
</c:forEach>
