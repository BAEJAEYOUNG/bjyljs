
var gSpCd = "P0003";
var gCustId = "C000062";
var gServId = "S00000060";

console.log('gSpCd', gSpCd);
console.log('gCustId', gCustId);
console.log('gServId', gServId);

/* server url */
//var _RELAY_SERVER_URL = "https://fidotestserver.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(test)
var _RELAY_SERVER_URL = "https://auth.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(test : 20190201-전자인증정병주리더요청)
var _VERIFY_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";            // 전자서명 검증서버 URL(test)
var _FIDO_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";              // FIDO서버 URL(test)

//var _RELAY_SERVER_URL   = "https://pcsprelay3.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(real)
//var _FIDO_SERVER_URL    = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";           // FIDO서버 URL(real)
//var _VERIFY_SERVER_URL  = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";           // 전자서명 검증서버 URL(real)

/* 샘플페이지에 입력 해야 할 정보 */
// ANDROID App Key 정보


//Real
var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuiILi+oWulJaJjYS7fAQtNj08OidqAiE/IRcqDyM1FzsiNi8WCxsHBQ4NaHdhdXNke2ticnJlZWF7c3R2YnRxYTMHYXN0a2R+e3phfHd0Z2JrYx1wdhkoIHoWIygJFnIdHwsVDHMDEx4KKBY/Enh+';
var _APPKEY_IOS     = 'FjwmADokKwE5LTs3FSY8KyYuiILi+oWulJaJjYS7fCwMAWADJjAtBjsNOTMRJz4gPwcBGgAKAhx5fH91fHZndHNkdmFrbndiZXR4cXV4LxFxYn5qY3B2Y3B9cWd0amNhcxx8YBg/HxoeIgMkJmF8aiIadzQFLy44Nip8Anhz';

//var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuiILi+oWulJaJjYS7LxANGxwaFA1oYGd1cXN3eGZ9cGt2fmFzdGpkdXtzORphdXJrf2JgcmFkcH1tc2EIZHQsKDMwEQYQZy4hIXIILGUwDxcYKzUPNjoFcXQ=';   // 타임라이선스(테스트)
//var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl5eHN8emJ1cmp7YWJud2Jle3l7d3wvEXFifmRicnZicHptcmF+dwknByoqLywIOhYtMDMyDzE9LwElHhoKPxUdLRh+eA==';   // 타임라이선스(테스트)
/* var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuiILi+vjo7PqP7fuIk4n2ojMGHQoWGxMCZHB3emp3c2p8YWN2dn9mfHh0dXdicT8UfXdiZ3V2GCgcJjwyFh01OisFChYpGAA1MXAvBSdyACEVJG5+'; */

//IOS App Key 정보
//var _APPKEY_IOS = 'FjwmADokKwE5LTs3FSY8KyYuiILi+oWulJaJjYS7LxANGxwaFA1oYGd1cXN3eGZ9cGt2fmFzdGpkdXtzORphdXJrf2JgcmFkcH1tc2EIZHQsKDMwEQYQZy4hIXIILGUwDxcYKzUPNjoFcXQ=';   // 타임라이선스(테스트)
//var _APPKEY_IOS = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl5eHN8emJ1cmp7YWJud2Jle3l7d3wvEXFifmRicnZicHptcmF+dwknByoqLywIOhYtMDMyDzE9LwElHhoKPxUdLRh+eA==';   // 타임라이선스(테스트)
/* var _APPKEY_IOS = 'FjwmADokKwE5LTs3FSY8KyYuiILi+vjo7PqP7fuIk4n2ojMGHQoWGxMCZHVwfmF8d2p7ZGBxfH9mfHh0dXdicT8UfXdiZ3V2GCgcJjwyZnMEPBtqHis2E2YvMQJ8FBcADQd/JG5+'; */

var _FIDO_SERVICE_NAME = "SDU"; // 업체 구분(영문약자)

console.log('_RELAY_SERVER_URL', _RELAY_SERVER_URL);
console.log('_VERIFY_SERVER_URL', _VERIFY_SERVER_URL);
console.log('_FIDO_SERVER_URL', _FIDO_SERVER_URL);
console.log('_APPKEY_ANDROID', _APPKEY_ANDROID);
console.log('_APPKEY_IOS', _APPKEY_IOS);
console.log('_FIDO_SERVICE_NAME', _FIDO_SERVICE_NAME);