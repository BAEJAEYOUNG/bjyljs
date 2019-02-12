<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>SDU 지문 인증 서비스 샘플</title>

<script type="text/javascript" src="./jquery/jquery.min-3.1.0.js"></script>

<script type="text/javascript" charset="utf-8">


var mainDomainUrl = "https://bill.ksidmobile.co.kr";   // 빌링서버 기본 정보
// var mainDomainUrl = "http://dev.ksidmobile.co.kr:9100";
//var mainDomainUrl = "http://192.168.2.35:8080";
// var mainDomainUrl = "http://localhost";

var gSpCd   = "P0003";                                  // 서비스 제공자 코드
var gCustId = "C000022";                                // 고객사 코드
var gServId = "S00000040";                              // 서비스 코드


// 서비스 가입 버튼 OnClick Action
function doSvcReg() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 서비스 기본 정보 Parameter 셋팅
    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;


    // 한국스마트아이디 서비스 가입 웹 페이지를 호출한다.
    window.open("about:blank", "regwin", "width=550,height=530");

    var url = mainDomainUrl + "/sdu/userreg";
    document.form1.action = url;
    document.form1.target = "regwin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


//서비스 결제 버튼 OnClick Action
function doSvcPay() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 서비스 기본 정보 Parameter 셋팅
    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;

    // 한국스마트아이디 서비스 결제 웹 페이지를 호출한다.
    window.open("about:blank", "payregwin", "width=550,height=350");

    var url = mainDomainUrl + "/sdu/userpay";
    document.form1.action = url;
    document.form1.target = "payregwin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


//서비스 서비스 해지 버튼 OnClick Action
function doSvcCancel() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 서비스 기본 정보 Parameter 셋팅
    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;

    // 한국스마트아이디 서비스 해지 웹 페이지를 호출한다.
    window.open("about:blank", "cancelwin", "width=550,height=380");
    document.form1.action = mainDomainUrl + "/sdu/usercancel";
    document.form1.target = "cancelwin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


//서비스 서비스 정보 조회 버튼 OnClick Action
function doSvcSearch() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 서비스 기본 정보 Parameter 셋팅
    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;

    // 한국스마트아이디 서비스 정보 조회 웹 페이지를 호출한다.
    window.open("about:blank", "schwin", "width=600,height=370");
    document.form1.action = mainDomainUrl + "/sdu/usersearch";
    document.form1.target = "schwin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}



// PC와 연결 버튼 OnClick Action
function doPhonePushReg() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 서비스 기본 정보 Parameter 셋팅
    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다
    document.form1.custUserNo.value = document.getElementById("userID").value;

    // PC와 연결 화면 호출
    window.open("about:blank", "webPushRegWin", "width=550,height=360");
    document.form1.action = mainDomainUrl + "/sdu/fidoservice/webpushreg";
    document.form1.target = "webPushRegWin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}



//PC와 재연결 버튼 OnClick Action
function doPhonePushChange() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 서비스 기본 정보 Parameter 셋팅
    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;

    // PC와 재연결 화면 호출
    window.open("about:blank", "webPushChgWin", "width=550,height=400");
    document.form1.action = mainDomainUrl + "/sdu/fidoservice/webpushchg";
    document.form1.target = "webPushChgWin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


// 지문 등록 버튼 OnClick Action
function doFidoReg() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 서비스 기본 정보 Parameter 셋팅
    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;

    window.open("about:blank", "webfidoreg", "width=550,height=350");
    document.form1.action = mainDomainUrl + "/sdu/fidoservice/webfidoreg";
    document.form1.target = "webfidoreg";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";

}


// 지문 해지 버튼 OnClick Action
function doFidoDereg() {
    // 샘플 테스트를 위한 부분이므로 실 상용 구현시 배제
    if( document.getElementById("userID").value == "" ) {
        alert("선행 일반 로그인 완료 가정이므로, 학번을 입력해주세요. ");
        return;
    }

    // 서비스 기본 정보 Parameter 셋팅
    document.form1.spCd.value   = gSpCd;
    document.form1.custId.value = gCustId;
    document.form1.servId.value = gServId;

    // OCU 로 부터 학번 정보를 입력 받아 셋팅한다.
    document.form1.custUserNo.value = document.getElementById("userID").value;

     // 지문 해지 화면 호출
    window.open("about:blank", "webfidodereg", "width=550,height=350");
    document.form1.action = mainDomainUrl + "/sdu/fidoservice/webfidodereg";
    document.form1.target = "webfidodereg";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


//지문 로그인 버튼 OnClick Action
function doFidoLogin() {
    // 한국스마트아이디 지문 로그인 웹 페이지를 호출한다.
    window.open("about:blank", "sdumainlogin");
    document.form1.action = mainDomainUrl + "/fidoservice/sdumainlogin.jsp";
    document.form1.target = "sdumainlogin";
    document.form1.submit();
    document.form1.action = "";
    document.form1.target = "";
}


</script>
</head>
<body>
<form name="form1" action=""  method="post">
<input type="hidden" name="spCd" value=""/>
<input type="hidden" name="custId" value=""/>
<input type="hidden" name="servId" value=""/>
<input type="hidden" name="custUserNo" value=""/>
<div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 650px;">
       <p>
            &nbsp;&nbsp;&nbsp;&nbsp;
            학번 : <input type="text" maxlength="16" id="userID" name="userID" />&nbsp;&nbsp;&nbsp;&nbsp;
        </p>
    </div>
    <div>
        <p><b> SDU 지문 서비스 샘플 이용 안내 </b></p>
    </div>
    <div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 650px;">
        <p>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="svcReg" onclick="doSvcReg()">서비스 가입</button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="svcPay" onclick="doSvcPay()">서비스 결제</button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="phonePushReg" onclick="doPhonePushReg()">PC와 연결</button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="fidoReg" onclick="doFidoReg()">지문 등록</button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="fidoLogin" onclick="doFidoLogin()">지문 로그인</button>


        </p>
    </div>
    </br>
    <div>
        <p><b> SDU 지문 서비스 샘플 FAQ </b></p>
    </div>
    <div style="border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid; padding: 10px; width: 650px;">
        <p>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="svcCancel" onclick="doSvcCancel()">서비스 해지</button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="svcSearch" onclick="doSvcSearch()">서비스 정보 조회</button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="phonePushReg" onclick="doPhonePushChange()">PC와 재연결</button>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" id="fidoCancel" onclick="doFidoDereg()">지문 해지</button>

        </p>
    </div>
</form>
</body>
</html>