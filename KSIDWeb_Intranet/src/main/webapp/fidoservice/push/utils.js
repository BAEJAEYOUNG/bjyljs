var interval1=null,interval2=null,interval3=null,version=null,__FileList=[],__ListIndex=0,_REQ_CONNECT_RELAY_PC=1001,_RES_CONNECT_RELAY_PC=1002,_REQ_START_HANDSHAKE=1003,_WAIT_FINAL_SECRET_SHARE=1004,_REQ_SECRET_SHARE=1005,_RES_SECRET_SHARE=1006,_REQ_PC_FINISHED=1007,_RES_PC_FINISHED=1008,_REQ_FINAL_SECRET_SHARE=1009,_RES_FINAL_SECRET_SHARE=1010,_REQ_APPLICATION_SPDATA=1011,_RES_APPLICATION_SPDATA=1012,_REQ_APPLICATION_PCDATA=1013,_RES_APPLICATION_PCDATA=1014,_REQ_VERIFY_AUTHTOKEN=1015,_RES_VERIFY_AUTHTOKEN=
1016,_REQ_REG_CONNECT=1021,_RES_REG_CONNECT=1022,_REQ_REG_COMPLETE=1023,_RES_REG_COMPLETE=1024,_REQ_SECRET_SPDATA=1025,_RES_SECRET_SPDATA=1026,_REQ_MODIFY_CONNECT=1027,_RES_MODIFY_CONNECT=1028,_REQUIRED_PHONE_OS=100,_REQUIRED_USER_ID=101,_ERROR_FORGERY_VERIFY=102,_ERROR_SIGN_VERIFY=103,_STATUS_PROCESS_OK=200,_STATUS_ALREAY_REGISTERED=201,_STATUS_PROCESS_WAIT=300,_STATUS_PROCESS_FAIL=400,_STATUS_INVALID_CMD=401,_STATUS_INVALID_AUTHTOKEN=402,_STATUS_INVALID_HASH=403,_STATUS_INVALID_PARAM=404,_STATUS_ILLEGAL_REQUEST=
405,_STATUS_NO_SEND_PUSH_MSG=407,_STATUS_NO_PUSHTOKEN_REG=408,_STATUS_ERROR_AJAX_CONNECT=409,_STATUS_ERROR_FIDO_OPERATION=410,_FIDO_UNKNOWN_ERROR=500,_FIDO_LICENSE_ERROR=501,_FIDO_BAD_POROTOCAL=502,_FIDO_UNAVAILABLE_BIO_TYPE=503,_FIDO_FAILED_TO_CONNECT_FIDO_SERVER=504,_FIDO_UNREGISTERED_THE_PIN=505,_FIDO_ALREADY_REGISTED_USER=506,_FIDO_UNREGISTERD_USER=507,_FIDO_DONT_SUPPORTED_DEVICE=508,_FIDO_DONT_SUPPORTED_KFIDO=509,_FIDO_DONT_SUPPORTED_PUREFIDO=510,_FIDO_FAILED_TO_FIDO_TA_PIN_VERIFICATION=511,
_FIDO_FAILED_TO_FIDO_PIN_VERIFICATION=512,_FIDO_FAILED_TO_FIDO_FINGERPRINT_VERIFICATION=513,_FIDO_CAN_NOT_USE_TOUCHID=514,_FIDO_UNREGISTRED_FINGERPRINT_OR_TOUCHID=515,_FIDO_FAILED_TO_FIDO_REGISTRATION=516,_FIDO_FAILED_TO_FIDO_AUTHENTICATION=517,_FIDO_FAILED_TO_FIDO_DELETION=518,_FIDO_CANCELED_TO_FINGERPRINT_AUTHENTICATION=519,_FIDO_ENTERED_TO_FINGERPRINT_LOCKMODE=520,_FIDO_NO_HAVE_PERMISSION_FOR_APP=521,_FIDO_LICENSE_DONT_SUPPORTED_FACEPRINT=601,_RET_SELF_URL=window.location.href.split(/[?#]/)[0],
_SELF_DOMAIN_URL="bill.ksidmobile.co.kr/",_PRODUCT_TYPE="FIDO",_FIDO_SERVICE_TYPE=0,_FIDO_BIO_TYPE="2",_FIDO_SERVICE_NAME="OCU",_INTERGRITY_CHECK_NUM=0,console=console||{log:function(){},info:function(){},error:function(){},warn:function(){}};$().ready(function(){environmentInit();version={Major:"1",Minor:"0"}});
function reqRegConnect(e){if(""==getPhoneOSValue())return genResultValue(_REQUIRED_PHONE_OS),!1;if(""==e)return genResultValue(_REQUIRED_USER_ID),!1;e=e+"_"+_SELF_DOMAIN_URL+_FIDO_SERVICE_NAME;var a={};a.UserID=e;var d=[];d.push(a);var f={};f.Version=version;f.CMD=_REQ_REG_CONNECT;f.Hash=genBodyHash(JSON.parse(JSON.stringify(d)));a=[];a.push(f);f={};f.Header=a;f.Body=JSON.stringify(d);$.ajax({url:_RELAY_SERVER_URL,type:"POST",data:{REQUEST:JSON.stringify(f)},success:function(a){a=JSON.parse(a);if(null!=
a.Header[0].CMD){var d=JSON.parse(a.Body);if(a.Header[0].Hash==genBodyHash(d)){if(a.Header[0].CMD==_RES_REG_CONNECT)if(d[0].Status==_STATUS_PROCESS_OK)if(a=JSON.parse(d[0].Data).Random){genRandomValue(a);var f=+new Date;interval3=setInterval(function(){18E4>+new Date-f?reqRegComplete(e):clearInterval(interval3)},500)}else genResultValue(_STATUS_INVALID_PARAM);else d[0].Status==_STATUS_ALREAY_REGISTERED?genResultValue(_STATUS_ALREAY_REGISTERED):d[0].Status==_STATUS_PROCESS_FAIL&&genResultValue(_STATUS_PROCESS_FAIL)}else genResultValue(_STATUS_INVALID_HASH)}},
error:function(){genResultValue(_STATUS_ERROR_AJAX_CONNECT)}})}
function reqModifyConnect(e){if(""==getPhoneOSValue())return genResultValue(_REQUIRED_PHONE_OS),!1;if(""==e)return genResultValue(_REQUIRED_USER_ID),!1;e=e+"_"+_SELF_DOMAIN_URL+_FIDO_SERVICE_NAME;var a={};a.UserID=e;var d=[];d.push(a);var f={};f.Version=version;f.CMD=_REQ_MODIFY_CONNECT;f.Hash=genBodyHash(JSON.parse(JSON.stringify(d)));a=[];a.push(f);f={};f.Header=a;f.Body=JSON.stringify(d);$.ajax({url:_RELAY_SERVER_URL,type:"POST",data:{REQUEST:JSON.stringify(f)},success:function(a){a=JSON.parse(a);
if(null!=a.Header[0].CMD){var d=JSON.parse(a.Body);if(a.Header[0].Hash==genBodyHash(d)){if(a.Header[0].CMD==_RES_MODIFY_CONNECT)if(d[0].Status==_STATUS_PROCESS_OK)if(a=JSON.parse(d[0].Data).Random){genRandomValue(a);var f=+new Date;interval3=setInterval(function(){18E4>+new Date-f?reqRegComplete(e):clearInterval(interval3)},500)}else genResultValue(_STATUS_INVALID_PARAM);else d[0].Status==_STATUS_PROCESS_FAIL&&genResultValue(_STATUS_PROCESS_FAIL)}else genResultValue(_STATUS_INVALID_HASH)}},error:function(){genResultValue(_STATUS_ERROR_AJAX_CONNECT)}})}
function reqRegComplete(e){var a={};a.UserID=e;e=[];e.push(a);var d={};d.Version=version;d.CMD=_REQ_REG_COMPLETE;d.Hash=genBodyHash(JSON.parse(JSON.stringify(e)));a=[];a.push(d);d={};d.Header=a;d.Body=JSON.stringify(e);$.ajax({url:_RELAY_SERVER_URL,type:"POST",data:{REQUEST:JSON.stringify(d)},success:function(a){a=JSON.parse(a);if(null!=a.Header[0].CMD){var e=JSON.parse(a.Body);a.Header[0].Hash==genBodyHash(e)?a.Header[0].CMD==_RES_REG_COMPLETE&&(e[0].Status==_STATUS_PROCESS_OK?(genResultValue(_STATUS_PROCESS_OK),
clearInterval(interval3)):e[0].Status==_STATUS_PROCESS_FAIL&&(genResultValue(_STATUS_PROCESS_FAIL),clearInterval(interval3))):(genResultValue(_STATUS_INVALID_HASH),clearInterval(interval3))}},error:function(){genResultValue(_STATUS_ERROR_AJAX_CONNECT);clearInterval(interval3)}})}
function genFIDORequest(e,a){if(""==getPhoneOSValue())return genResultValue(_REQUIRED_PHONE_OS),!1;if(""==e)return genResultValue(_REQUIRED_USER_ID),!1;e=e+"_"+_SELF_DOMAIN_URL+_FIDO_SERVICE_NAME;var d={};d.UserID=e;var f=[];f.push(d);var g={};g.Version=version;g.CMD=_REQ_CONNECT_RELAY_PC;g.Hash=genBodyHash(JSON.parse(JSON.stringify(f)));d=[];d.push(g);g={};g.Header=d;g.Body=JSON.stringify(f);$.ajax({url:_RELAY_SERVER_URL,type:"POST",data:{REQUEST:JSON.stringify(g)},success:function(d){d=JSON.parse(d);
if(null!=d.Header[0].CMD){var f=JSON.parse(d.Body);if(d.Header[0].Hash==genBodyHash(f)){if(d.Header[0].CMD==_RES_CONNECT_RELAY_PC)if(f[0].Status==_STATUS_PROCESS_OK){var g=JSON.parse(f[0].Data).TID;if(g){var m=+new Date;interval1=setInterval(function(){18E4>+new Date-m?reqSecretShare(g,e,a):clearInterval(interval1)},500)}else genResultValue(_STATUS_INVALID_PARAM)}else f[0].Status==_STATUS_NO_SEND_PUSH_MSG?genResultValue(_STATUS_NO_SEND_PUSH_MSG):f[0].Status==_STATUS_PROCESS_FAIL?genResultValue(_STATUS_PROCESS_FAIL):
f[0].Status==_STATUS_NO_PUSHTOKEN_REG&&genResultValue(_STATUS_NO_PUSHTOKEN_REG)}else genResultValue(_STATUS_INVALID_HASH)}},error:function(){genResultValue(_STATUS_ERROR_AJAX_CONNECT)}})}
function reqSecretShare(e,a,d){var f={};f.TID=e;var g=[];g.push(f);var h={};h.Version=version;h.CMD=_REQ_SECRET_SHARE;h.Hash=genBodyHash(JSON.parse(JSON.stringify(g)));f=[];f.push(h);h={};h.Header=f;h.Body=JSON.stringify(g);$.ajax({url:_RELAY_SERVER_URL,type:"POST",data:{REQUEST:JSON.stringify(h)},success:function(f){f=JSON.parse(f);if(null!=f.Header[0].CMD){var h=JSON.parse(f.Body);f.Header[0].Hash==genBodyHash(h)?f.Header[0].CMD==_RES_SECRET_SHARE&&(h[0].Status==_STATUS_PROCESS_OK?(clearInterval(interval1),
h=JSON.parse(h[0].Data),f=h.PublicKey,h=h.R1,f&&h?reqPCFinished(f,h,e,a,d):genResultValue(_STATUS_INVALID_PARAM)):h[0].Status==_STATUS_PROCESS_FAIL&&(genResultValue(_STATUS_PROCESS_FAIL),clearInterval(interval1))):(genResultValue(_STATUS_INVALID_HASH),clearInterval(interval1))}},error:function(){genResultValue(_STATUS_ERROR_AJAX_CONNECT);clearInterval(interval1)}})}
function reqPCFinished(e,a,d,f,g){var h=crosscert.random.getBytes(20);e=genAsymmeticEncryptData(e,h);f=genCCFIDOCommand(f,g);g=crosscert.util.createBuffer();g.putBytes(f);var k=genSymmetricEncryptData(a,h,g);f={};f.R2=e;f.CipherText=k;f.TID=d;e=[];e.push(f);g={};g.Version=version;g.CMD=_REQ_PC_FINISHED;g.Hash=genBodyHash(JSON.parse(JSON.stringify(e)));f=[];f.push(g);g={};g.Header=f;g.Body=JSON.stringify(e);$.ajax({url:_RELAY_SERVER_URL,type:"POST",data:{REQUEST:JSON.stringify(g)},success:function(e){e=
JSON.parse(e);if(null!=e.Header[0].CMD){var f=JSON.parse(e.Body);if(e.Header[0].Hash==genBodyHash(f)){if(e.Header[0].CMD==_RES_PC_FINISHED)if(f[0].Status==_STATUS_PROCESS_OK)if(a&&h&&k&&d){var g=+new Date;interval2=setInterval(function(){18E4>+new Date-g?reqApplicationPCData(a,h,k,d):clearInterval(interval2)},500)}else genResultValue(_STATUS_INVALID_PARAM);else f[0].Status==_STATUS_PROCESS_FAIL&&genResultValue(_STATUS_PROCESS_FAIL)}else genResultValue(_STATUS_INVALID_HASH)}},error:function(){genResultValue(_STATUS_ERROR_AJAX_CONNECT)}})}
function reqApplicationPCData(e,a,d,f){d={};d.TID=f;f=[];f.push(d);var g={};g.Version=version;g.CMD=_REQ_APPLICATION_PCDATA;g.Hash=genBodyHash(JSON.parse(JSON.stringify(f)));d=[];d.push(g);g={};g.Header=d;g.Body=JSON.stringify(f);$.ajax({url:_RELAY_SERVER_URL,type:"POST",data:{REQUEST:JSON.stringify(g)},success:function(d){d=JSON.parse(d);if(null!=d.Header[0].CMD){var f=JSON.parse(d.Body);d.Header[0].Hash==genBodyHash(f)?d.Header[0].CMD==_RES_APPLICATION_PCDATA&&(f[0].Status==_STATUS_PROCESS_OK?(clearInterval(interval2),
f=JSON.parse(f[0].Data),d=f.AuthToken,f=f.CipherSText,e&&a&&f&&d?(d=genSymmetricDecryptData(e,a,f),verifyDecryptText(d)&&(d=printDecryptText(d),d=JSON.parse(d),d=crosscert.util.decode64(d.ErrCode),d=JSON.stringify(d),d=d.replace(/\u0000/g,""),d=d.replace(/\\u0000/g,""),d=JSON.parse(d),d=JSON.parse(d),"0"==d.errCode?(genResultValue(_STATUS_PROCESS_OK),genFIDOAuthToken(d.authToken)):"-1000"==d.errCode?genResultValue(_FIDO_UNKNOWN_ERROR):"-1001"==d.errCode?genResultValue(_FIDO_LICENSE_ERROR):"-1002"==
d.errCode?genResultValue(_FIDO_BAD_POROTOCAL):"-1003"==d.errCode?genResultValue(_FIDO_UNAVAILABLE_BIO_TYPE):"-1004"==d.errCode?genResultValue(_FIDO_FAILED_TO_CONNECT_FIDO_SERVER):"-1005"==d.errCode?genResultValue(_FIDO_UNREGISTERED_THE_PIN):"-1006"==d.errCode?genResultValue(_FIDO_ALREADY_REGISTED_USER):"-1007"==d.errCode?genResultValue(_FIDO_UNREGISTERD_USER):"-1008"==d.errCode?genResultValue(_FIDO_DONT_SUPPORTED_DEVICE):"-1009"==d.errCode?genResultValue(_FIDO_DONT_SUPPORTED_KFIDO):"-1010"==d.errCode?
genResultValue(_FIDO_DONT_SUPPORTED_PUREFIDO):"-1011"==d.errCode?genResultValue(_FIDO_FAILED_TO_FIDO_TA_PIN_VERIFICATION):"-1012"==d.errCode?genResultValue(_FIDO_FAILED_TO_FIDO_PIN_VERIFICATION):"-1013"==d.errCode?genResultValue(_FIDO_FAILED_TO_FIDO_FINGERPRINT_VERIFICATION):"-1014"==d.errCode?genResultValue(_FIDO_CAN_NOT_USE_TOUCHID):"-1015"==d.errCode?genResultValue(_FIDO_UNREGISTRED_FINGERPRINT_OR_TOUCHID):"-1016"==d.errCode?genResultValue(_FIDO_FAILED_TO_FIDO_REGISTRATION):"-1017"==d.errCode?
genResultValue(_FIDO_FAILED_TO_FIDO_AUTHENTICATION):"-1018"==d.errCode?genResultValue(_FIDO_FAILED_TO_FIDO_DELETION):"-1019"==d.errCode?genResultValue(_FIDO_CANCELED_TO_FINGERPRINT_AUTHENTICATION):"-1020"==d.errCode?genResultValue(_FIDO_ENTERED_TO_FINGERPRINT_LOCKMODE):"-1021"==d.errCode?genResultValue(_FIDO_NO_HAVE_PERMISSION_FOR_APP):"-1101"==d.errCode?genResultValue(_FIDO_LICENSE_DONT_SUPPORTED_FACEPRINT):genResultValue(_STATUS_ERROR_FIDO_OPERATION))):genResultValue(_STATUS_INVALID_PARAM)):f[0].Status==
_STATUS_PROCESS_FAIL&&(genResultValue(_STATUS_PROCESS_FAIL),clearInterval(interval2))):(genResultValue(_STATUS_INVALID_HASH),clearInterval(interval2))}},error:function(){genResultValue(_STATUS_ERROR_AJAX_CONNECT);clearInterval(interval2)}})}
function reqVerifyAuthToken(e,a){var d={};d.AuthToken=e;d.TID=a;var f=[];f.push(d);var g={};g.Version=version;g.CMD=_REQ_VERIFY_AUTHTOKEN;g.Hash=genBodyHash(JSON.parse(JSON.stringify(f)));d=[];d.push(g);g={};g.Header=d;g.Body=JSON.stringify(f);$.ajax({url:_RELAY_SERVER_URL,type:"POST",data:{REQUEST:JSON.stringify(g)},success:function(a){a=JSON.parse(a);if(null!=a.Header[0].CMD){var d=JSON.parse(a.Body);a.Header[0].Hash==genBodyHash(d)?a.Header[0].CMD==_RES_VERIFY_AUTHTOKEN&&(d[0].Status==_STATUS_PROCESS_OK?
genResultValue(_STATUS_PROCESS_OK):d[0].Status==_STATUS_INVALID_AUTHTOKEN&&genResultValue(_STATUS_INVALID_AUTHTOKEN)):genResultValue(_STATUS_INVALID_HASH)}},error:function(){genResultValue(_STATUS_ERROR_AJAX_CONNECT)}})}
function genCCFIDOCommand(e,a){var d={};d.op=a;d.serviceName=_FIDO_SERVICE_NAME;d.serviceType=_FIDO_SERVICE_TYPE;d.bioType=decimalToHexString(parseInt(_FIDO_BIO_TYPE));d.id=e;d.fidoServerUrl=_FIDO_SERVER_URL;var f={};f.product_type=_PRODUCT_TYPE;f.ccfidoprotocol=d;f.caller_url_scheme=_RET_SELF_URL;-1<getPhoneOSValue().indexOf("iOS")&&(f.appKey=_APPKEY_IOS);-1<getPhoneOSValue().indexOf("ANDROID")&&(f.appKey=_APPKEY_ANDROID);d="";return d=encodeUrl(crosscert.util.encode64(JSON.stringify(f)))}
function getPhoneOSValue(){for(var e="",a=document.getElementsByName("phoneOS"),d=0;d<a.length;d++)a[d].checked&&(e=a[d].value);return e}function getOperationType(){for(var e="",a=document.getElementsByName("operationType"),d=0;d<a.length;d++)a[d].checked&&(e=a[d].value);return e}function getBioTypeValue(){for(var e="",a=document.getElementsByName("bioType"),d=0;d<a.length;d++)a[d].checked&&(e=a[d].value);return e}
function genAsymmeticEncryptData(e,a){var d="";try{var f=decodeUrl(e),g=crosscert.pki.publicKeyFromBase64(f).encrypt(a),d=crosscert.util.encode64(g),h=encodeUrl(d)}catch(k){alert(k.message+"[errcode : "+k.code+"]")}return h}
function genSymmetricEncryptData(e,a,d){var f="";e=decodeUrl(e);f=crosscert.util.decode64(e);e="";try{var g=crosscert.md.algorithms.sha256.create();g.start();g.update(f);var h=g.digest().toHex(),k=crosscert.util.hexToBytes(h).concat(a),l=crosscert.md.algorithms.sha256.create();l.start();l.update(k);var m=l.digest().toHex();e=toHexArray(m)}catch(n){alert(n.message+"[errcode : "+n.code+"]")}a=Array(16);for(g=0;16>g;g++)a[g]=e[g];a=toHexString(a);g=Array(16);for(h=0;16>h;h++)g[h]=e[h+16];e=toHexString(g);
a=crosscert.util.hexToBytes(a);e=crosscert.util.hexToBytes(e);e=crosscert.cipher.algorithms.aes.startEncrypting(a,e);e.update(crosscert.util.createBuffer(d));e.finish();f=crosscert.util.encode64(e.output.getBytes());return encodeUrl(f)}
function genSymmetricDecryptData(e,a,d){var f="";e=decodeUrl(e);f=crosscert.util.decode64(e);d=decodeUrl(d);d=crosscert.util.decode64(d);e="";try{var g=crosscert.md.algorithms.sha256.create();g.start();g.update(f);var h=g.digest().toHex(),k=crosscert.util.hexToBytes(h).concat(a),l=crosscert.md.algorithms.sha256.create();l.start();l.update(k);var m=l.digest().toHex();e=toHexArray(m)}catch(n){alert(n.message+"[errcode : "+n.code+"]")}a=Array(16);for(g=0;16>g;g++)a[g]=e[g];a=toHexString(a);g=Array(16);
for(h=0;16>h;h++)g[h]=e[h+16];e=toHexString(g);a=crosscert.util.hexToBytes(a);e=crosscert.util.hexToBytes(e);a=crosscert.cipher.algorithms.aes.startDecrypting(a,e);a.update(crosscert.util.createBuffer(d));a.finish();return f=a.output.getBytes()}function genBodyHash(e){e=JSON.stringify(e);var a=crosscert.md.algorithms.sha256.create();a.start();a.update(e);e=crosscert.util.encode64(crosscert.util.hexToBytes(a.digest().toHex()));return e=encodeUrl(e)}
function verifyDecryptText(e){var a=!1,d=e.substr(0,32);e=e.substr(32,e.length-32);var f=crosscert.md.algorithms.sha256.create();f.start();f.update(e);e=crosscert.util.hexToBytes(f.digest().toHex());d===e&&(a=!0);return a}function printDecryptText(e){return e.substr(32,e.length-32)}function toHexArray(e){for(var a=[],d=0;d<e.length;d+=2)a.push("0x"+e.substr(d,2));return a}
function toHexString(e){var a="";for(i in e)var d=e[i].toString(16),d=0==d.length?"00":1==d.length?"0"+d:2==d.length?d:d.substring(d.length-2,d.length),a=a+d;return a}function encodeUrl(e){return e.replace(/\+/g,"-").replace(/\//g,"_").replace(/\=+$/,"")}function decodeUrl(e){e=(e+"=").slice(0,e.length+e.length%4);return e.replace(/-/g,"+").replace(/_/g,"/")}function cutByLen(e,a){for(b=i=0;c=e.charCodeAt(i);){b+=c>>7?2:1;if(b>a)break;i++}return e.substring(0,i)}
function decimalToHexString(e){0>e&&(e=4294967295+e+1);return e.toString(16).toUpperCase()}
function environmentInit(){var e=null,a=null,d=0,f=null,g=navigator.platform,h=navigator.userAgent,e=0<=g.indexOf("Win")?"win":0<=g.indexOf("Mac")?"mac":0<=g.indexOf("Linux")?"linux":0<=g.indexOf("iPhone")||0<=g.indexOf("iPad")||0<=g.indexOf("iPod")?"ios":"unknown";0<=h.indexOf("Android")&&(e="android");"android"===e?0<=h.indexOf("SAMSUNG")?(a="android samsung",f=/Version\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("OPR")?(a="android opera",f=/OPR\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Opera")?(a="android opera classic",
f=/Version\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Firefox")?(a="android firefox",f=/Firefox\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("NAVER")?a="android naver":0<=h.indexOf("DaumApps")?(a="android daum",f=/DaumApps\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("nate_app")?a="android nate":0<=h.indexOf("UCBrowser")?(a="android uc",f=/UCBrowser\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Chrome")?0<=h.indexOf("Version")?(a=0<=h.indexOf("LG")?"android lg":"android browser",f=/Version\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("LG")?
((f=/Chrome\/([0-9]{1,}[.0-9]{0,})/)&&f.exec(h)&&(d=parseFloat(RegExp.$1)),a=39>d?"android lg":"android chrome"):(a="android chrome",f=/Chrome\/([0-9]{1,}[.0-9]{0,})/):(a="unknown",d=0):"ios"===e?0<=h.indexOf("CriOS")?(a="ios chrome",f=/CriOS\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("NAVER")?a="ios naver":0<=h.indexOf("DaumApps")?(a="ios daum",f=/DaumApps\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Coast")?(a="ios opera coast",f=/Coast\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Safari")?(a="ios safari",f=/Version\/([0-9]{1,}[.0-9]{0,})/):
(a="unknown",d=0):0<=h.indexOf("MSIE")?(a="msie","BackCompat"==document.compatMode?d=5:document.documentMode?d=document.documentMode:f=/MSIE ([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Chrome")?(a="chrome",f=/Chrome\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Firefox")?(a="firefox",f=/Firefox\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Safari")?(a="safari",f=/Version\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("Opera")?(a="opera",f=/Version\/([0-9]{1,}[.0-9]{0,})/):0<=h.indexOf("rv:11.")?(a="msie",f=/rv:([0-9]{1,}[.0-9]{0,})/):
(a="unknown",d=0);f&&f.exec(h)&&(d=parseFloat(RegExp.$1));console.info("UI platform : ",g,"\nuseragent : ",h,"\nOS name : ",e,"\nbrowser name : ",a,"\nbrowser version : ",d)}
function intergrityChk(){var e=callExternalScript({eval:!1,intergrity:!1,name:"push",url:"crosscert/integrity/push.js"}),a=null;try{a=crosscert.pkcs7.messageFromBase64(e),a.verify()}catch(d){console.info("ErrCode : ",d.code);return}console.info("verify result :",a.verifyResult);if(!0==a.verifyResult){for(var e=[],e=genpkcs7List(a.content),a=[{eval:!0,intergrity:!0,name:"util",url:"crosscert/jsustoolkit/toolkit/util.js"},{eval:!0,intergrity:!0,name:"jsbn",url:"crosscert/jsustoolkit/toolkit/jsbn.js"},
{eval:!0,intergrity:!0,name:"aes",url:"crosscert/jsustoolkit/crypto/aes.js"},{eval:!0,intergrity:!0,name:"des",url:"crosscert/jsustoolkit/crypto/des.js"},{eval:!0,intergrity:!0,name:"desofb",url:"crosscert/jsustoolkit/crypto/desofb.js"},{eval:!0,intergrity:!0,name:"seed",url:"crosscert/jsustoolkit/crypto/seed.js"},{eval:!0,intergrity:!0,name:"sha1",url:"crosscert/jsustoolkit/crypto/sha1.js"},{eval:!0,intergrity:!0,name:"md5",url:"crosscert/jsustoolkit/crypto/md5.js"},{eval:!0,intergrity:!0,name:"sha256",
url:"crosscert/jsustoolkit/crypto/sha256.js"},{eval:!0,intergrity:!0,name:"prng",url:"crosscert/jsustoolkit/crypto/prng.js"},{eval:!0,intergrity:!0,name:"hmac",url:"crosscert/jsustoolkit/crypto/hmac.js"},{eval:!0,intergrity:!0,name:"random",url:"crosscert/jsustoolkit/crypto/random.js"},{eval:!0,intergrity:!0,name:"oids",url:"crosscert/jsustoolkit/toolkit/oids.js"},{eval:!0,intergrity:!0,name:"asn1",url:"crosscert/jsustoolkit/toolkit/asn1.js"},{eval:!0,intergrity:!0,name:"rsa",url:"crosscert/jsustoolkit/crypto/rsa.js"},
{eval:!0,intergrity:!0,name:"pki",url:"crosscert/jsustoolkit/toolkit/pki.js"},{eval:!0,intergrity:!0,name:"pkcs5",url:"crosscert/jsustoolkit/toolkit/pkcs5.js"},{eval:!0,intergrity:!0,name:"pkcs8",url:"crosscert/jsustoolkit/toolkit/pkcs8.js"},{eval:!0,intergrity:!0,name:"pkcs7asn1",url:"crosscert/jsustoolkit/toolkit/pkcs7asn1.js"},{eval:!0,intergrity:!0,name:"pkcs7",url:"crosscert/jsustoolkit/toolkit/pkcs7.js"},{eval:!0,intergrity:!0,name:"CCFidoUtils",url:"crosscert/push/CCFidoUtils.js"}],f=0;f<a.length;f++)callExternalScript(a[f]);
for(a=0;a<__FileList.length;a++){var f=__FileList[a].name,g=__FileList[a].data,h=crosscert.md.algorithms.sha256.create();h.start();h.update(g);for(g=0;g<e.length;g++)if(e[g].name==f&&e[g].data!=h.digest().toHex())return console.info("*** Suspicion Forgery ***"),console.info("intergrity file name : ",e[g].name),console.info("intergrity file md data : ",e[g].data),console.info("downloaded file name : ",f),console.info("downloaded file md data : ",h.digest().toHex()),console.info("Is this Browser supporting plugin free cert backup? : ",
e[g].data==h.digest().toHex()),genResultValue(_ERROR_FORGERY_VERIFY),-1}}else return genResultValue(_ERROR_SIGN_VERIFY),-1}function callExternalScript(e){var a=null,a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",e.url,!1);a.send(null);if(200==a.status){if(!0===e.intergrity){var d={};d.name=e.name+".js";d.data=a.responseText;__FileList[__ListIndex++]=d}if(!1==e.eval&&!1==e.intergrity)return a.responseText}}
function genpkcs7List(e){var a=[];e=e.data.split(/\r\n|\r|\n/g);for(var d=0;d<e.length;d++){var f=e[d].split("|"),g={};g.name=f[0];g.data=f[1];a[d]=g}return a}
var _USMessage={NoticeDownload:"\uc571\uc774 \uc124\uce58\ub418\uc5b4 \uc788\uc9c0 \uc54a\uc744 \uacbd\uc6b0\n\uc124\uce58\ud398\uc774\uc9c0\ub85c \uc774\ub3d9\ud569\ub2c8\ub2e4.",ConfirmDownload:"\uc571 \uc124\uce58 \ud6c4 \uc774\uc6a9 \uac00\ub2a5\ud569\ub2c8\ub2e4.\n\uc124\uce58 \ud398\uc774\uc9c0\ub85c \uc774\ub3d9\ud558\uc2dc\uaca0\uc2b5\ub2c8\uae4c?",NoticeUnsupportedOS:"\uc9c0\uc6d0\ud558\uc9c0 \uc54a\ub294 \uc6b4\uc601\uccb4\uc81c\uc785\ub2c8\ub2e4."},UniSignW2A={Scheme:{iOS:"unisign-app",
Android:"crosscert"},Package:{Android:"com.crosscert.android"},DownloadURL:{iOS:"https://itunes.apple.com/kr/app/gong-in-injeungsenteo/id426081742?mt=8",Android:"market://details?id=com.crosscert.android"},AutoCheckInstallation:!0,UseTopLocation:!1,checkCrossCert:function(e){if(_USUtil.OS.isAndroid())alert(_USMessage.NoticeDownload),top.location.href=_USUtil.makeIntent(this.Scheme.Android,"init","isInit","true");else if(_USUtil.OS.isiOS()){if(!1!=this.AutoCheckInstallation||null==e||0==e.length){if(null==
e||0==e.length)e=this.Scheme.iOS+"://?cmd=Main&caller_url_scheme="+location.href+"&callback=01";var a=+new Date;setTimeout(function(){1600>+new Date-a&&UniSignW2A.moveToStore()},1500)}top.location.href=e}else alert(_USMessage.NoticeUnsupportedOS)},getLicenseInfo:function(e){_USUtil.OS.isAndroid()?(e=_USUtil.makeIntent(this.Scheme.Android,"licenseinfo","requestCode","2","retURL",e),top.location.href=e):_USUtil.OS.isiOS()?(e=_USUtil.makeCustomScheme(this.Scheme.iOS,"LicenseInfo","caller_url_scheme",
e,"callback","01"),this.checkCrossCert(e)):alert(_USMessage.NoticeUnsupportedOS)}},_USUtil={OS:{UserAgent:{Android_Phone:"Android",Android_Pad:"Android",iPhone:"iPhone",iPad:"iPad"},isAndroid:function(){return-1<navigator.userAgent.indexOf(this.UserAgent.Android_Phone)?!0:!1},isiOS:function(){return-1<navigator.userAgent.indexOf(this.UserAgent.iPhone)||-1<navigator.userAgent.indexOf(this.UserAgent.iPad)?!0:!1},isSupported:function(){return this.isAndroid()||this.isiOS()?!0:!1}},makeIntent:function(){if(!1!==
this.OS.isAndroid()&&!(4>arguments.length)){for(var e="intent://"+arguments[1],a="",d=1;2*d<arguments.length;d++)a=0>=a.length?a+("?"+arguments[2*d]+"="+arguments[2*d+1]):a+("&"+arguments[2*d]+"="+arguments[2*d+1]);d="";if(UniSignW2A.Scheme.Android===arguments[0])d="#Intent;package="+UniSignW2A.Package.Android+";",d+="action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;",d+="component=com.crosscert.android/com.crosscert.android.license.LicenseInfo;",d=d+"scheme="+UniSignW2A.Scheme.Android+
";",d+="end;";else if(VeriSign.Scheme.Android===arguments[0])d="#Intent;scheme="+VeriSign.Scheme.Android+";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="+VeriSign.Package.Android+";end";else return;return e+a+d}},makeFIDOIntent:function(){if(!1!==this.OS.isAndroid()&&!(4>arguments.length)){for(var e="",a=1;2*a<arguments.length;a++)e=0>=e.length?e+("?product_type="+arguments[1]+"&"+arguments[2*a]+"="+arguments[2*a+1]):e+("&"+arguments[2*a]+"="+arguments[2*a+
1]);a="";if(UniSignW2A.Scheme.Android===arguments[0])a="#Intent;package="+UniSignW2A.Package.Android+";",a+="action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;",a+="component=com.crosscert.android/com.crosscert.android.esign.ESign1CertList;",a=a+"scheme="+UniSignW2A.Scheme.Android+";",a+="end;";else if(VeriSign.Scheme.Android===arguments[0])a="#Intent;scheme="+VeriSign.Scheme.Android+";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="+
VeriSign.Package.Android+";end";else return;return"intent://FIDO"+e+a}},makePINPADIntent:function(){if(!1!==this.OS.isAndroid()&&!(4>arguments.length)){for(var e="",a=1;2*a<arguments.length;a++)e=0>=e.length?e+("?product_type="+arguments[1]+"&"+arguments[2*a]+"="+arguments[2*a+1]):e+("&"+arguments[2*a]+"="+arguments[2*a+1]);a="";if(UniSignW2A.Scheme.Android===arguments[0])a="#Intent;package="+UniSignW2A.Package.Android+";",a+="action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;",
a+="component=com.crosscert.android/com.crosscert.android.esign.ESign1CertList;",a=a+"scheme="+UniSignW2A.Scheme.Android+";",a+="end;";else if(VeriSign.Scheme.Android===arguments[0])a="#Intent;scheme="+VeriSign.Scheme.Android+";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="+VeriSign.Package.Android+";end";else return;return"intent://FIDO"+e+a}},makeCustomScheme:function(){if(!1!==_USUtil.OS.isiOS()&&!(4>arguments.length)){for(var e=arguments[0]+"://?cmd="+arguments[1],
a="",d=1;2*d<arguments.length;d++)a+="&"+arguments[2*d]+"="+arguments[2*d+1];return e+a+""}},makeFIDOScheme:function(){for(var e=arguments[0]+"://?product_type="+arguments[1],a="",d=1;2*d<arguments.length;d++)a+="&"+arguments[2*d]+"="+arguments[2*d+1];return e+a+""},makePINPADScheme:function(){if(!1!==_USUtil.OS.isiOS()&&!(4>arguments.length)){for(var e=arguments[0]+"://?product_type="+arguments[1],a="",d=1;2*d<arguments.length;d++)a+="&"+arguments[2*d]+"="+arguments[2*d+1];return e+a+""}},getQueryVariable:function(e){for(var a=
window.location.search.substring(1).split("&"),d=0;d<a.length;d++)if(0<a[d].indexOf("=")&&e==a[d].substring(0,a[d].indexOf("=")))return a[d].substring(a[d].indexOf("=")+1,a[d].length);return null},encodeUrl:function(e){return e.replace(/\+/g,"-").replace(/\//g,"_").replace(/\=+$/,"")},Base64:{_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var a="",d,f,g,h,k,l,m=0;for(e=this._utf8_encode(e);m<e.length;)d=e.charCodeAt(m++),f=e.charCodeAt(m++),g=e.charCodeAt(m++),
h=d>>2,d=(d&3)<<4|f>>4,k=(f&15)<<2|g>>6,l=g&63,isNaN(f)?k=l=64:isNaN(g)&&(l=64),a=a+this._keyStr.charAt(h)+this._keyStr.charAt(d)+this._keyStr.charAt(k)+this._keyStr.charAt(l);return a},decode:function(e){var a="",d,f,g,h,k,l=0;for(e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");l<e.length;)d=this._keyStr.indexOf(e.charAt(l++)),f=this._keyStr.indexOf(e.charAt(l++)),h=this._keyStr.indexOf(e.charAt(l++)),k=this._keyStr.indexOf(e.charAt(l++)),d=d<<2|f>>4,f=(f&15)<<4|h>>2,g=(h&3)<<6|k,a+=String.fromCharCode(d),
64!=h&&(a+=String.fromCharCode(f)),64!=k&&(a+=String.fromCharCode(g));return a=this._utf8_decode(a)},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");for(var a="",d=0;d<e.length;d++){var f=e.charCodeAt(d);128>f?a+=String.fromCharCode(f):(127<f&&2048>f?a+=String.fromCharCode(f>>6|192):(a+=String.fromCharCode(f>>12|224),a+=String.fromCharCode(f>>6&63|128)),a+=String.fromCharCode(f&63|128))}return a},_utf8_decode:function(e){for(var a="",d=0,f=c1=c2=0;d<e.length;)f=e.charCodeAt(d),128>f?(a+=String.fromCharCode(f),
d++):191<f&&224>f?(c2=e.charCodeAt(d+1),a+=String.fromCharCode((f&31)<<6|c2&63),d+=2):(c2=e.charCodeAt(d+1),c3=e.charCodeAt(d+2),a+=String.fromCharCode((f&15)<<12|(c2&63)<<6|c3&63),d+=3);return a}}};
