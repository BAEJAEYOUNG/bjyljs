/**
 * @author jckim
 * @version 1.0.0
 * @since 2017.05.11
 * @description util(functions)
 */
var interval1 = null;
var interval2 = null;
var interval3 = null;
var version = null;
var __FileList = new Array();
var __ListIndex = 0;

/* message relay cmd const */
var _REQ_CONNECT_RELAY_PC = 1001;
var _RES_CONNECT_RELAY_PC = 1002;
var _REQ_START_HANDSHAKE = 1003;
var _WAIT_FINAL_SECRET_SHARE = 1004;
var _REQ_SECRET_SHARE = 1005;
var _RES_SECRET_SHARE = 1006;
var _REQ_PC_FINISHED = 1007;
var _RES_PC_FINISHED = 1008;
var _REQ_FINAL_SECRET_SHARE = 1009;
var _RES_FINAL_SECRET_SHARE = 1010;
var _REQ_APPLICATION_SPDATA = 1011;
var _RES_APPLICATION_SPDATA = 1012;
var _REQ_APPLICATION_PCDATA = 1013;
var _RES_APPLICATION_PCDATA = 1014;
var _REQ_VERIFY_AUTHTOKEN = 1015;
var _RES_VERIFY_AUTHTOKEN = 1016;
var _REQ_REG_CONNECT = 1021;
var _RES_REG_CONNECT = 1022;
var _REQ_REG_COMPLETE = 1023;
var _RES_REG_COMPLETE = 1024;
var _REQ_SECRET_SPDATA = 1025;
var _RES_SECRET_SPDATA = 1026;
var _REQ_MODIFY_CONNECT = 1027;
var _RES_MODIFY_CONNECT = 1028;

/* javascript alert const */
var _REQUIRED_PHONE_OS = 100;
var _REQUIRED_USER_ID = 101;
var _ERROR_FORGERY_VERIFY = 102;
var _ERROR_SIGN_VERIFY = 103;

/* message relay status const */
var _STATUS_PROCESS_OK = 200;
var _STATUS_ALREAY_REGISTERED = 201;
var _STATUS_PROCESS_WAIT = 300;
var _STATUS_PROCESS_FAIL = 400;
var _STATUS_INVALID_CMD = 401;
var _STATUS_INVALID_AUTHTOKEN = 402;
var _STATUS_INVALID_HASH = 403;
var _STATUS_INVALID_PARAM = 404;
var _STATUS_ILLEGAL_REQUEST = 405;
var _STATUS_NO_SEND_PUSH_MSG = 407;
var _STATUS_NO_PUSHTOKEN_REG = 408;
// javascript error only
var _STATUS_ERROR_AJAX_CONNECT = 409;
var _STATUS_ERROR_FIDO_OPERATION = 410;

var _FIDO_UNKNOWN_ERROR = 500;
var _FIDO_LICENSE_ERROR = 501;
var _FIDO_BAD_POROTOCAL = 502;
var _FIDO_UNAVAILABLE_BIO_TYPE = 503;
var _FIDO_FAILED_TO_CONNECT_FIDO_SERVER = 504;
var _FIDO_UNREGISTERED_THE_PIN = 505;
var _FIDO_ALREADY_REGISTED_USER = 506;
var _FIDO_UNREGISTERD_USER = 507;
var _FIDO_DONT_SUPPORTED_DEVICE = 508;
var _FIDO_DONT_SUPPORTED_KFIDO = 509;
var _FIDO_DONT_SUPPORTED_PUREFIDO = 510;
var _FIDO_FAILED_TO_FIDO_TA_PIN_VERIFICATION = 511;
var _FIDO_FAILED_TO_FIDO_PIN_VERIFICATION = 512;
var _FIDO_FAILED_TO_FIDO_FINGERPRINT_VERIFICATION = 513;
var _FIDO_CAN_NOT_USE_TOUCHID = 514;
var _FIDO_UNREGISTRED_FINGERPRINT_OR_TOUCHID = 515;
var _FIDO_FAILED_TO_FIDO_REGISTRATION = 516;
var _FIDO_FAILED_TO_FIDO_AUTHENTICATION = 517;
var _FIDO_FAILED_TO_FIDO_DELETION = 518;
var _FIDO_CANCELED_TO_FINGERPRINT_AUTHENTICATION = 519;
var _FIDO_ENTERED_TO_FINGERPRINT_LOCKMODE = 520;
var _FIDO_NO_HAVE_PERMISSION_FOR_APP = 521;
var _FIDO_LICENSE_DONT_SUPPORTED_FACEPRINT = 601;

var _RET_SELF_URL = window.location.href.split(/[?#]/)[0];
var _SELF_DOMAIN_URL = "bill.ksidmobile.co.kr/";
/* custom const : hidden */
var _PRODUCT_TYPE = "FIDO";     // hidden
var _FIDO_SERVICE_TYPE = 0;     // hidden
var _FIDO_BIO_TYPE = "2";       // hidden

var _INTERGRITY_CHECK_NUM = 0; // show 어떤정보를 받아야 하는지 여부? 의미 없는 데이터인지? FIDO서버에서 해당 데이터의 목적?

var console = console || {
    log : function() {},
    info : function() {},
    error : function() {},
    warn : function() {}
};

/* generate json data for version in header version tag */
$().ready(function() {
    // browser(environment) initialization
    environmentInit();
    // js integrity verify check
    // var intergrity = intergrityChk();
    // if (intergrity == -1) {
    //    _INTERGRITY_CHECK_NUM = intergrity;
    // }
    
    version = new Object();
    version.Major = "1";
    version.Minor = "0";
});

function reqRegConnect(userID) {

    // js integrity verify check
    // if (_INTERGRITY_CHECK_NUM != 0) {
    //     intergrityChk();
    //     return false;
    // }
    
    if (getPhoneOSValue() == '') {
        //alert(_REQUIRED_PHONE_OS);
        genResultValue(_REQUIRED_PHONE_OS);
        return false;
    } else if (userID == '') {
        //alert(_REQUIRED_USER_ID);
        genResultValue(_REQUIRED_USER_ID);
        return false;
    } /*else {
        if (confirm(_CONFIRM_REG_CONNECT)) {
        } else {
            //alert(_ERROR_CANCEL);
            genResultValue(_ERROR_CANCEL);
            return false;
        }
    }*/
    
    userID = userID + '_' + _SELF_DOMAIN_URL + _FIDO_SERVICE_NAME;
    
    var body = new Object();
    body.UserID = userID;
    
    var bArray = new Array();
    bArray.push(body);
    
    var header = new Object();
    header.Version = version;
    header.CMD = _REQ_REG_CONNECT;
    header.Hash = genBodyHash(JSON.parse(JSON.stringify(bArray)));
    
    var hArray = new Array();
    hArray.push(header);
    
    var request = new Object();
    request.Header = hArray;
    request.Body = JSON.stringify(bArray);
    
    $.ajax({
        url : _RELAY_SERVER_URL,
        type : "POST",
        data : {
            REQUEST : JSON.stringify(request)
        },
        success : function(data) {
            var jsonObj = JSON.parse(data);
            if (jsonObj.Header[0].CMD != null) {
                var bodyObj = JSON.parse(jsonObj.Body);
                
                if (jsonObj.Header[0].Hash == genBodyHash(bodyObj)) {
                    if (jsonObj.Header[0].CMD == _RES_REG_CONNECT) {
                        if (bodyObj[0].Status == _STATUS_PROCESS_OK) {
                            var msgObj = bodyObj[0].Message;
                            var dataObj = JSON.parse(bodyObj[0].Data);
                            var rand = dataObj.Random;
                            if (!rand) {
                                genResultValue(_STATUS_INVALID_PARAM);
                            } else {
                                genRandomValue(rand);
                                
                                var clickedAt1 = +new Date;
                                interval3 = setInterval(function() {
                                    if ((+new Date - clickedAt1) < 180000) {
                                        reqRegComplete(userID);
                                    } else {
                                        clearInterval(interval3);
                                    }
                                }, 500);
                            }
                        } else if (bodyObj[0].Status == _STATUS_ALREAY_REGISTERED) {
                            genResultValue(_STATUS_ALREAY_REGISTERED);
                        } else if (bodyObj[0].Status == _STATUS_PROCESS_FAIL) {
                            genResultValue(_STATUS_PROCESS_FAIL);
                        }
                    }
                } else {
                    genResultValue(_STATUS_INVALID_HASH);
                }
            }
        },
        error : function() {
            genResultValue(_STATUS_ERROR_AJAX_CONNECT);
        }
    });
}

function reqModifyConnect(userID) {

    // js integrity verify check
    // if (_INTERGRITY_CHECK_NUM != 0) {
    //     intergrityChk();
    //     return false;
    // }
    
    if (getPhoneOSValue() == '') {
        //alert(_REQUIRED_PHONE_OS);
        genResultValue(_REQUIRED_PHONE_OS);
        return false;
    } else if (userID == '') {
        //alert(_REQUIRED_USER_ID);
        genResultValue(_REQUIRED_USER_ID);
        return false;
    } /*else {
        if (confirm(_CONFIRM_REG_CONNECT)) {
        } else {
            //alert(_ERROR_CANCEL);
            genResultValue(_ERROR_CANCEL);
            return false;
        }
    }*/

    userID = userID + '_' + _SELF_DOMAIN_URL + _FIDO_SERVICE_NAME;
    
    var body = new Object();
    body.UserID = userID;
    
    var bArray = new Array();
    bArray.push(body);
    
    var header = new Object();
    header.Version = version;
    header.CMD = _REQ_MODIFY_CONNECT;
    header.Hash = genBodyHash(JSON.parse(JSON.stringify(bArray)));
    
    var hArray = new Array();
    hArray.push(header);
    
    var request = new Object();
    request.Header = hArray;
    request.Body = JSON.stringify(bArray);
    
    $.ajax({
        url : _RELAY_SERVER_URL,
        type : "POST",
        data : {
            REQUEST : JSON.stringify(request)
        },
        success : function(data) {
            var jsonObj = JSON.parse(data);
            if (jsonObj.Header[0].CMD != null) {
                var bodyObj = JSON.parse(jsonObj.Body);
                
                if (jsonObj.Header[0].Hash == genBodyHash(bodyObj)) {
                    if (jsonObj.Header[0].CMD == _RES_MODIFY_CONNECT) {
                        if (bodyObj[0].Status == _STATUS_PROCESS_OK) {
                            var msgObj = bodyObj[0].Message;
                            var dataObj = JSON.parse(bodyObj[0].Data);
                            var rand = dataObj.Random;
                            if (!rand) {
                                genResultValue(_STATUS_INVALID_PARAM);
                            } else {
                                genRandomValue(rand);
                                
                                var clickedAt2 = +new Date;
                                interval3 = setInterval(function() {
                                    if ((+new Date - clickedAt2) < 180000) {
                                        reqRegComplete(userID);
                                    } else {
                                        clearInterval(interval3);
                                    }
                                }, 500);
                            }
                        } else if (bodyObj[0].Status == _STATUS_PROCESS_FAIL) {
                            genResultValue(_STATUS_PROCESS_FAIL);
                        }
                    }
                } else {
                    genResultValue(_STATUS_INVALID_HASH);
                }
            }
        },
        error : function() {
            genResultValue(_STATUS_ERROR_AJAX_CONNECT);
        }
    });
}

function reqRegComplete(userID) {
    
    var body = new Object();
    body.UserID = userID;
    
    var bArray = new Array();
    bArray.push(body);
    
    var header = new Object();
    header.Version = version;
    header.CMD = _REQ_REG_COMPLETE;
    header.Hash = genBodyHash(JSON.parse(JSON.stringify(bArray)));
    
    var hArray = new Array();
    hArray.push(header);
    
    var request = new Object();
    request.Header = hArray;
    request.Body = JSON.stringify(bArray);
    
    $.ajax({
        url : _RELAY_SERVER_URL,
        type : "POST",
        data : {
            REQUEST : JSON.stringify(request)
        },
        success : function(data) {
            var jsonObj = JSON.parse(data);
            if (jsonObj.Header[0].CMD != null) {
                var bodyObj = JSON.parse(jsonObj.Body);
                // var msgObj = bodyObj[0].Message;
                // var dataObj = JSON.parse(bodyObj[0].Data);
                
                if (jsonObj.Header[0].Hash == genBodyHash(bodyObj)) {
                    if (jsonObj.Header[0].CMD == _RES_REG_COMPLETE) {
                        if (bodyObj[0].Status == _STATUS_PROCESS_OK) {
                            genResultValue(_STATUS_PROCESS_OK);
                            clearInterval(interval3);
                        } else if(bodyObj[0].Status == _STATUS_PROCESS_FAIL) {
                            genResultValue(_STATUS_PROCESS_FAIL);
                            clearInterval(interval3);
                        }
                    }
                } else {
                    genResultValue(_STATUS_INVALID_HASH);
                    clearInterval(interval3);
                }
            }
        },
        error : function() {
            genResultValue(_STATUS_ERROR_AJAX_CONNECT);
            clearInterval(interval3);
        }
    });
}

function genFIDORequest(userID, op) {

    // js integrity verify check
    // if (_INTERGRITY_CHECK_NUM != 0) {
    //     intergrityChk();
    //     return false;
    // }
    
    if (getPhoneOSValue() == '') {
        //alert(_REQUIRED_PHONE_OS);
        genResultValue(_REQUIRED_PHONE_OS);
        return false;
    } else if (userID == '') {
        //alert(_REQUIRED_USER_ID);
        genResultValue(_REQUIRED_USER_ID);
        return false;
    } /*else {
        if (confirm(_CONFIRM_FIDO_REQUEST)) {
        } else {
            //alert(_ERROR_CANCEL);
            genResultValue(_ERROR_CANCEL);
            return false;
        }
    }*/
    
    userID = userID + '_' + _SELF_DOMAIN_URL + _FIDO_SERVICE_NAME;
    
    var body = new Object();
    body.UserID = userID;
    
    var bArray = new Array();
    bArray.push(body);
    
    var header = new Object();
    header.Version = version;
    header.CMD = _REQ_CONNECT_RELAY_PC;
    header.Hash = genBodyHash(JSON.parse(JSON.stringify(bArray)));
    
    var hArray = new Array();
    hArray.push(header);
    
    var request = new Object();
    request.Header = hArray;
    request.Body = JSON.stringify(bArray);
    
    $.ajax({
        url : _RELAY_SERVER_URL,
        type : "POST",
        data : {
            REQUEST : JSON.stringify(request)
        },
        success : function(data) {
            var jsonObj = JSON.parse(data);
            if (jsonObj.Header[0].CMD != null) {
                var bodyObj = JSON.parse(jsonObj.Body);
                
                if (jsonObj.Header[0].Hash == genBodyHash(bodyObj)) {
                    if (jsonObj.Header[0].CMD == _RES_CONNECT_RELAY_PC) {
                        if (bodyObj[0].Status == _STATUS_PROCESS_OK) {
                            var msgObj = bodyObj[0].Message;
                            var dataObj = JSON.parse(bodyObj[0].Data);
                            var tid = dataObj.TID;
                            if (!tid) {
                                genResultValue(_STATUS_INVALID_PARAM);
                            } else {
                                var clickedAt3 = +new Date;
                                interval1 = setInterval(function() {
                                    if ((+new Date - clickedAt3) < 180000) {
                                        reqSecretShare(tid, userID, op);
                                    } else {
                                        clearInterval(interval1);
                                    }
                                }, 500);
                            }
                        } else if (bodyObj[0].Status == _STATUS_NO_SEND_PUSH_MSG) {
                            genResultValue(_STATUS_NO_SEND_PUSH_MSG);
                        } else if (bodyObj[0].Status == _STATUS_PROCESS_FAIL) {
                            genResultValue(_STATUS_PROCESS_FAIL);
                        } else if (bodyObj[0].Status == _STATUS_NO_PUSHTOKEN_REG) {
                            genResultValue(_STATUS_NO_PUSHTOKEN_REG);
                        }
                    }
                } else {
                    genResultValue(_STATUS_INVALID_HASH);
                }
            }
        },
        error : function() {
            genResultValue(_STATUS_ERROR_AJAX_CONNECT);
        }
    });
}

function reqSecretShare(tid, userID, op) {
    
    var body = new Object();
    body.TID = tid;
    
    var bArray = new Array();
    bArray.push(body);
    
    var header = new Object();
    header.Version = version;
    header.CMD = _REQ_SECRET_SHARE;
    header.Hash = genBodyHash(JSON.parse(JSON.stringify(bArray)));
    
    var hArray = new Array();
    hArray.push(header);
    
    var request = new Object();
    request.Header = hArray;
    request.Body = JSON.stringify(bArray);
    
    $.ajax({
        url : _RELAY_SERVER_URL,
        type : "POST",
        data : {
            REQUEST : JSON.stringify(request)
        },
        success : function(data) {
            var jsonObj = JSON.parse(data);
            if (jsonObj.Header[0].CMD != null) {
                var bodyObj = JSON.parse(jsonObj.Body);
                
                if (jsonObj.Header[0].Hash == genBodyHash(bodyObj)) {
                    if (jsonObj.Header[0].CMD == _RES_SECRET_SHARE) {
                        if (bodyObj[0].Status == _STATUS_PROCESS_OK) {
                            
                            clearInterval(interval1);

                            var msgObj = bodyObj[0].Message;
                            var dataObj = JSON.parse(bodyObj[0].Data);
                            var pubKey = dataObj.PublicKey;
                            var r1 = dataObj.R1;
                            if (!pubKey || !r1) {
                                genResultValue(_STATUS_INVALID_PARAM)
                            } else {
                                reqPCFinished(pubKey, r1, tid, userID, op);
                            }
                        } else if (bodyObj[0].Status == _STATUS_PROCESS_FAIL) {
                            genResultValue(_STATUS_PROCESS_FAIL);
                            clearInterval(interval1);
                        }
                    }
                } else {
                    genResultValue(_STATUS_INVALID_HASH);
                    clearInterval(interval1);
                }
            }
        },
        error : function() {
            genResultValue(_STATUS_ERROR_AJAX_CONNECT);
            clearInterval(interval1);
        }
    });
}

function reqPCFinished(pubKey, r1, tid, userID, op) {
    
    var r2 = crosscert.random.getBytes(20);
    var encryptR2 = genAsymmeticEncryptData(pubKey, r2);
    var plainText = genCCFIDOCommand(userID, op);
    var inputBytes = crosscert.util.createBuffer();
    inputBytes.putBytes(plainText);
    
    var cipherText = genSymmetricEncryptData(r1, r2, inputBytes);
    
    var body = new Object();
    body.R2 = encryptR2;
    body.CipherText = cipherText;
    body.TID = tid;
    
    var bArray = new Array();
    bArray.push(body);
    
    var header = new Object();
    header.Version = version;
    header.CMD = _REQ_PC_FINISHED;
    header.Hash = genBodyHash(JSON.parse(JSON.stringify(bArray)));
    
    var hArray = new Array();
    hArray.push(header);
    
    var request = new Object();
    request.Header = hArray;
    request.Body = JSON.stringify(bArray);
    
    $.ajax({
        url : _RELAY_SERVER_URL,
        type : "POST",
        data : {
            REQUEST : JSON.stringify(request)
        },
        success : function(data) {
            var jsonObj = JSON.parse(data);
            if (jsonObj.Header[0].CMD != null) {
                var bodyObj = JSON.parse(jsonObj.Body);
                // var msgObj = bodyObj[0].Message;
                // var dataObj = JSON.parse(bodyObj[0].Data);
                
                if (jsonObj.Header[0].Hash == genBodyHash(bodyObj)) {
                    if (jsonObj.Header[0].CMD == _RES_PC_FINISHED) {
                        if (bodyObj[0].Status == _STATUS_PROCESS_OK) {
                            if (!r1 || !r2 || !cipherText || !tid) {
                                genResultValue(_STATUS_INVALID_PARAM)
                            } else {
                                var clickedAt4 = +new Date;
                                interval2 = setInterval(function() {
                                    if ((+new Date - clickedAt4) < 180000) {
                                        reqApplicationPCData(r1, r2,
                                                cipherText, tid);
                                    } else {
                                        clearInterval(interval2);
                                    }
                                }, 500);
                            }
                        } else if (bodyObj[0].Status == _STATUS_PROCESS_FAIL) {
                            genResultValue(_STATUS_PROCESS_FAIL);
                        }
                    }
                } else {
                    genResultValue(_STATUS_INVALID_HASH);
                }
            }
        },
        error : function() {
            genResultValue(_STATUS_ERROR_AJAX_CONNECT);
        }
    });
}

function reqApplicationPCData(r1, r2, cipherText, tid) {
    
    var body = new Object();
    body.TID = tid;
    
    var bArray = new Array();
    bArray.push(body);
    
    var header = new Object();
    header.Version = version;
    header.CMD = _REQ_APPLICATION_PCDATA;
    header.Hash = genBodyHash(JSON.parse(JSON.stringify(bArray)));
    
    var hArray = new Array();
    hArray.push(header);
    
    var request = new Object();
    request.Header = hArray;
    request.Body = JSON.stringify(bArray);
    
    $.ajax({
        url : _RELAY_SERVER_URL,
        type : "POST",
        data : {
            REQUEST : JSON.stringify(request)
        },
        success : function(data) {
            var jsonObj = JSON.parse(data);
            if (jsonObj.Header[0].CMD != null) {
                var bodyObj = JSON.parse(jsonObj.Body);
                
                if (jsonObj.Header[0].Hash == genBodyHash(bodyObj)) {
                    if (jsonObj.Header[0].CMD == _RES_APPLICATION_PCDATA) {
                        if (bodyObj[0].Status == _STATUS_PROCESS_OK) {
                            
                            clearInterval(interval2);

                            var msgObj = bodyObj[0].Message;
                            var dataObj = JSON.parse(bodyObj[0].Data);
                            var authToken = dataObj.AuthToken;
                            var cipherSText = dataObj.CipherSText;
                            console.log("msgObj : ", msgObj);
                            console.log("dataObj : ", dataObj);
                            console.log("authToken : ", authToken);
                            
                            if (!r1 || !r2 || !cipherSText
                                    || !authToken) {
                                genResultValue(_STATUS_INVALID_PARAM)
                            } else {
                                var decryptCipherSText = genSymmetricDecryptData(
                                        r1, r2, cipherSText);
                                console.log("decryptCipherSText : ", decryptCipherSText);

                                var verifyRST = verifyDecryptText(decryptCipherSText);
                                if (verifyRST) {
                                    var ErrCode = printDecryptText(decryptCipherSText);
                                    var jErrCode = JSON.parse(ErrCode);
                                    var dErrCode = crosscert.util.decode64(jErrCode.ErrCode);
                                    
                                    // genFIDOResponse(dErrCode);
                                    console.log("ErrCode : ", ErrCode);
                                    console.log("jErrCode : ", jErrCode);
                                    console.log("dErrCode : ", dErrCode);
                                    
                                    var sErrCode = JSON.stringify(dErrCode);
                                    sErrCode = sErrCode.replace(/\u0000/g, "");
                                    sErrCode = sErrCode.replace(/\\u0000/g, "");
                                    sErrCode = JSON.parse(sErrCode);
                                    
                                    var oErrCode = JSON.parse(sErrCode);
                                    console.log("oErrCode : ", oErrCode);
                                    
                                    if (oErrCode.errCode == "0") {
                                        genResultValue(_STATUS_PROCESS_OK);
                                        genFIDOAuthToken(oErrCode.authToken);
                                    } else if (oErrCode.errCode == "-1000") {
                                        genResultValue(_FIDO_UNKNOWN_ERROR);
                                    } else if (oErrCode.errCode == "-1001") {
                                        genResultValue(_FIDO_LICENSE_ERROR);
                                    } else if (oErrCode.errCode == "-1002") {
                                        genResultValue(_FIDO_BAD_POROTOCAL);
                                    } else if (oErrCode.errCode == "-1003") {
                                        genResultValue(_FIDO_UNAVAILABLE_BIO_TYPE);
                                    } else if (oErrCode.errCode == "-1004") {
                                        genResultValue(_FIDO_FAILED_TO_CONNECT_FIDO_SERVER);
                                    } else if (oErrCode.errCode == "-1005") {
                                        genResultValue(_FIDO_UNREGISTERED_THE_PIN);
                                    } else if (oErrCode.errCode == "-1006") {
                                        genResultValue(_FIDO_ALREADY_REGISTED_USER);
                                    } else if (oErrCode.errCode == "-1007") {
                                        genResultValue(_FIDO_UNREGISTERD_USER);
                                    } else if (oErrCode.errCode == "-1008") {
                                        genResultValue(_FIDO_DONT_SUPPORTED_DEVICE);
                                    } else if (oErrCode.errCode == "-1009") {
                                        genResultValue(_FIDO_DONT_SUPPORTED_KFIDO);
                                    } else if (oErrCode.errCode == "-1010") {
                                        genResultValue(_FIDO_DONT_SUPPORTED_PUREFIDO);
                                    } else if (oErrCode.errCode == "-1011") {
                                        genResultValue(_FIDO_FAILED_TO_FIDO_TA_PIN_VERIFICATION);
                                    } else if (oErrCode.errCode == "-1012") {
                                        genResultValue(_FIDO_FAILED_TO_FIDO_PIN_VERIFICATION);
                                    } else if (oErrCode.errCode == "-1013") {
                                        genResultValue(_FIDO_FAILED_TO_FIDO_FINGERPRINT_VERIFICATION);
                                    } else if (oErrCode.errCode == "-1014") {
                                        genResultValue(_FIDO_CAN_NOT_USE_TOUCHID);
                                    } else if (oErrCode.errCode == "-1015") {
                                        genResultValue(_FIDO_UNREGISTRED_FINGERPRINT_OR_TOUCHID);
                                    } else if (oErrCode.errCode == "-1016") {
                                        genResultValue(_FIDO_FAILED_TO_FIDO_REGISTRATION);
                                    } else if (oErrCode.errCode == "-1017") {
                                        genResultValue(_FIDO_FAILED_TO_FIDO_AUTHENTICATION);
                                    } else if (oErrCode.errCode == "-1018") {
                                        genResultValue(_FIDO_FAILED_TO_FIDO_DELETION);
                                    } else if (oErrCode.errCode == "-1019") {
                                        genResultValue(_FIDO_CANCELED_TO_FINGERPRINT_AUTHENTICATION);
                                    } else if (oErrCode.errCode == "-1020") {
                                        genResultValue(_FIDO_ENTERED_TO_FINGERPRINT_LOCKMODE);
                                    } else if (oErrCode.errCode == "-1021") {
                                        genResultValue(_FIDO_NO_HAVE_PERMISSION_FOR_APP);
                                    }
                                    // FIDO ERROR CODE Added by faceprint(2017-11-21)
                                    else if (oErrCode.errCode == "-1101") {
                                        genResultValue(_FIDO_LICENSE_DONT_SUPPORTED_FACEPRINT);
                                    } 
                                    else {
                                        genResultValue(_STATUS_ERROR_FIDO_OPERATION);
                                    }
                                }
                            }
                        } else if (bodyObj[0].Status == _STATUS_PROCESS_FAIL) {
                            genResultValue(_STATUS_PROCESS_FAIL);
                            clearInterval(interval2);
                        }
                    }
                } else {
                    genResultValue(_STATUS_INVALID_HASH);
                    clearInterval(interval2);
                }
            }
        },
        error : function() {
            genResultValue(_STATUS_ERROR_AJAX_CONNECT);
            clearInterval(interval2);
        }
    });
}

function reqVerifyAuthToken(authToken, tid) {
    
    var body = new Object();
    body.AuthToken = authToken;
    body.TID = tid;
    
    var bArray = new Array();
    bArray.push(body);
    
    var header = new Object();
    header.Version = version;
    header.CMD = _REQ_VERIFY_AUTHTOKEN;
    header.Hash = genBodyHash(JSON.parse(JSON.stringify(bArray)));
    
    var hArray = new Array();
    hArray.push(header);
    
    var request = new Object();
    request.Header = hArray;
    request.Body = JSON.stringify(bArray);
    
    $.ajax({
        url : _RELAY_SERVER_URL,
        type : "POST",
        data : {
            REQUEST : JSON.stringify(request)
        },
        success : function(data) {
            var jsonObj = JSON.parse(data);
            if (jsonObj.Header[0].CMD != null) {
                var bodyObj = JSON.parse(jsonObj.Body);
                // var msgObj = bodyObj[0].Message;
                // var dataObj = JSON.parse(bodyObj[0].Data);
                
                if (jsonObj.Header[0].Hash == genBodyHash(bodyObj)) {
                    if (jsonObj.Header[0].CMD == _RES_VERIFY_AUTHTOKEN) {
                        if (bodyObj[0].Status == _STATUS_PROCESS_OK) {
                            genResultValue(_STATUS_PROCESS_OK);
                        } else if (bodyObj[0].Status == _STATUS_INVALID_AUTHTOKEN) {
                            genResultValue(_STATUS_INVALID_AUTHTOKEN);
                        }
                    }
                } else {
                    genResultValue(_STATUS_INVALID_HASH);
                }
            }
        },
        error : function() {
            genResultValue(_STATUS_ERROR_AJAX_CONNECT);
        }
    });
}

/* generate base64urlFIDO Command for FIDO Operation */
function genCCFIDOCommand(userID, op) {
    var _CCFidoProtocol = new Object();
    //_CCFidoProtocol.op = getOperationType();
    _CCFidoProtocol.op = op;
    _CCFidoProtocol.serviceName = _FIDO_SERVICE_NAME;
    _CCFidoProtocol.serviceType = _FIDO_SERVICE_TYPE;
    //_CCFidoProtocol.bioType = decimalToHexString(parseInt(getBioTypeValue()));
    _CCFidoProtocol.bioType = decimalToHexString(parseInt(_FIDO_BIO_TYPE));
    _CCFidoProtocol.id = userID;
    _CCFidoProtocol.fidoServerUrl = _FIDO_SERVER_URL;
    
    var _FIDOCommand = new Object();
    _FIDOCommand.product_type = _PRODUCT_TYPE;
    // _FIDOCommand.product_type = "FIDO";
    _FIDOCommand.ccfidoprotocol = _CCFidoProtocol;
    _FIDOCommand.caller_url_scheme = _RET_SELF_URL;
    
    if (getPhoneOSValue().indexOf('iOS') > -1) {
        _FIDOCommand.appKey = _APPKEY_IOS;
    }
    if (getPhoneOSValue().indexOf('ANDROID') > -1) {
        _FIDOCommand.appKey = _APPKEY_ANDROID;
    }
    
    var base64UrlFIDOCommand = "";
    base64UrlFIDOCommand = encodeUrl(crosscert.util.encode64(JSON
            .stringify(_FIDOCommand)));
    
    return base64UrlFIDOCommand;
}

function getPhoneOSValue() {
    var rst = '';
    var obj = document.getElementsByName("phoneOS");
    for (var i = 0; i < obj.length; i++) {
        if (obj[i].checked) {
            rst = obj[i].value;
        }
    }
    return rst;
}

function getOperationType() {
    var rst = '';
    var obj = document.getElementsByName("operationType");
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

/* 20Byte의 Random정보(R2)를 생성하여 수신 받은 공개키로 암호화(RSA2048알고리즘 이용) */
function genAsymmeticEncryptData(_pubKey, inputData) {
    var encryptStr = '';
    try {
        var dPubKey = decodeUrl(_pubKey);
        var pubKey = crosscert.pki.publicKeyFromBase64(dPubKey);
        var encrypt = pubKey.encrypt(inputData);
        encryptStr = crosscert.util.encode64(encrypt);
        var encUrlEncrypt = encodeUrl(encryptStr);
    } catch (e) {
        alert(e.message + '[errcode : ' + e.code + ']');
    }
    return encUrlEncrypt;
}

/* R1과 R2를 이용하여 대칭키를 생성한 후, 스마트폰 측에서 잔달할 원문메세지와 SHA256기반으로 원문을 Hash한 정보를 AES123CBC기반의 대칭키로 암호화 */
function genSymmetricEncryptData(r1, r2, inputData) {
    var encryptStr = '';
    var dR1 = decodeUrl(r1);
    var d64R1 = crosscert.util.decode64(dR1);
    var HashAlgo = 'sha256';
    
    var arrayKey = '';
    try {
        var md1 = crosscert.md.algorithms[HashAlgo].create();
        md1.start();
        md1.update(d64R1);
        
        var hR1 = md1.digest().toHex();
        var bR1 = crosscert.util.hexToBytes(hR1);
        var bR2 = r2;
        
        var Key = bR1.concat(bR2);
        
        var md2 = crosscert.md.algorithms[HashAlgo].create();
        md2.start();
        md2.update(Key);
        
        var hKey = md2.digest().toHex();
        arrayKey = toHexArray(hKey);
    } catch (e) {
        alert(e.message + '[errcode : ' + e.code + ']');
    }
    
    var a = new Array(16);
    for (var i = 0; i < 16; i++) {
        a[i] = arrayKey[i];
    }
    var key = toHexString(a);
    
    var b = new Array(16);
    for (var j = 0; j < 16; j++) {
        b[j] = arrayKey[j + 16];
    }
    var iv = toHexString(b);
    
    var symmkey = crosscert.util.hexToBytes(key);
    var symmiv = crosscert.util.hexToBytes(iv);
    
    var symmAlgo = 'aes';
    var cipher = crosscert.cipher.algorithms[symmAlgo].startEncrypting(symmkey,
            symmiv);
    cipher.update(crosscert.util.createBuffer(inputData));
    cipher.finish();
    
    encryptStr = crosscert.util.encode64(cipher.output.getBytes());
    var encUrlEncrypt = encodeUrl(encryptStr);
    
    return encUrlEncrypt;
}

/* R1과 R2를 이용하여 대칭키를 생성한 후, 스마트폰 측에서 잔달할 원문메세지와 SHA256기반으로 원문을 Hash한 정보를 AES123CBC기반의 대칭키로 복호화 */
function genSymmetricDecryptData(r1, r2, encData) {
    var decryptStr = '';
    var dR1 = decodeUrl(r1);
    var d64R1 = crosscert.util.decode64(dR1);
    var dEncData = decodeUrl(encData);
    var encValue = crosscert.util.decode64(dEncData);
    var HashAlgo = 'sha256';
    
    var arrayKey = '';
    try {
        var md1 = crosscert.md.algorithms[HashAlgo].create();
        md1.start();
        md1.update(d64R1);
        
        var hR1 = md1.digest().toHex();
        var bR1 = crosscert.util.hexToBytes(hR1);
        var bR2 = r2;
        
        var Key = bR1.concat(bR2);
        
        var md2 = crosscert.md.algorithms[HashAlgo].create();
        md2.start();
        md2.update(Key);
        
        var hKey = md2.digest().toHex();
        arrayKey = toHexArray(hKey);
    } catch (e) {
        alert(e.message + '[errcode : ' + e.code + ']');
    }
    
    var a = new Array(16);
    for (var i = 0; i < 16; i++) {
        a[i] = arrayKey[i];
    }
    var key = toHexString(a);
    
    var b = new Array(16);
    for (var j = 0; j < 16; j++) {
        b[j] = arrayKey[j + 16];
    }
    var iv = toHexString(b);
    
    var symmkey = crosscert.util.hexToBytes(key);
    var symmiv = crosscert.util.hexToBytes(iv);
    
    var symmAlgo = 'aes';
    var cipher = crosscert.cipher.algorithms[symmAlgo].startDecrypting(symmkey,
            symmiv);
    cipher.update(crosscert.util.createBuffer(encValue));
    cipher.finish();
    
    decryptStr = cipher.output.getBytes();
    
    return decryptStr;
}

function genBodyHash(json) {
    var jsonData = JSON.stringify(json);
    var md = crosscert.md.algorithms['sha256'].create();
    md.start();
    md.update(jsonData);
    
    var hashData = crosscert.util.encode64(crosscert.util.hexToBytes(md
            .digest().toHex()));
    
    hashData = encodeUrl(hashData);
    
    return hashData;
}

function verifyDecryptText(decryptText) {
    var booleanValue = false;
    
    var hData = decryptText.substr(0, 32);
    var pData = decryptText.substr(32, decryptText.length - 32);
    
    var md1 = crosscert.md.algorithms['sha256'].create();
    md1.start();
    md1.update(pData);
    
    var hPData = crosscert.util.hexToBytes(md1.digest().toHex());
    
    if (hData === hPData) {
        booleanValue = true
    }
    
    return booleanValue;
}

function printDecryptText(decryptText) {
    return decryptText.substr(32, decryptText.length - 32);
}

/* hexString To hexArray */
function toHexArray(hexString) {
    var a = [];
    for (var i = 0; i < hexString.length; i += 2) {
        a.push("0x" + hexString.substr(i, 2));
    }
    return a;
}

/* hexArray To hexString */
function toHexString(hexArray) {
    var result = "";
    for (i in hexArray) {
        var str = hexArray[i].toString(16);
        str = str.length == 0 ? "00" : str.length == 1 ? "0" + str
                : str.length == 2 ? str : str.substring(str.length - 2,
                        str.length);
        result += str;
    }
    return result;
}

function encodeUrl(str) {
    return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');
}

function decodeUrl(str) {
    // str = (str + '===').slice(0, str.length + (str.length % 4));
    str = (str + '=').slice(0, str.length + (str.length % 4));
    return str.replace(/-/g, '+').replace(/_/g, '/');
}

function cutByLen(str, maxByte) {
    for (b = i = 0; c = str.charCodeAt(i);) {
        b += c >> 7 ? 2 : 1;
        if (b > maxByte)
            break;
        i++;
    }
    return str.substring(0, i);
}

function decimalToHexString(number) {
    if (number < 0) {
        number = 0xFFFFFFFF + number + 1;
    }
    
    return number.toString(16).toUpperCase();
}

function environmentInit() {
    var __OSName = null;
    var __BrowserName = null;
    var __BrowserVersion = 0;
    var __Interface = null;
    var __RegularExp = null;
    var __Platform = navigator.platform;
    var __UserAgent = navigator.userAgent;
    
    if (0 <= __Platform.indexOf('Win')) {
        __OSName = 'win';
    } else if (0 <= __Platform.indexOf('Mac')) {
        __OSName = 'mac';
    } else if (0 <= __Platform.indexOf('Linux')) {
        __OSName = 'linux';
    } else if (0 <= __Platform.indexOf('iPhone')
            || 0 <= __Platform.indexOf('iPad')
            || 0 <= __Platform.indexOf('iPod')) {
        __OSName = 'ios';
    } else {
        __OSName = 'unknown';
    }
    
    if (0 <= __UserAgent.indexOf('Android')) {
        __OSName = 'android';
    }
    
    if ('android' === __OSName) {
        if (0 <= __UserAgent.indexOf('SAMSUNG')) {
            __BrowserName = 'android samsung';
            __RegularExp = new RegExp(
                    'Version\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('OPR')) {
            __BrowserName = 'android opera';
            __RegularExp = new RegExp(
                    'OPR\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('Opera')) {
            __BrowserName = 'android opera classic';
            __RegularExp = new RegExp(
                    'Version\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('Firefox')) {
            __BrowserName = 'android firefox';
            __RegularExp = new RegExp(
                    'Firefox\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('NAVER')) {
            __BrowserName = 'android naver';
            //__RegularExp = null;
        } else if (0 <= __UserAgent.indexOf('DaumApps')) {
            __BrowserName = 'android daum';
            __RegularExp = new RegExp(
                    'DaumApps\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('nate_app')) {
            __BrowserName = 'android nate';
            //__RegularExp = null;
        } else if (0 <= __UserAgent.indexOf('UCBrowser')) {
            __BrowserName = 'android uc';
            __RegularExp = new RegExp(
                    'UCBrowser\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('Chrome')) { // from icecream sandwith
            if (0 <= __UserAgent.indexOf('Version')) {
                if (0 <= __UserAgent.indexOf('LG')) {
                    __BrowserName = 'android lg';
                    __RegularExp = new RegExp(
                            'Version\/([0-9]{1,}[\.0-9]{0,})');
                } else {
                    __BrowserName = 'android browser';
                    __RegularExp = new RegExp(
                            'Version\/([0-9]{1,}[\.0-9]{0,})');
                }
            } else {
                if (0 <= __UserAgent.indexOf('LG')) { // sometimes chrome's and lg default browser's user agent are same.
                    __RegularExp = new RegExp(
                            'Chrome\/([0-9]{1,}[\.0-9]{0,})');
                    if (__RegularExp
                            && __RegularExp
                                    .exec(__UserAgent)) {
                        __BrowserVersion = parseFloat(RegExp.$1);
                    }
                    
                    if (39.0 > __BrowserVersion) { // latest version
                        __BrowserName = 'android lg';
                    } else {
                        __BrowserName = 'android chrome';
                    }
                } else {
                    __BrowserName = 'android chrome';
                    __RegularExp = new RegExp(
                            'Chrome\/([0-9]{1,}[\.0-9]{0,})');
                }
            }
        } else {
            __BrowserName = 'unknown';
            __BrowserVersion = 0;
        }
    } else if ('ios' === __OSName) {
        if (0 <= __UserAgent.indexOf('CriOS')) {
            __BrowserName = 'ios chrome';
            __RegularExp = new RegExp(
                    'CriOS\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('NAVER')) {
            __BrowserName = 'ios naver';
            //__RegularExp = null;
        } else if (0 <= __UserAgent.indexOf('DaumApps')) {
            __BrowserName = 'ios daum';
            __RegularExp = new RegExp(
                    'DaumApps\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('Coast')) {
            __BrowserName = 'ios opera coast';
            __RegularExp = new RegExp(
                    'Coast\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('Safari')) {
            __BrowserName = 'ios safari';
            __RegularExp = new RegExp(
                    'Version\/([0-9]{1,}[\.0-9]{0,})');
        } else {
            __BrowserName = 'unknown';
            __BrowserVersion = 0;
        }
    } else { // pc
        if (0 <= __UserAgent.indexOf('MSIE')) {
            __BrowserName = 'msie';
            
            if ('BackCompat' == document.compatMode) {
                __BrowserVersion = 5;
            } else if (document.documentMode) {
                __BrowserVersion = document.documentMode;
            } else {
                __RegularExp = new RegExp(
                        'MSIE ([0-9]{1,}[\.0-9]{0,})');
            }
        } else if (0 <= __UserAgent.indexOf('Chrome')) {
            __BrowserName = 'chrome';
            __RegularExp = new RegExp(
                    'Chrome\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('Firefox')) {
            __BrowserName = 'firefox';
            __RegularExp = new RegExp(
                    'Firefox\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('Safari')) {
            __BrowserName = 'safari';
            __RegularExp = new RegExp(
                    'Version\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('Opera')) {
            __BrowserName = 'opera';
            __RegularExp = new RegExp(
                    'Version\/([0-9]{1,}[\.0-9]{0,})');
        } else if (0 <= __UserAgent.indexOf('rv:11.')) {
            __BrowserName = 'msie';
            __RegularExp = new RegExp(
                    'rv:([0-9]{1,}[\.0-9]{0,})');
        } else {
            __BrowserName = 'unknown';
            __BrowserVersion = 0;
        }
    }
    
    if (__RegularExp && __RegularExp.exec(__UserAgent)) {
        __BrowserVersion = parseFloat(RegExp.$1);
    }
    
    var __BrowserVersionChecker = function() {
        if (__BrowserName == 'msie') {
            return (__BrowserVersion < 10);
        } else if (__BrowserName == 'chrome') {
            return (__BrowserVersion < 10);
        } else if (__BrowserName == 'firefox') {
            return (__BrowserVersion < 10);
        } else if (__BrowserName == 'safari') {
            return (__BrowserVersion < 6.1);
        } else if (__BrowserName == 'opera') {
            return (__BrowserVersion < 15);
        } else {
            return true;
        }
        return false;
    }

    console.info('UI platform : ', __Platform, '\nuseragent : ',
            __UserAgent, '\nOS name : ', __OSName, '\nbrowser name : ',
            __BrowserName, '\nbrowser version : ', __BrowserVersion);
}

function intergrityChk() {
    var exObj = {eval: false, intergrity: false, name:"push", url:"crosscert/integrity/push.js"};
    var signData = callExternalScript(exObj);
    var p7 = null;
    try {
        p7 = crosscert.pkcs7.messageFromBase64(signData);
        p7.verify();
    } catch (e) {
        console.info('ErrCode : ', e.code);
        return;
    }
    console.info('verify result :', p7.verifyResult);
    
    if (p7.verifyResult == true) {
        var p7List = new Array();
        p7List = genpkcs7List(p7.content);
        
        var __ExtendList = [
            {eval : true, intergrity : true, name : "util", url : "crosscert/jsustoolkit/toolkit/util.js" }, 
            {eval : true, intergrity : true, name : "jsbn", url : "crosscert/jsustoolkit/toolkit/jsbn.js"}, 
            {eval : true, intergrity : true, name : "aes", url : "crosscert/jsustoolkit/crypto/aes.js"},
            {eval : true, intergrity : true, name : "des", url : "crosscert/jsustoolkit/crypto/des.js"},
            {eval : true, intergrity : true, name : "desofb", url : "crosscert/jsustoolkit/crypto/desofb.js"},
            {eval : true, intergrity : true, name : "seed", url : "crosscert/jsustoolkit/crypto/seed.js"},
            {eval : true, intergrity : true, name : "sha1", url : "crosscert/jsustoolkit/crypto/sha1.js"},
            {eval : true, intergrity : true, name : "md5", url : "crosscert/jsustoolkit/crypto/md5.js"},
            {eval : true, intergrity : true, name : "sha256", url : "crosscert/jsustoolkit/crypto/sha256.js"},
            {eval : true, intergrity : true, name : "prng", url : "crosscert/jsustoolkit/crypto/prng.js"},
            {eval : true, intergrity : true, name : "hmac", url : "crosscert/jsustoolkit/crypto/hmac.js"},
            {eval : true, intergrity : true, name : "random", url : "crosscert/jsustoolkit/crypto/random.js"},
            {eval : true, intergrity : true, name : "oids", url : "crosscert/jsustoolkit/toolkit/oids.js"},
            {eval : true, intergrity : true, name : "asn1", url : "crosscert/jsustoolkit/toolkit/asn1.js"},
            {eval : true, intergrity : true, name : "rsa", url : "crosscert/jsustoolkit/crypto/rsa.js"},
            {eval : true, intergrity : true, name : "pki", url : "crosscert/jsustoolkit/toolkit/pki.js"},
            {eval : true, intergrity : true, name : "pkcs5", url : "crosscert/jsustoolkit/toolkit/pkcs5.js"},
            {eval : true, intergrity : true, name : "pkcs8", url : "crosscert/jsustoolkit/toolkit/pkcs8.js"},
            {eval : true, intergrity : true, name : "pkcs7asn1", url : "crosscert/jsustoolkit/toolkit/pkcs7asn1.js"},
            {eval : true, intergrity : true, name : "pkcs7", url : "crosscert/jsustoolkit/toolkit/pkcs7.js"},
            {eval : true, intergrity : true, name : "CCFidoUtils", url : "crosscert/push/CCFidoUtils.js"}];
        
        for (var i = 0; i < __ExtendList.length; i++) {
            callExternalScript(__ExtendList[i]);
        }
        
        for (var j = 0; j < __FileList.length; j++) {
            var name = __FileList[j].name;
            var data = __FileList[j].data;
            
            var md = crosscert.md.algorithms['sha256'].create();
            md.start();
            md.update(data);
            
            for (var k = 0; k < p7List.length; k++) {
                if (p7List[k].name == name) {
                    if (p7List[k].data != md.digest().toHex()) {
                        console.info('*** Suspicion Forgery ***');
                        console.info('intergrity file name : ', p7List[k].name);
                        console.info('intergrity file md data : ', p7List[k].data);
                        console.info('downloaded file name : ', name);
                        console.info('downloaded file md data : ', md.digest().toHex());
                        console.info('Is this Browser supporting plugin free cert backup? : ', (p7List[k].data == md.digest().toHex()));
                        
                        //alert(_ERROR_FORGERY_VERIFY);
                        genResultValue(_ERROR_FORGERY_VERIFY);
                        return -1;
                    }
                }
            }
            
        }
        
    } else {
        //alert(_ERROR_SIGN_VERIFY);
        genResultValue(_ERROR_SIGN_VERIFY);
        return -1;
    }
}

function callExternalScript(obj) {
    var req = null;
    if (window.XMLHttpRequest) {
        req = new window.XMLHttpRequest;
    } else {
        req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
    }
    
    req.open('GET', obj.url, false);
    req.send(null);
    if (req.status == 200) {
        if (obj.intergrity === true) {
            var struct = new Object();
            struct['name'] = obj.name + '.js';
            struct['data'] = req.responseText;
            
            __FileList[__ListIndex++] = struct;
        }
        
        if (obj.eval == false && obj.intergrity == false) {
            return req.responseText;
        }
    }
}

function genpkcs7List(obj) {
    var list = new Array();
    var line = obj.data.split(/\r\n|\r|\n/g);
    
    for (var i = 0; i < line.length; i++) {
        var t = line[i].split('|');
        
        var struct = new Object();
        struct['name'] = t[0];
        struct['data'] = t[1];
        list[i] = struct;
    }
    
    return list;
}

// Message for Web to App Process
var _USMessage = {
    NoticeDownload : "앱이 설치되어 있지 않을 경우\n설치페이지로 이동합니다.",
    ConfirmDownload : "앱 설치 후 이용 가능합니다.\n설치 페이지로 이동하시겠습니까?",
    NoticeUnsupportedOS : "지원하지 않는 운영체제입니다."
};

// API for UniSign
var UniSignW2A = {
    Scheme : {
        iOS : "unisign-app",
        Android : "crosscert"
    },
    
    Package : {
        Android : "com.crosscert.android"
    },
    
    DownloadURL : {
        iOS : "https://itunes.apple.com/kr/app/gong-in-injeungsenteo/id426081742?mt=8",
        Android : "market://details?id=com.crosscert.android"
    },
    
    AutoCheckInstallation : true,
    UseTopLocation : false,
    
    checkCrossCert : function(uri) {
        if (_USUtil.OS.isAndroid()) {
            alert(_USMessage.NoticeDownload);
            top.location.href = _USUtil.makeIntent(this.Scheme.Android, "init",
                    "isInit", "true");
        } else if (_USUtil.OS.isiOS()) {
            if (false == this.AutoCheckInstallation && null != uri
                    && 0 != uri.length) {
                top.location.href = uri;
                return;
            }
            
            if (null == uri || 0 == uri.length) {
                uri = this.Scheme.iOS + '://?cmd=Main&caller_url_scheme='
                        + location.href + '&callback=01';
            }
            
            var clickedAt = +new Date;
            
            // var checkTimer =
            setTimeout(function() {
                if ((+new Date - clickedAt) < 1600) {
                    // var ret = confirm(_USMessage.ConfirmDownload);
                    // console.log('confirm result : ' + ret);
                    
                    // if(true == ret) {
                    // if(confirm(_USMessage.ConfirmDownload)) {
                    UniSignW2A.moveToStore();
                    // } else {
                    // console.debug('confirm cancel');
                    // }
                }
            }, 1500);
            
            top.location.href = uri;
        } else {
            alert(_USMessage.NoticeUnsupportedOS);
        }
    },
    
    getLicenseInfo : function(retURL) {
        if (_USUtil.OS.isAndroid()) {
            var intent = _USUtil.makeIntent(this.Scheme.Android, "licenseinfo",
                    "requestCode", "2", "retURL", retURL);
            top.location.href = intent;
        } else if (_USUtil.OS.isiOS()) {
            var customScheme = _USUtil.makeCustomScheme(this.Scheme.iOS,
                    "LicenseInfo", "caller_url_scheme", retURL, "callback",
                    "01");
            this.checkCrossCert(customScheme);
        } else {
            alert(_USMessage.NoticeUnsupportedOS);
        }
    }
};

// Utility for UniSign and VeriSign
var _USUtil = {
    OS : {
        UserAgent : {
            Android_Phone : "Android",
            Android_Pad : "Android",
            iPhone : "iPhone",
            iPad : "iPad"
        },
        
        isAndroid : function() {
            if (-1 < navigator.userAgent.indexOf(this.UserAgent.Android_Phone)) {
                return true;
            } else {
                return false;
            }
        },
        
        isiOS : function() {
            if ((-1 < navigator.userAgent.indexOf(this.UserAgent.iPhone))
                    || -1 < navigator.userAgent.indexOf(this.UserAgent.iPad)) {
                return true;
            } else {
                return false;
            }
        },
        
        isSupported : function() {
            if (this.isAndroid() || this.isiOS()) {
                return true;
            } else {
                return false;
            }
        }
    },
    
    makeIntent : function() {
        if (false === this.OS.isAndroid()) {
            return;
        }
        
        if (4 > arguments.length) {
            return;
        }
        
        var intentScheme = "intent://" + arguments[1];
        var intentQuery = "";
        
        for (var i = 1; i * 2 < arguments.length; i++) {
            if (0 >= intentQuery.length) {
                intentQuery += "?" + arguments[i * 2] + "="
                        + arguments[i * 2 + 1];
            } else {
                intentQuery += "&" + arguments[i * 2] + "="
                        + arguments[i * 2 + 1];
            }
        }
        
        var intentAttribute = "";
        
        if (UniSignW2A.Scheme.Android === arguments[0]) {
            // intentAttribute = "#Intent;scheme=" + UniSignW2A.Scheme.Android +
            // ";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="
            // + UniSignW2A.Package.Android + ";end";
            intentAttribute = "#Intent;";
            intentAttribute = intentAttribute + "package="
                    + UniSignW2A.Package.Android + ";";
            intentAttribute = intentAttribute
                    + "action=android.intent.action.VIEW;";
            intentAttribute = intentAttribute
                    + "category=android.intent.category.BROWSABLE;";
            intentAttribute = intentAttribute
                    + "component="
                    // + "com.crosscert.android/com.crosscert.android.esign.ESign1CertList"
                    + "com.crosscert.android/com.crosscert.android.license.LicenseInfo"
                    + ";";
            intentAttribute = intentAttribute + "scheme="
                    + UniSignW2A.Scheme.Android + ";";
            intentAttribute = intentAttribute + "end;";
        } else if (VeriSign.Scheme.Android === arguments[0]) {
            intentAttribute = "#Intent;scheme="
                    + VeriSign.Scheme.Android
                    + ";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="
                    + VeriSign.Package.Android + ";end";
        } else {
            return;
        }
        
        return intentScheme + intentQuery + intentAttribute;
    },
    
    makeFIDOIntent : function() {
        if (false === this.OS.isAndroid()) {
            return;
        }
        
        if (4 > arguments.length) {
            return;
        }
        
        var intentScheme = "intent://FIDO";
        var intentQuery = "";
        
        for (var i = 1; i * 2 < arguments.length; i++) {
            if (0 >= intentQuery.length) {
                intentQuery += "?product_type=" + arguments[1] + "&"
                        + arguments[i * 2] + "=" + arguments[i * 2 + 1];
            } else {
                intentQuery += "&" + arguments[i * 2] + "="
                        + arguments[i * 2 + 1];
            }
        }
        
        var intentAttribute = "";
        
        if (UniSignW2A.Scheme.Android === arguments[0]) {
            // intentAttribute = "#Intent;scheme=" + UniSignW2A.Scheme.Android +
            // ";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="
            // + UniSignW2A.Package.Android + ";end";
            intentAttribute = "#Intent;";
            intentAttribute = intentAttribute + "package="
                    + UniSignW2A.Package.Android + ";";
            intentAttribute = intentAttribute
                    + "action=android.intent.action.VIEW;";
            intentAttribute = intentAttribute
                    + "category=android.intent.category.BROWSABLE;";
            intentAttribute = intentAttribute
                    + "component="
                    + "com.crosscert.android/com.crosscert.android.esign.ESign1CertList"
                    + ";";
            intentAttribute = intentAttribute + "scheme="
                    + UniSignW2A.Scheme.Android + ";";
            intentAttribute = intentAttribute + "end;";
        } else if (VeriSign.Scheme.Android === arguments[0]) {
            intentAttribute = "#Intent;scheme="
                    + VeriSign.Scheme.Android
                    + ";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="
                    + VeriSign.Package.Android + ";end";
        } else {
            return;
        }
        
        return intentScheme + intentQuery + intentAttribute;
    },
    
    makePINPADIntent : function() {
        if (false === this.OS.isAndroid()) {
            return;
        }
        
        if (4 > arguments.length) {
            return;
        }
        
        var intentScheme = "intent://FIDO";
        var intentQuery = "";
        
        for (var i = 1; i * 2 < arguments.length; i++) {
            if (0 >= intentQuery.length) {
                intentQuery += "?product_type=" + arguments[1] + "&"
                        + arguments[i * 2] + "=" + arguments[i * 2 + 1];
            } else {
                intentQuery += "&" + arguments[i * 2] + "="
                        + arguments[i * 2 + 1];
            }
        }
        
        var intentAttribute = "";
        
        if (UniSignW2A.Scheme.Android === arguments[0]) {
            // intentAttribute = "#Intent;scheme=" + UniSignW2A.Scheme.Android +
            // ";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="
            // + UniSignW2A.Package.Android + ";end";
            intentAttribute = "#Intent;";
            intentAttribute = intentAttribute + "package="
                    + UniSignW2A.Package.Android + ";";
            intentAttribute = intentAttribute
                    + "action=android.intent.action.VIEW;";
            intentAttribute = intentAttribute
                    + "category=android.intent.category.BROWSABLE;";
            intentAttribute = intentAttribute
                    + "component="
                    + "com.crosscert.android/com.crosscert.android.esign.ESign1CertList"
                    + ";";
            intentAttribute = intentAttribute + "scheme="
                    + UniSignW2A.Scheme.Android + ";";
            intentAttribute = intentAttribute + "end;";
        } else if (VeriSign.Scheme.Android === arguments[0]) {
            intentAttribute = "#Intent;scheme="
                    + VeriSign.Scheme.Android
                    + ";action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package="
                    + VeriSign.Package.Android + ";end";
        } else {
            return;
        }
        
        return intentScheme + intentQuery + intentAttribute;
    },
    
    makeCustomScheme : function() {
        if (false === _USUtil.OS.isiOS()) {
            return;
        }
        
        if (4 > arguments.length) {
            return;
        }
        
        var customScheme = arguments[0] + "://?cmd=" + arguments[1];
        var customSchemeQuery = "";
        // alert('customScheme : '+customScheme);
        for (var i = 1; i * 2 < arguments.length; i++) {
            customSchemeQuery += "&" + arguments[i * 2] + "="
                    + arguments[i * 2 + 1];
        }
        
        var customSchemeAttribute = "";
        
        return customScheme + customSchemeQuery + customSchemeAttribute;
    },
    
    makeFIDOScheme : function() {
        /*
         * if (false === _USUtil.OS.isiOS()) { return; }
         * 
         * if (4 > arguments.length) { return; }
         */

        var customScheme = arguments[0] + "://?product_type=" + arguments[1];
        var customSchemeQuery = "";
        // alert('customScheme : '+customScheme);
        for (var i = 1; i * 2 < arguments.length; i++) {
            customSchemeQuery += "&" + arguments[i * 2] + "="
                    + arguments[i * 2 + 1];
        }
        
        var customSchemeAttribute = "";
        
        return customScheme + customSchemeQuery + customSchemeAttribute;
    },
    
    makePINPADScheme : function() {
        if (false === _USUtil.OS.isiOS()) {
            return;
        }
        
        if (4 > arguments.length) {
            return;
        }
        
        var customScheme = arguments[0] + "://?product_type=" + arguments[1];
        var customSchemeQuery = "";
        // alert('customScheme : '+customScheme);
        for (var i = 1; i * 2 < arguments.length; i++) {
            customSchemeQuery += "&" + arguments[i * 2] + "="
                    + arguments[i * 2 + 1];
        }
        
        var customSchemeAttribute = "";
        
        return customScheme + customSchemeQuery + customSchemeAttribute;
    },
    
    getQueryVariable : function(variable) {
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        for (var i = 0; i < vars.length; i++) {
            if (0 < vars[i].indexOf("=")) {
                if (variable == vars[i].substring(0, vars[i].indexOf("="))) {
                    return vars[i].substring(vars[i].indexOf("=") + 1,
                            vars[i].length);
                }
            }
        }
        return null;
    },
    
    encodeUrl : function(str) {
        return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');
    },
    
    Base64 : {
        // private property
        _keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
        // public method for encoding
        encode : function(input) {
            var output = "";
            var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            var i = 0;
            input = this._utf8_encode(input);
            while (i < input.length) {
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);
                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;
                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                }
                output = output + this._keyStr.charAt(enc1)
                        + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3)
                        + this._keyStr.charAt(enc4);
            }
            return output;
        },
        // public method for decoding
        decode : function(input) {
            var output = "";
            var chr1, chr2, chr3;
            var enc1, enc2, enc3, enc4;
            var i = 0;
            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
            while (i < input.length) {
                enc1 = this._keyStr.indexOf(input.charAt(i++));
                enc2 = this._keyStr.indexOf(input.charAt(i++));
                enc3 = this._keyStr.indexOf(input.charAt(i++));
                enc4 = this._keyStr.indexOf(input.charAt(i++));
                chr1 = (enc1 << 2) | (enc2 >> 4);
                chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                chr3 = ((enc3 & 3) << 6) | enc4;
                output = output + String.fromCharCode(chr1);
                if (enc3 != 64) {
                    output = output + String.fromCharCode(chr2);
                }
                if (enc4 != 64) {
                    output = output + String.fromCharCode(chr3);
                }
            }
            output = this._utf8_decode(output);
            return output;
        },
        // private method for UTF-8 encoding
        _utf8_encode : function(string) {
            string = string.replace(/\r\n/g, "\n");
            var utftext = "";
            for (var n = 0; n < string.length; n++) {
                var c = string.charCodeAt(n);
                if (c < 128) {
                    utftext += String.fromCharCode(c);
                } else if ((c > 127) && (c < 2048)) {
                    utftext += String.fromCharCode((c >> 6) | 192);
                    utftext += String.fromCharCode((c & 63) | 128);
                } else {
                    utftext += String.fromCharCode((c >> 12) | 224);
                    utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                    utftext += String.fromCharCode((c & 63) | 128);
                }
            }
            return utftext;
        },
        // private method for UTF-8 decoding
        _utf8_decode : function(utftext) {
            var string = "";
            var i = 0;
            var c = c1 = c2 = 0;
            while (i < utftext.length) {
                c = utftext.charCodeAt(i);
                if (c < 128) {
                    string += String.fromCharCode(c);
                    i++;
                } else if ((c > 191) && (c < 224)) {
                    c2 = utftext.charCodeAt(i + 1);
                    string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                    i += 2;
                } else {
                    c2 = utftext.charCodeAt(i + 1);
                    c3 = utftext.charCodeAt(i + 2);
                    string += String.fromCharCode(((c & 15) << 12)
                            | ((c2 & 63) << 6) | (c3 & 63));
                    i += 3;
                }
            }
            return string;
        }
    }
};
