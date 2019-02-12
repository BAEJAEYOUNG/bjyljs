
var gSpCd = "P0003";
var gCustId = "C000022";
var gServId = "S00000040";

console.log('gSpCd', gSpCd);
console.log('gCustId', gCustId);
console.log('gServId', gServId);

var _FIDO_SERVICE_NAME = "OCUCONS"; // 업체 구분(영문약자)

/* server url */
//var _RELAY_SERVER_URL = "https://fidotestserver.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(test)
//var _VERIFY_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";                 // 전자서명 검증서버 URL(test)
//var _FIDO_SERVER_URL = "https://fidotestserver.crosscert.com:8080/RPS/svc/v2/Interface";           // FIDO서버 URL(real)

var _RELAY_SERVER_URL   = "https://pcsprelay3.crosscert.com:9090/MRS/bo/spi/ReqSPIInterface.do";    // 푸쉬서비스 중계서버 URL(real)
var _FIDO_SERVER_URL    = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";           // FIDO서버 URL(real)
var _VERIFY_SERVER_URL  = "https://fidoserver3.crosscert.com:9443/fido/svc/v2/Interface";           // 전자서명 검증서버 URL(real)

/* 샘플페이지에 입력 해야 할 정보 */
// Test
//var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl1enV1e2tzdmZ+ZGJud2JldHl1dHcvEXFifmtic3ZicHptcmF+dwknByoqLzk3NjIcHhMiHik0Eh02BScPAGMXGz5+eA==';   // 타임라이선스(테스트)
//var _APPKEY_IOS     = 'FjwmADokKwE5LTs3FSY8KyYu8P7r8/61lIDwtfGllJU/BwEaAAoCHHl1enV1e2tzdmZ+ZGJud2JldHl1dHcvEXFifmtic3ZicHptcmF+dwknByoqLzk3NjIcHhMiHik0Eh02BScPAGMXGz5+eA==';   // 타임라이선스(테스트)

// Real
var _APPKEY_ANDROID = 'FjwmADokKwE5LTs3FSY8KyYuABAGh4TuhvGK/bNhkrP6/I+dkrb5/+699Pk5Gx0MEBsIHX53cWdidHx0cHZrc3t/fWNie3VqZnU1BXdqYmFzdgolYQJ9Lj4hMS8zIDw9aCA5Cx1sNQQBBiZ2HTlueA==';
var _APPKEY_IOS     = 'FjwmADokKwE5LTs3FSY8KyYuABAGh4TuhvGK/bNhkrP6/I+dkrb5/+699Pk5Gx0MEBsIHX5wfGNieHxyc31hcnJ/fWNie3VqZnU1BXdqYmFzdgolYQJ9LjoZGCEKH2ACCQZ4YgAPIDAlIjw5DA9ueA==';

console.log('_FIDO_SERVICE_NAME', _FIDO_SERVICE_NAME);
console.log('_RELAY_SERVER_URL', _RELAY_SERVER_URL);
console.log('_VERIFY_SERVER_URL', _VERIFY_SERVER_URL);
console.log('_FIDO_SERVER_URL', _FIDO_SERVER_URL);
console.log('_APPKEY_ANDROID', _APPKEY_ANDROID);
console.log('_APPKEY_IOS', _APPKEY_IOS);