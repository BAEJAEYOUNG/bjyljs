<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%-- <script type="text/javascript" src="${config.crosscertPath}/crosscert/jquery/jquery.min-3.1.0.js"></script> --%>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/util.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/jsbn.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/aes.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/des.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/desofb.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/seed.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/sha1.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/md5.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/sha256.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/prng.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/hmac.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/random.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/oids.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/asn1.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/crypto/rsa.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/pki.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/pkcs5.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/pkcs8.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/pkcs7asn1.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/jsustoolkit/toolkit/pkcs7.js"></script>
<script type="text/javascript" src="${config.crosscertPath}/crosscert/push/CCFidoUtils.js?v=3"></script>