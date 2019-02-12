package ksid.biz.cnspay.web;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.lgcns.module.lite.CnsPayWebConnector4NS;
import ksid.biz.cnspay.service.impl.CnsPayDao;
import ksid.biz.devauth.mobileauth.service.impl.MobileAuthDao;
import ksid.biz.registration.user.service.UserService;
import ksid.core.webmvc.base.web.BaseController;
import ksid.core.webmvc.util.ConstantDefine;
import ksid.core.webmvc.util.DateLib;
import ksid.core.webmvc.util.OsUtilLib;
import ksid.core.webmvc.util.StringLib;

@Controller
@RequestMapping(value= {"cnspay"})
public class CnsPayController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(CnsPayController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private CnsPayDao cnsPayDao;

    @Autowired
    private MobileAuthDao mobileAuthDao;

    @Resource(name = "protocol")
    public Properties protocol;

    @RequestMapping(value= {"request"})
    public String viewRequest(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CnsPayController.viewRequest refresh param [{}]", param);
        Map<String, Object> resultParam = new HashMap<String, Object>();

        resultParam = mobileAuthDao.selectPayReqInfo(param);

        resultParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
        resultParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        resultParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
        resultParam.put( "payFinalUrl", StringUtils.defaultString((String)param.get("payFinalUrl")) );

        resultParam.put( "custUserNo", StringUtils.defaultString((String)param.get("custUserNo")) );

        logger.debug("CnsPayController.viewRequest resultParam [{}]", resultParam);

        model.addAttribute("resultData", resultParam);

        return "billing/pay/payRequest";
    }

    @RequestMapping(value= {"result"})
    public String viewResult(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

//        if(true) return "billing/pay/payResult";
        String resultStr = "";
        Map<String, Object> recvParam = new HashMap<String, Object>();

        logger.debug("PayController.viewResult param [{}]", param);

        // 모듈이 설치되어 있는 경로 설정
        CnsPayWebConnector4NS connector = new CnsPayWebConnector4NS();

        // 1. 로그 디렉토리 생성 : cnsPayHome/log 로 생성
        //connector.setLogHome("가맹점의 로그파일 생성 위치");
        //connector.setCnsPayHome("cnspay.properties파일 위치");
        String cnspayHomeDir="";
        String cnspayLogDir ="";
        Map<String, Object> rparam = new HashMap<String, Object>();
        rparam.put("codeGroupCd", "CNSPAY_HOME_DIR");

        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                rparam.put("codeCd", "PC");
                cnspayHomeDir = "d:/ksid/app/cnspay/pay";
                cnspayLogDir  = "d:/ksid/app/cnspay/pay/log";
                break;
            case MAC:
                logger.info("=====> getOS MAC");
                rparam.put("codeCd", "MAC");
                cnspayHomeDir = "/Users/skyamigo/Tmp/cnspay";
                cnspayLogDir  = "/Users/skyamigo/Tmp/cnspay/log";
                break;
            case LINUX:
            default :
                logger.info("=====> getOS LINUX");
                rparam.put("codeCd", "SERVER");
                cnspayHomeDir = "/domain/files/cnspay/pay";
                cnspayLogDir  = "/domain/files/cnspay/pay/log";
                break;
        }
        //Cnspay Home
        Map<String, Object> cnsPayHomeData = cnsPayDao.getCnspayDir(rparam);
        if(cnsPayHomeData != null) {
            cnspayHomeDir = StringUtils.defaultString((String)cnsPayHomeData.get("codeNm"));
        }

        rparam.put("codeGroupCd", "CNSPAY_LOG_DIR");
        Map<String, Object> cnsPayLogData = cnsPayDao.getCnspayDir(rparam);
        if(cnsPayLogData != null) {
            cnspayLogDir = StringUtils.defaultString((String)cnsPayLogData.get("codeNm"));
        }
        logger.debug("CnsPayCancelController cnspayHomeDir[{}] cnspayLogDir[{}]", cnspayHomeDir, cnspayLogDir);
        connector.setLogHome(cnspayLogDir);
        connector.setCnsPayHome(cnspayHomeDir);

        // 2. 요청 페이지 파라메터 셋팅
        connector.setRequestData(request);

        // 3. 추가 파라메터 셋팅
        connector.addRequestData("actionType", "PY0");  // actionType : CL0 취소, PY0 승인
        connector.addRequestData("MallIP",     request.getRemoteAddr());    // 상점 고유 ip
//        connector.addRequestData("CancelPwd",  "123456");
        connector.addRequestData("LogoURL",    "https://kmpay.lgcns.com:8443");

        // 가맹점키 셋팅 (MID 별로 틀림)
        String EncodeKey = "33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==";

        // 4. CNSPAY Lite 서버 접속하여 처리
        connector.requestAction();

        // 5-1. 처리 결과(공통)
        recvParam.put( "resultCode",    connector.getResultData("ResultCode") );       // 결과코드

        logger.debug("resultCode : [{}]", recvParam.get("resultCode"));
        String resultCode = connector.getResultData("ResultCode");

        //2017-05-10 : jiyun - 환경 설정문제시 에러체크
        boolean checkResultDataOK = true;
        if( "JL01".equals(resultCode) ) { //CnsPayHome directory 설정 오류입니다.
            checkResultDataOK = false;
        } else if( "JL02".equals(resultCode) ) {  //로그 설정 중 오류가 발생했습니다.
            checkResultDataOK = false;
        } else if( "JL10".equals(resultCode) ) {  //actionType 설정이 잘못되었습니다.
            checkResultDataOK = false;
        } else if( "JL11".equals(resultCode) ) {  //요청페이지 파라메터가 잘못되었습니다.
            checkResultDataOK = false;
        } else if( "JL20".equals(resultCode) ) {  //전문생성중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL30".equals(resultCode) ) {  //PGWEB서버 통신중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL31".equals(resultCode) ) {  //PGWEB서버 통신중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL40".equals(resultCode) ) {  //응답전문 처리 중 오류가 발생하였습니다.
            checkResultDataOK = false;
        }

        recvParam.put( "resultMsg",     connector.getResultData("ResultMsg") );        // 결과메시지
        recvParam.put( "tid",           connector.getResultData("TID") );              // 거래ID
        recvParam.put( "moid",          connector.getResultData("Moid") );             // 주문번호
        recvParam.put( "mid",           connector.getResultData("MID") );              // 상점ID
        recvParam.put( "payMethod",     connector.getResultData("PayMethod") );        // 결제수단
        recvParam.put( "amt",           connector.getResultData("Amt") );              // 금액
        recvParam.put( "authDate",      connector.getResultData("AuthDate") );         // 승인일시  YYMMDDHH24mmss
        logger.debug("authDate : [{}]", recvParam.get("authDate"));
        recvParam.put( "authCode",      connector.getResultData("AuthCode") );         // 승인번호
        recvParam.put( "buyerName",     connector.getResultData("BuyerName") );        // 구매자명
        recvParam.put( "mallUserID",    connector.getResultData("MallUserID") );       // 회원사고객ID
        recvParam.put( "goodsName",     connector.getResultData("GoodsName") );        // 상품명

        // 5-2. 처리 결과(신용카드)
        recvParam.put( "cardCode",      connector.getResultData("CardCode") );         // 카드사 코드
        recvParam.put( "cardName",      connector.getResultData("CardName") );         // 결제카드사명
        recvParam.put( "cardQuota",     connector.getResultData("CardQuota") );        // 할부개월(00:일시불,02:2개월)

        recvParam.put( "cardBin",       connector.getResultData("cardBin") );          // 카드BIN
        recvParam.put( "cardPoint",     connector.getResultData("cardPoint") );        // 카드사포인트(0:미사용,1:포인트사용,2:세이브포인트사용)
        recvParam.put( "vanCode",       connector.getResultData("vanCode") );          // 밴코드(01(나이스),04(코밴),05(스마트로),06(신한직승인),07(다우))

        // 5-3. 처리 결과(계좌이체)
        recvParam.put( "bankCode",      connector.getResultData("BankCode") );          // 은행 코드
        recvParam.put( "bankName",      connector.getResultData("BankName") );          // 은행명
        recvParam.put( "rcptType",      connector.getResultData("RcptType") );          // 현금 영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
        recvParam.put( "rcptAuthCode",  connector.getResultData("RcptAuthCode") );      // 현금영수증 승인 번호
        recvParam.put( "rcptTID",       connector.getResultData("RcptTID") );           // 현금 영수증 TID

        // 5-4. 처리 결과(휴대폰)
        recvParam.put( "carrier",       connector.getResultData("Carrier") );           // 이통사구분
        recvParam.put( "dstAddr",       connector.getResultData("DstAddr") );           // 휴대폰번호

        // 5-5. 처리 결과(가상계좌)
        recvParam.put( "vbankBankCode", connector.getResultData("vbankBankCode") );     // 가상계좌은행코드
        recvParam.put( "vbankBankName", connector.getResultData("vbankBankName") );     // 가상계좌은행명
        recvParam.put( "vbankNum",      connector.getResultData("vbankNum") );              // 가상계좌번호
        recvParam.put( "vbankExpDate",  connector.getResultData("VbankExpDate") );      // 가상계좌입금예정일
        recvParam.put( "vbankExpTime",  connector.getResultData("VbankExpTime") );      // 가상계좌입금예정일시분

        boolean paySuccess = false; // 결제 성공 여부

        /** 위의 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능 */
        if( recvParam.get("payMethod").equals("CARD") ) {
            if( recvParam.get("resultCode").equals("3001") )
                paySuccess = true;                                      // 결과코드 (정상 :3001 , 그 외 에러)
        }
        else if( recvParam.get("payMethod").equals("BANK") ) {
            if( recvParam.get("resultCode").equals("4000") )
                paySuccess = true;                                      // 결과코드 (정상 :4000 , 그 외 에러)
        }
        else if( recvParam.get("payMethod").equals("CELLPHONE") ) {
            if( recvParam.get("resultCode").equals("A000") )
                paySuccess = true;                                      // 결과코드 (정상 : A000, 그 외 비정상)
        }
        else if( recvParam.get("payMethod").equals("VBANK") ) {
            if( recvParam.get("resultCode").equals("4100") )
                paySuccess = true;                                      // 결과코드 (정상 :4100 , 그 외 에러)
        }

        recvParam.put( "spCd",   param.get("spCd") );
        recvParam.put( "custId", param.get("custId") );
        recvParam.put( "servId", param.get("servId") );
        recvParam.put( "payFinalUrl", StringUtils.defaultString((String)param.get("payFinalUrl")) );
        recvParam.put( "custUserNo", param.get("CustUserNo") );

        String parseTelNo = (String) param.get("BuyerTel");
        recvParam.put( "telNo", parseTelNo.replaceAll("-", "") );

        Map<String, Object> selData = cnsPayDao.selectPgUserIdGetJob( recvParam );
        String retValue = (String) selData.get( "retValue" );
        if( !retValue.equals(ConstantDefine.SQL_ROK) ) {
            logger.debug("selectPgUserIdGetJob userID, userNm, custUserNo Get Fail");
        }

        recvParam.put( "userId",     StringUtils.defaultString((String) selData.get("userId")) );
        recvParam.put( "userNm",     StringUtils.defaultString((String)selData.get("userNm")) );
        recvParam.put( "custUserNo", StringUtils.defaultString((String)selData.get("custUserNo")) );
        recvParam.put( "mpOsTp",     StringUtils.defaultString((String)selData.get("mpOsTp")) );

        logger.debug("spCd       : [{}]", recvParam.get("spCd"));
        logger.debug("custId     : [{}]", recvParam.get("custId"));
        logger.debug("servId     : [{}]", recvParam.get("servId"));
        logger.debug("telNo      : [{}]", recvParam.get("telNo"));
        logger.debug("userId     : [{}]", recvParam.get("userId"));
        logger.debug("userNm     : [{}]", recvParam.get("userNm"));
        logger.debug("custUserNo : [{}]", recvParam.get("custUserNo"));
        logger.debug("mpOsTp     : [{}]", recvParam.get("mpOsTp"));

        //2017-05-10 : jiyun - 무조건 DB Insert (환경설정에 문제시 result 값에 필수필드가 없음)
        if (checkResultDataOK) {
            resultStr = cnsPayDao.insertTbgRawPgApprGtrDataJob( recvParam );
            String cardQuota = connector.getResultData("CardQuota");
            if( cardQuota.equals("00") ) {
                recvParam.put( "cardQuota", "일시불" );
            }
            else {
                recvParam.put( "cardQuota", connector.getResultData("CardQuota") );        // 할부개월(00:일시불,02:2개월)
            }
        }

        if (paySuccess) {
            //결제 성공시 DB처리 하세요.
            //2017-05-10 : jiyun - 결제 프로시져 호출 (regServPg)
            Map<String, Object> dbParam = new HashMap<String, Object>();
            dbParam.put("spCd"       , recvParam.get("spCd"));
            dbParam.put("custId"     , recvParam.get("custId"));
            dbParam.put("servId"     , recvParam.get("servId"));
            dbParam.put("mpNo"       , recvParam.get("telNo"));
            dbParam.put("payTid"     , recvParam.get("tid"));
            dbParam.put("payMethod"  , recvParam.get("payMethod"));
            dbParam.put("userId"     , recvParam.get("userId"));
            dbParam.put("custUserNo" , recvParam.get("custUserNo"));

            String strResult = this.userService.callProc("joinServPayPg", dbParam);
            logger.debug("userService.joinServPayPg strResult {}", strResult);

            String[] arrResult = strResult.split("\\|");
            if( "00".equals(arrResult[0]) ) {
                model.addAttribute("resultCd", "00");
//                model.addAttribute("resultData", "정상처리 되었습니다 !");
            } else {
                model.addAttribute("resultCd", arrResult[0]);
                model.addAttribute("resultData", arrResult[1]);
            }

            String rstStr = mobileAuthDao.mmsSendMessage( recvParam );
            if( !rstStr.equals( ConstantDefine.SQL_ROK ) ) {
                logger.debug("MMS Message Send Fail", strResult);
            }

        } else {
            // 결제 실패시 DB처리 하세요.
        }

        model.addAttribute("resultData", recvParam);

        return "billing/pay/payResult";
    }


    @RequestMapping(value= {"oidGet"})
    public String orderIddGet(@RequestParam Map<String, Object> param, Model model) {
       String resultStr = "";

       resultStr = cnsPayDao.selectPgOrderIdGetJob();

       logger.debug("resultStr : [{}]", resultStr);
       model.addAttribute("resultCd", resultStr);
       return "json";
    }

    @RequestMapping(value= {"mainMenuList"})
    public String mainMenuList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PayController.mainMenuList param [{}]", param);

//        List<Map<String, Object>> resultData = this.payService.selDataList(param);
//
//        logger.debug("PayController.mainMenuList resultData [{}]", resultData);

//        model.addAttribute("resultCd", "00");
//        model.addAttribute("resultData", resultData);

        return "json";
    }

    //모바일 결제페이지
    @RequestMapping(value= {"requestM"})
    public String viewRequestM(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CnsPayController.viewRequestM param [{}]", param);
        Map<String, Object> resultParam = new HashMap<String, Object>();

        resultParam = mobileAuthDao.selectPayReqInfo(param);

        resultParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
        resultParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        resultParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
        resultParam.put( "payFinalUrl", StringUtils.defaultString((String)param.get("payFinalUrl")) );
        resultParam.put( "custUserNo", StringUtils.defaultString((String)param.get("custUserNo")) );
        model.addAttribute("resultData", resultParam);

        logger.debug("CnsPayController.viewRequestM payRequestM before [{}]", resultParam);

        return "billing/pay/payRequestM";
    }

    @RequestMapping(value= {"resultM"})
    public String viewResultM(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

//        if(true) return "billing/pay/payResultM";
        String resultStr = "";
        Map<String, Object> recvParam = new HashMap<String, Object>();

        logger.debug("PayController.viewResultM param [{}]", param);

        // 모듈이 설치되어 있는 경로 설정
        CnsPayWebConnector4NS connector = new CnsPayWebConnector4NS();

        // 1. 로그 디렉토리 생성 : cnsPayHome/log 로 생성
        //connector.setLogHome("가맹점의 로그파일 생성 위치");
        //connector.setCnsPayHome("cnspay.properties파일 위치");
        String cnspayHomeDir="";
        String cnspayLogDir ="";
        Map<String, Object> rparam = new HashMap<String, Object>();
        rparam.put("codeGroupCd", "CNSPAY_HOME_DIR");

        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                rparam.put("codeCd", "PC");
                cnspayHomeDir = "d:/ksid/app/cnspay/pay";
                cnspayLogDir  = "d:/ksid/app/cnspay/pay/log";
                break;
            case MAC:
                logger.info("=====> getOS MAC");
                rparam.put("codeCd", "MAC");
                cnspayHomeDir = "/Users/skyamigo/Tmp/cnspay";
                cnspayLogDir  = "/Users/skyamigo/Tmp/cnspay/log";
                break;
            case LINUX:
            default :
                logger.info("=====> getOS LINUX");
                rparam.put("codeCd", "SERVER");
                cnspayHomeDir = "/domain/files/cnspay/pay";
                cnspayLogDir  = "/domain/files/cnspay/pay/log";
                break;
        }
        //Cnspay Home
        Map<String, Object> cnsPayHomeData = cnsPayDao.getCnspayDir(rparam);
        if(cnsPayHomeData != null) {
            cnspayHomeDir = StringUtils.defaultString((String)cnsPayHomeData.get("codeNm"));
        }

        rparam.put("codeGroupCd", "CNSPAY_LOG_DIR");
        Map<String, Object> cnsPayLogData = cnsPayDao.getCnspayDir(rparam);
        if(cnsPayLogData != null) {
            cnspayLogDir = StringUtils.defaultString((String)cnsPayLogData.get("codeNm"));
        }
        logger.debug("CnsPayCancelController cnspayHomeDir[{}] cnspayLogDir[{}]", cnspayHomeDir, cnspayLogDir);
        connector.setLogHome(cnspayLogDir);
        connector.setCnsPayHome(cnspayHomeDir);

        // 2. 요청 페이지 파라메터 셋팅
        connector.setRequestData(request);

        // 3. 추가 파라메터 셋팅
        connector.addRequestData("actionType", "PY0");  // actionType : CL0 취소, PY0 승인
        connector.addRequestData("MallIP",     request.getRemoteAddr());    // 상점 고유 ip
//        connector.addRequestData("CancelPwd",  "123456");
        connector.addRequestData("LogoURL",    "https://kmpay.lgcns.com:8443");

        // 가맹점키 셋팅 (MID 별로 틀림)
        String EncodeKey = "33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==";

        // 4. CNSPAY Lite 서버 접속하여 처리
        connector.requestAction();

        // 5-1. 처리 결과(공통)
        recvParam.put( "resultCode",    connector.getResultData("ResultCode") );       // 결과코드

        logger.debug("resultCode : [{}]", recvParam.get("resultCode"));
        String resultCode = connector.getResultData("ResultCode");

        //2017-05-10 : jiyun - 환경 설정문제시 에러체크
        boolean checkResultDataOK = true;
        if( "JL01".equals(resultCode) ) { //CnsPayHome directory 설정 오류입니다.
            checkResultDataOK = false;
        } else if( "JL02".equals(resultCode) ) {  //로그 설정 중 오류가 발생했습니다.
            checkResultDataOK = false;
        } else if( "JL10".equals(resultCode) ) {  //actionType 설정이 잘못되었습니다.
            checkResultDataOK = false;
        } else if( "JL11".equals(resultCode) ) {  //요청페이지 파라메터가 잘못되었습니다.
            checkResultDataOK = false;
        } else if( "JL20".equals(resultCode) ) {  //전문생성중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL30".equals(resultCode) ) {  //PGWEB서버 통신중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL31".equals(resultCode) ) {  //PGWEB서버 통신중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL40".equals(resultCode) ) {  //응답전문 처리 중 오류가 발생하였습니다.
            checkResultDataOK = false;
        }

        recvParam.put( "resultMsg",     connector.getResultData("ResultMsg") );        // 결과메시지
        recvParam.put( "tid",           connector.getResultData("TID") );              // 거래ID
        recvParam.put( "moid",          connector.getResultData("Moid") );             // 주문번호
        recvParam.put( "mid",           connector.getResultData("MID") );              // 상점ID
        recvParam.put( "payMethod",     connector.getResultData("PayMethod") );        // 결제수단
        recvParam.put( "amt",           connector.getResultData("Amt") );              // 금액
        recvParam.put( "authDate",      connector.getResultData("AuthDate") );         // 승인일시  YYMMDDHH24mmss
        logger.debug("authDate : [{}]", recvParam.get("authDate"));
        recvParam.put( "authCode",      connector.getResultData("AuthCode") );         // 승인번호
        recvParam.put( "buyerName",     connector.getResultData("BuyerName") );        // 구매자명
        recvParam.put( "mallUserID",    connector.getResultData("MallUserID") );       // 회원사고객ID
        recvParam.put( "goodsName",     connector.getResultData("GoodsName") );        // 상품명

        // 5-2. 처리 결과(신용카드)
        recvParam.put( "cardCode",      connector.getResultData("CardCode") );         // 카드사 코드
        recvParam.put( "cardName",      connector.getResultData("CardName") );         // 결제카드사명
        recvParam.put( "cardQuota",     connector.getResultData("CardQuota") );        // 할부개월(00:일시불,02:2개월)

        recvParam.put( "cardBin",       connector.getResultData("cardBin") );          // 카드BIN
        recvParam.put( "cardPoint",     connector.getResultData("cardPoint") );        // 카드사포인트(0:미사용,1:포인트사용,2:세이브포인트사용)
        recvParam.put( "vanCode",       connector.getResultData("vanCode") );          // 밴코드(01(나이스),04(코밴),05(스마트로),06(신한직승인),07(다우))

        // 5-3. 처리 결과(계좌이체)
        recvParam.put( "bankCode",      connector.getResultData("BankCode") );          // 은행 코드
        recvParam.put( "bankName",      connector.getResultData("BankName") );          // 은행명
        recvParam.put( "rcptType",      connector.getResultData("RcptType") );          // 현금 영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
        recvParam.put( "rcptAuthCode",  connector.getResultData("RcptAuthCode") );      // 현금영수증 승인 번호
        recvParam.put( "rcptTID",       connector.getResultData("RcptTID") );           // 현금 영수증 TID

        // 5-4. 처리 결과(휴대폰)
        recvParam.put( "carrier",       connector.getResultData("Carrier") );           // 이통사구분
        recvParam.put( "dstAddr",       connector.getResultData("DstAddr") );           // 휴대폰번호

        // 5-5. 처리 결과(가상계좌)
        recvParam.put( "vbankBankCode", connector.getResultData("vbankBankCode") );     // 가상계좌은행코드
        recvParam.put( "vbankBankName", connector.getResultData("vbankBankName") );     // 가상계좌은행명
        recvParam.put( "vbankNum",      connector.getResultData("vbankNum") );              // 가상계좌번호
        recvParam.put( "vbankExpDate",  connector.getResultData("VbankExpDate") );      // 가상계좌입금예정일
        recvParam.put( "vbankExpTime",  connector.getResultData("VbankExpTime") );      // 가상계좌입금예정일시분

        boolean paySuccess = false; // 결제 성공 여부

        /** 위의 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능 */
        if( recvParam.get("payMethod").equals("CARD") ) {
            if( recvParam.get("resultCode").equals("3001") )
                paySuccess = true;                                      // 결과코드 (정상 :3001 , 그 외 에러)
        }
        else if( recvParam.get("payMethod").equals("BANK") ) {
            if( recvParam.get("resultCode").equals("4000") )
                paySuccess = true;                                      // 결과코드 (정상 :4000 , 그 외 에러)
        }
        else if( recvParam.get("payMethod").equals("CELLPHONE") ) {
            if( recvParam.get("resultCode").equals("A000") )
                paySuccess = true;                                      // 결과코드 (정상 : A000, 그 외 비정상)
        }
        else if( recvParam.get("payMethod").equals("VBANK") ) {
            if( recvParam.get("resultCode").equals("4100") )
                paySuccess = true;                                      // 결과코드 (정상 :4100 , 그 외 에러)
        }

        recvParam.put( "spCd",   param.get("spCd") );
        recvParam.put( "custId", param.get("custId") );
        recvParam.put( "payFinalUrl", StringUtils.defaultString((String)param.get("payFinalUrl")) );
        recvParam.put( "payFinalUrl", param.get("payFinalUrl") );
        recvParam.put( "custUserNo", param.get("CustUserNo") );

        String parseTelNo = (String) param.get("BuyerTel");
        recvParam.put( "telNo", parseTelNo.replaceAll("-", "") );

        Map<String, Object> selData = cnsPayDao.selectPgUserIdGetJob( recvParam );
        String retValue = (String) selData.get( "retValue" );
        if( !retValue.equals(ConstantDefine.SQL_ROK) ) {
            logger.debug("selectPgUserIdGetJob userID, userNm, custUserNo Get Fail");
        }

        recvParam.put( "userId",     StringUtils.defaultString((String) selData.get("userId")) );
        recvParam.put( "userNm",     StringUtils.defaultString((String)selData.get("userNm")) );
        recvParam.put( "custUserNo", StringUtils.defaultString((String)selData.get("custUserNo")) );
        recvParam.put( "mpOsTp",     StringUtils.defaultString((String)selData.get("mpOsTp")) );

        logger.debug("spCd       : [{}]", recvParam.get("spCd"));
        logger.debug("custId     : [{}]", recvParam.get("custId"));
        logger.debug("servId     : [{}]", recvParam.get("servId"));
        logger.debug("telNo      : [{}]", recvParam.get("telNo"));
        logger.debug("userId     : [{}]", recvParam.get("userId"));
        logger.debug("userNm     : [{}]", recvParam.get("userNm"));
        logger.debug("custUserNo : [{}]", recvParam.get("custUserNo"));
        logger.debug("mpOsTp     : [{}]", recvParam.get("mpOsTp"));

        //2017-05-10 : jiyun - 무조건 DB Insert (환경설정에 문제시 result 값에 필수필드가 없음)
        if (checkResultDataOK) {
            resultStr = cnsPayDao.insertTbgRawPgApprGtrDataJob( recvParam );
            String cardQuota = connector.getResultData("CardQuota");
            if( cardQuota.equals("00") ) {
                recvParam.put( "cardQuota", "일시불" );
            }
            else {
                recvParam.put( "cardQuota", connector.getResultData("CardQuota") );        // 할부개월(00:일시불,02:2개월)
            }
        }

        if (paySuccess) {
            //결제 성공시 DB처리 하세요.
            //2017-05-10 : jiyun - 결제 프로시져 호출 (regServPg)
            Map<String, Object> dbParam = new HashMap<String, Object>();
            dbParam.put("spCd"       , recvParam.get("spCd"));
            dbParam.put("custId"     , recvParam.get("custId"));
            dbParam.put("servId"     , recvParam.get("servId"));
            dbParam.put("mpNo"       , recvParam.get("telNo"));
            dbParam.put("payTid"     , recvParam.get("tid"));
            dbParam.put("payMethod"  , recvParam.get("payMethod"));
            dbParam.put("userId"     , recvParam.get("userId"));
            dbParam.put("custUserNo" , recvParam.get("custUserNo"));

            String strResult = this.userService.callProc("joinServPayPg", dbParam);
            logger.debug("userService.joinServPayPg strResult {}", strResult);

            String[] arrResult = strResult.split("\\|");
            if( "00".equals(arrResult[0]) ) {
                model.addAttribute("resultCd", "00");
//                model.addAttribute("resultData", "정상처리 되었습니다 !");
            } else {
                model.addAttribute("resultCd", arrResult[0]);
                model.addAttribute("resultData", arrResult[1]);
            }

            String rstStr = mobileAuthDao.mmsSendMessage( recvParam );
            if( !rstStr.equals( ConstantDefine.SQL_ROK ) ) {
                logger.debug("MMS Message Send Fail", strResult);
            }

        } else {
            // 결제 실패시 DB처리 하세요.
        }

        model.addAttribute("resultData", recvParam);

        return "billing/pay/payResultM";
    }


    @RequestMapping(value= {"requestEx"})
    public String viewRequestEx(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CnsPayController.viewRequest requestEx param [{}]", param);
        Map<String, Object> resultParam = new HashMap<String, Object>();

        resultParam = mobileAuthDao.selectPayReqInfo(param);

        resultParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
        resultParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        resultParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
        resultParam.put( "payFinalUrl", StringUtils.defaultString((String)param.get("payFinalUrl")) );
        resultParam.put( "custUserNo", StringUtils.defaultString((String)param.get("custUserNo")) );
        model.addAttribute("resultData", resultParam);

        return "billing/pay/payRequestEx";
    }

    @RequestMapping(value= {"resultEx"})
    public String viewResultEx(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

//        if(true) return "billing/pay/payResult";
        String resultStr = "";
        Map<String, Object> recvParam = new HashMap<String, Object>();

        logger.debug("PayController.viewResult viewResultEx param [{}]", param);

        // 모듈이 설치되어 있는 경로 설정
        CnsPayWebConnector4NS connector = new CnsPayWebConnector4NS();

        // 1. 로그 디렉토리 생성 : cnsPayHome/log 로 생성
        //connector.setLogHome("가맹점의 로그파일 생성 위치");
        //connector.setCnsPayHome("cnspay.properties파일 위치");
        String cnspayHomeDir="";
        String cnspayLogDir ="";
        Map<String, Object> rparam = new HashMap<String, Object>();
        rparam.put("codeGroupCd", "CNSPAY_HOME_DIR");

        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                rparam.put("codeCd", "PC");
                cnspayHomeDir = "d:/ksid/app/cnspay/pay";
                cnspayLogDir  = "d:/ksid/app/cnspay/pay/log";
                break;
            case MAC:
                logger.info("=====> getOS MAC");
                rparam.put("codeCd", "MAC");
                cnspayHomeDir = "/Users/skyamigo/Tmp/cnspay";
                cnspayLogDir  = "/Users/skyamigo/Tmp/cnspay/log";
                break;
            case LINUX:
            default :
                logger.info("=====> getOS LINUX");
                rparam.put("codeCd", "SERVER");
                cnspayHomeDir = "/domain/files/cnspay/pay";
                cnspayLogDir  = "/domain/files/cnspay/pay/log";
                break;
        }
        //Cnspay Home
        Map<String, Object> cnsPayHomeData = cnsPayDao.getCnspayDir(rparam);
        if(cnsPayHomeData != null) {
            cnspayHomeDir = StringUtils.defaultString((String)cnsPayHomeData.get("codeNm"));
        }

        rparam.put("codeGroupCd", "CNSPAY_LOG_DIR");
        Map<String, Object> cnsPayLogData = cnsPayDao.getCnspayDir(rparam);
        if(cnsPayLogData != null) {
            cnspayLogDir = StringUtils.defaultString((String)cnsPayLogData.get("codeNm"));
        }
        logger.debug("CnsPayCancelController cnspayHomeDir[{}] cnspayLogDir[{}]", cnspayHomeDir, cnspayLogDir);
        connector.setLogHome(cnspayLogDir);
        connector.setCnsPayHome(cnspayHomeDir);

        // 2. 요청 페이지 파라메터 셋팅
        connector.setRequestData(request);

        // 3. 추가 파라메터 셋팅
        connector.addRequestData("actionType", "PY0");  // actionType : CL0 취소, PY0 승인
        connector.addRequestData("MallIP",     request.getRemoteAddr());    // 상점 고유 ip
//        connector.addRequestData("CancelPwd",  "123456");
        connector.addRequestData("LogoURL",    "https://kmpay.lgcns.com:8443");

        // 가맹점키 셋팅 (MID 별로 틀림)
        String EncodeKey = "33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==";

        // 4. CNSPAY Lite 서버 접속하여 처리
        connector.requestAction();

        // 5-1. 처리 결과(공통)
        recvParam.put( "resultCode",    connector.getResultData("ResultCode") );       // 결과코드

        logger.debug("resultCode : [{}]", recvParam.get("resultCode"));
        String resultCode = connector.getResultData("ResultCode");

        //2017-05-10 : jiyun - 환경 설정문제시 에러체크
        boolean checkResultDataOK = true;
        if( "JL01".equals(resultCode) ) { //CnsPayHome directory 설정 오류입니다.
            checkResultDataOK = false;
        } else if( "JL02".equals(resultCode) ) {  //로그 설정 중 오류가 발생했습니다.
            checkResultDataOK = false;
        } else if( "JL10".equals(resultCode) ) {  //actionType 설정이 잘못되었습니다.
            checkResultDataOK = false;
        } else if( "JL11".equals(resultCode) ) {  //요청페이지 파라메터가 잘못되었습니다.
            checkResultDataOK = false;
        } else if( "JL20".equals(resultCode) ) {  //전문생성중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL30".equals(resultCode) ) {  //PGWEB서버 통신중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL31".equals(resultCode) ) {  //PGWEB서버 통신중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL40".equals(resultCode) ) {  //응답전문 처리 중 오류가 발생하였습니다.
            checkResultDataOK = false;
        }

        recvParam.put( "resultMsg",     connector.getResultData("ResultMsg") );        // 결과메시지
        recvParam.put( "tid",           connector.getResultData("TID") );              // 거래ID
        recvParam.put( "moid",          connector.getResultData("Moid") );             // 주문번호
        recvParam.put( "mid",           connector.getResultData("MID") );              // 상점ID
        recvParam.put( "payMethod",     connector.getResultData("PayMethod") );        // 결제수단
        recvParam.put( "amt",           connector.getResultData("Amt") );              // 금액
        recvParam.put( "authDate",      connector.getResultData("AuthDate") );         // 승인일시  YYMMDDHH24mmss

        recvParam.put( "authCode",      connector.getResultData("AuthCode") );         // 승인번호
        recvParam.put( "buyerName",     connector.getResultData("BuyerName") );        // 구매자명
        recvParam.put( "mallUserID",    connector.getResultData("MallUserID") );       // 회원사고객ID
        recvParam.put( "goodsName",     connector.getResultData("GoodsName") );        // 상품명

        // 5-2. 처리 결과(신용카드)
        recvParam.put( "cardCode",      connector.getResultData("CardCode") );         // 카드사 코드
        recvParam.put( "cardName",      connector.getResultData("CardName") );         // 결제카드사명
        recvParam.put( "cardQuota",     connector.getResultData("CardQuota") );        // 할부개월(00:일시불,02:2개월)

        recvParam.put( "cardBin",       connector.getResultData("cardBin") );          // 카드BIN
        recvParam.put( "cardPoint",     connector.getResultData("cardPoint") );        // 카드사포인트(0:미사용,1:포인트사용,2:세이브포인트사용)
        recvParam.put( "vanCode",       connector.getResultData("vanCode") );          // 밴코드(01(나이스),04(코밴),05(스마트로),06(신한직승인),07(다우))

        // 5-3. 처리 결과(계좌이체)
        recvParam.put( "bankCode",      connector.getResultData("BankCode") );          // 은행 코드
        recvParam.put( "bankName",      connector.getResultData("BankName") );          // 은행명
        recvParam.put( "rcptType",      connector.getResultData("RcptType") );          // 현금 영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
        recvParam.put( "rcptAuthCode",  connector.getResultData("RcptAuthCode") );      // 현금영수증 승인 번호
        recvParam.put( "rcptTID",       connector.getResultData("RcptTID") );           // 현금 영수증 TID

        // 5-4. 처리 결과(휴대폰)
        recvParam.put( "carrier",       connector.getResultData("Carrier") );           // 이통사구분
        recvParam.put( "dstAddr",       connector.getResultData("DstAddr") );           // 휴대폰번호

        // 5-5. 처리 결과(가상계좌)
        recvParam.put( "vbankBankCode", connector.getResultData("vbankBankCode") );     // 가상계좌은행코드
        recvParam.put( "vbankBankName", connector.getResultData("vbankBankName") );     // 가상계좌은행명
        recvParam.put( "vbankNum",      connector.getResultData("vbankNum") );              // 가상계좌번호
        recvParam.put( "vbankExpDate",  connector.getResultData("VbankExpDate") );      // 가상계좌입금예정일
        recvParam.put( "vbankExpTime",  connector.getResultData("VbankExpTime") );      // 가상계좌입금예정일시분

        boolean paySuccess = false; // 결제 성공 여부

        /** 위의 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능 */
        if( recvParam.get("payMethod").equals("CARD") ) {
            if( recvParam.get("resultCode").equals("3001") )
                paySuccess = true;                                      // 결과코드 (정상 :3001 , 그 외 에러)
        }
        else if( recvParam.get("payMethod").equals("BANK") ) {
            if( recvParam.get("resultCode").equals("4000") )
                paySuccess = true;                                      // 결과코드 (정상 :4000 , 그 외 에러)
        }
        else if( recvParam.get("payMethod").equals("CELLPHONE") ) {
            if( recvParam.get("resultCode").equals("A000") )
                paySuccess = true;                                      // 결과코드 (정상 : A000, 그 외 비정상)
        }
        else if( recvParam.get("payMethod").equals("VBANK") ) {
            if( recvParam.get("resultCode").equals("4100") )
                paySuccess = true;                                      // 결과코드 (정상 :4100 , 그 외 에러)
        }

        recvParam.put( "spCd",   param.get("spCd") );
        recvParam.put( "custId", param.get("custId") );
        recvParam.put( "servId", param.get("servId") );
        recvParam.put( "payFinalUrl", StringUtils.defaultString((String)param.get("payFinalUrl")) );
        recvParam.put( "custUserNo", param.get("CustUserNo") );

        String parseTelNo = (String) param.get("BuyerTel");
        recvParam.put( "telNo", parseTelNo.replaceAll("-", "") );

        Map<String, Object> selData = cnsPayDao.selectPgUserIdGetJob( recvParam );
        String retValue = (String) selData.get( "retValue" );
        if( !retValue.equals(ConstantDefine.SQL_ROK) ) {
            logger.debug("selectPgUserIdGetJob userID, userNm, custUserNo Get Fail");
        }

        recvParam.put( "userId",     StringUtils.defaultString((String) selData.get("userId")) );
        recvParam.put( "userNm",     StringUtils.defaultString((String)selData.get("userNm")) );
        recvParam.put( "custUserNo", StringUtils.defaultString((String)selData.get("custUserNo")) );
        recvParam.put( "mpOsTp",     StringUtils.defaultString((String)selData.get("mpOsTp")) );

        logger.debug("spCd       : [{}]", recvParam.get("spCd"));
        logger.debug("custId     : [{}]", recvParam.get("custId"));
        logger.debug("servId     : [{}]", recvParam.get("servId"));
        logger.debug("telNo      : [{}]", recvParam.get("telNo"));
        logger.debug("userId     : [{}]", recvParam.get("userId"));
        logger.debug("userNm     : [{}]", recvParam.get("userNm"));
        logger.debug("custUserNo : [{}]", recvParam.get("custUserNo"));
        logger.debug("mpOsTp     : [{}]", recvParam.get("mpOsTp"));

        //2017-05-10 : jiyun - 무조건 DB Insert (환경설정에 문제시 result 값에 필수필드가 없음)
        if (checkResultDataOK) {
            resultStr = cnsPayDao.insertTbgRawPgApprGtrDataJob( recvParam );
            String cardQuota = connector.getResultData("CardQuota");
            if( cardQuota.equals("00") ) {
                recvParam.put( "cardQuota", "일시불" );
            }
            else {
                recvParam.put( "cardQuota", connector.getResultData("CardQuota") );        // 할부개월(00:일시불,02:2개월)
            }
        }

        if (paySuccess) {
            //결제 성공시 DB처리 하세요.
            //2017-05-10 : jiyun - 결제 프로시져 호출 (regServPg)
            Map<String, Object> dbParam = new HashMap<String, Object>();
            dbParam.put("spCd"       , recvParam.get("spCd"));
            dbParam.put("custId"     , recvParam.get("custId"));
            dbParam.put("servId"     , recvParam.get("servId"));
            dbParam.put("mpNo"       , recvParam.get("telNo"));
            dbParam.put("payTid"     , recvParam.get("tid"));
            dbParam.put("payMethod"  , recvParam.get("payMethod"));
            dbParam.put("userId"     , recvParam.get("userId"));
            dbParam.put("custUserNo" , recvParam.get("custUserNo"));

            String strResult = this.userService.callProc("joinServPayPg", dbParam);
            logger.debug("userService.joinServPayPg strResult {}", strResult);

            String[] arrResult = strResult.split("\\|");
            if( "00".equals(arrResult[0]) ) {
                model.addAttribute("resultCd", "00");
//                model.addAttribute("resultData", "정상처리 되었습니다 !");
            } else {
                model.addAttribute("resultCd", arrResult[0]);
                model.addAttribute("resultData", arrResult[1]);
            }

            String rstStr = mobileAuthDao.mmsSendMessage( recvParam );
            if( !rstStr.equals( ConstantDefine.SQL_ROK ) ) {
                logger.debug("MMS Message Send Fail", strResult);
            }

        } else {
            // 결제 실패시 DB처리 하세요.
        }

        model.addAttribute("resultData", recvParam);

        return "billing/pay/payResultEx";
    }

    @RequestMapping(value= {"requestMEx"})
    public String viewRequestMEx(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CnsPayController.viewRequestM param [{}]", param);
        Map<String, Object> resultParam = new HashMap<String, Object>();

        resultParam = mobileAuthDao.selectPayReqInfo(param);

        resultParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
        resultParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        resultParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
        resultParam.put( "payFinalUrl", StringUtils.defaultString((String)param.get("payFinalUrl")) );
        resultParam.put( "custUserNo", StringUtils.defaultString((String)param.get("custUserNo")) );
        model.addAttribute("resultData", resultParam);

        logger.debug("CnsPayController.viewRequestM payRequestM before [{}]", resultParam);

        return "billing/pay/payRequestMEx";
    }

    @RequestMapping(value= {"resultMEx"})
    public String viewResultMEx(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

//        if(true) return "billing/pay/payResultM";
        String resultStr = "";
        Map<String, Object> recvParam = new HashMap<String, Object>();

        logger.debug("PayController.viewResultM param [{}]", param);

        // 모듈이 설치되어 있는 경로 설정
        CnsPayWebConnector4NS connector = new CnsPayWebConnector4NS();

        // 1. 로그 디렉토리 생성 : cnsPayHome/log 로 생성
        //connector.setLogHome("가맹점의 로그파일 생성 위치");
        //connector.setCnsPayHome("cnspay.properties파일 위치");
        String cnspayHomeDir="";
        String cnspayLogDir ="";
        Map<String, Object> rparam = new HashMap<String, Object>();
        rparam.put("codeGroupCd", "CNSPAY_HOME_DIR");

        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                rparam.put("codeCd", "PC");
                cnspayHomeDir = "d:/ksid/app/cnspay/pay";
                cnspayLogDir  = "d:/ksid/app/cnspay/pay/log";
                break;
            case MAC:
                logger.info("=====> getOS MAC");
                rparam.put("codeCd", "MAC");
                cnspayHomeDir = "/Users/skyamigo/Tmp/cnspay";
                cnspayLogDir  = "/Users/skyamigo/Tmp/cnspay/log";
                break;
            case LINUX:
            default :
                logger.info("=====> getOS LINUX");
                rparam.put("codeCd", "SERVER");
                cnspayHomeDir = "/domain/files/cnspay/pay";
                cnspayLogDir  = "/domain/files/cnspay/pay/log";
                break;
        }
        //Cnspay Home
        Map<String, Object> cnsPayHomeData = cnsPayDao.getCnspayDir(rparam);
        if(cnsPayHomeData != null) {
            cnspayHomeDir = StringUtils.defaultString((String)cnsPayHomeData.get("codeNm"));
        }

        rparam.put("codeGroupCd", "CNSPAY_LOG_DIR");
        Map<String, Object> cnsPayLogData = cnsPayDao.getCnspayDir(rparam);
        if(cnsPayLogData != null) {
            cnspayLogDir = StringUtils.defaultString((String)cnsPayLogData.get("codeNm"));
        }
        logger.debug("CnsPayCancelController cnspayHomeDir[{}] cnspayLogDir[{}]", cnspayHomeDir, cnspayLogDir);
        connector.setLogHome(cnspayLogDir);
        connector.setCnsPayHome(cnspayHomeDir);

        // 2. 요청 페이지 파라메터 셋팅
        connector.setRequestData(request);

        // 3. 추가 파라메터 셋팅
        connector.addRequestData("actionType", "PY0");  // actionType : CL0 취소, PY0 승인
        connector.addRequestData("MallIP",     request.getRemoteAddr());    // 상점 고유 ip
//        connector.addRequestData("CancelPwd",  "123456");
        connector.addRequestData("LogoURL",    "https://kmpay.lgcns.com:8443");

        // 가맹점키 셋팅 (MID 별로 틀림)
        String EncodeKey = "33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==";

        // 4. CNSPAY Lite 서버 접속하여 처리
        connector.requestAction();

        // 5-1. 처리 결과(공통)
        recvParam.put( "resultCode",    connector.getResultData("ResultCode") );       // 결과코드

        logger.debug("resultCode : [{}]", recvParam.get("resultCode"));
        String resultCode = connector.getResultData("ResultCode");

        //2017-05-10 : jiyun - 환경 설정문제시 에러체크
        boolean checkResultDataOK = true;
        if( "JL01".equals(resultCode) ) { //CnsPayHome directory 설정 오류입니다.
            checkResultDataOK = false;
        } else if( "JL02".equals(resultCode) ) {  //로그 설정 중 오류가 발생했습니다.
            checkResultDataOK = false;
        } else if( "JL10".equals(resultCode) ) {  //actionType 설정이 잘못되었습니다.
            checkResultDataOK = false;
        } else if( "JL11".equals(resultCode) ) {  //요청페이지 파라메터가 잘못되었습니다.
            checkResultDataOK = false;
        } else if( "JL20".equals(resultCode) ) {  //전문생성중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL30".equals(resultCode) ) {  //PGWEB서버 통신중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL31".equals(resultCode) ) {  //PGWEB서버 통신중 오류가 발생하였습니다.
            checkResultDataOK = false;
        } else if( "JL40".equals(resultCode) ) {  //응답전문 처리 중 오류가 발생하였습니다.
            checkResultDataOK = false;
        }

        recvParam.put( "resultMsg",     connector.getResultData("ResultMsg") );        // 결과메시지
        recvParam.put( "tid",           connector.getResultData("TID") );              // 거래ID
        recvParam.put( "moid",          connector.getResultData("Moid") );             // 주문번호
        recvParam.put( "mid",           connector.getResultData("MID") );              // 상점ID
        recvParam.put( "payMethod",     connector.getResultData("PayMethod") );        // 결제수단
        recvParam.put( "amt",           connector.getResultData("Amt") );              // 금액
        recvParam.put( "authDate",      connector.getResultData("AuthDate") );         // 승인일시  YYMMDDHH24mmss
        logger.debug("authDate : [{}]", recvParam.get("authDate"));
        recvParam.put( "authCode",      connector.getResultData("AuthCode") );         // 승인번호
        recvParam.put( "buyerName",     connector.getResultData("BuyerName") );        // 구매자명
        recvParam.put( "mallUserID",    connector.getResultData("MallUserID") );       // 회원사고객ID
        recvParam.put( "goodsName",     connector.getResultData("GoodsName") );        // 상품명

        // 5-2. 처리 결과(신용카드)
        recvParam.put( "cardCode",      connector.getResultData("CardCode") );         // 카드사 코드
        recvParam.put( "cardName",      connector.getResultData("CardName") );         // 결제카드사명
        recvParam.put( "cardQuota",     connector.getResultData("CardQuota") );        // 할부개월(00:일시불,02:2개월)

        recvParam.put( "cardBin",       connector.getResultData("cardBin") );          // 카드BIN
        recvParam.put( "cardPoint",     connector.getResultData("cardPoint") );        // 카드사포인트(0:미사용,1:포인트사용,2:세이브포인트사용)
        recvParam.put( "vanCode",       connector.getResultData("vanCode") );          // 밴코드(01(나이스),04(코밴),05(스마트로),06(신한직승인),07(다우))

        // 5-3. 처리 결과(계좌이체)
        recvParam.put( "bankCode",      connector.getResultData("BankCode") );          // 은행 코드
        recvParam.put( "bankName",      connector.getResultData("BankName") );          // 은행명
        recvParam.put( "rcptType",      connector.getResultData("RcptType") );          // 현금 영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
        recvParam.put( "rcptAuthCode",  connector.getResultData("RcptAuthCode") );      // 현금영수증 승인 번호
        recvParam.put( "rcptTID",       connector.getResultData("RcptTID") );           // 현금 영수증 TID

        // 5-4. 처리 결과(휴대폰)
        recvParam.put( "carrier",       connector.getResultData("Carrier") );           // 이통사구분
        recvParam.put( "dstAddr",       connector.getResultData("DstAddr") );           // 휴대폰번호

        // 5-5. 처리 결과(가상계좌)
        recvParam.put( "vbankBankCode", connector.getResultData("vbankBankCode") );     // 가상계좌은행코드
        recvParam.put( "vbankBankName", connector.getResultData("vbankBankName") );     // 가상계좌은행명
        recvParam.put( "vbankNum",      connector.getResultData("vbankNum") );              // 가상계좌번호
        recvParam.put( "vbankExpDate",  connector.getResultData("VbankExpDate") );      // 가상계좌입금예정일
        recvParam.put( "vbankExpTime",  connector.getResultData("VbankExpTime") );      // 가상계좌입금예정일시분

        boolean paySuccess = false; // 결제 성공 여부

        /** 위의 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능 */
        if( recvParam.get("payMethod").equals("CARD") ) {
            if( recvParam.get("resultCode").equals("3001") )
                paySuccess = true;                                      // 결과코드 (정상 :3001 , 그 외 에러)
        }
        else if( recvParam.get("payMethod").equals("BANK") ) {
            if( recvParam.get("resultCode").equals("4000") )
                paySuccess = true;                                      // 결과코드 (정상 :4000 , 그 외 에러)
        }
        else if( recvParam.get("payMethod").equals("CELLPHONE") ) {
            if( recvParam.get("resultCode").equals("A000") )
                paySuccess = true;                                      // 결과코드 (정상 : A000, 그 외 비정상)
        }
        else if( recvParam.get("payMethod").equals("VBANK") ) {
            if( recvParam.get("resultCode").equals("4100") )
                paySuccess = true;                                      // 결과코드 (정상 :4100 , 그 외 에러)
        }

        recvParam.put( "spCd",   param.get("spCd") );
        recvParam.put( "custId", param.get("custId") );
        recvParam.put( "servId", param.get("servId") );
        recvParam.put( "payFinalUrl", StringUtils.defaultString((String)param.get("payFinalUrl")) );
        recvParam.put( "custUserNo", param.get("CustUserNo") );

        String parseTelNo = (String) param.get("BuyerTel");
        recvParam.put( "telNo", parseTelNo.replaceAll("-", "") );

        Map<String, Object> selData = cnsPayDao.selectPgUserIdGetJob( recvParam );
        String retValue = (String) selData.get( "retValue" );
        if( !retValue.equals(ConstantDefine.SQL_ROK) ) {
            logger.debug("selectPgUserIdGetJob userID, userNm, custUserNo Get Fail");
        }

        recvParam.put( "userId",     StringUtils.defaultString((String) selData.get("userId")) );
        recvParam.put( "userNm",     StringUtils.defaultString((String)selData.get("userNm")) );
        recvParam.put( "custUserNo", StringUtils.defaultString((String)selData.get("custUserNo")) );
        recvParam.put( "mpOsTp",     StringUtils.defaultString((String)selData.get("mpOsTp")) );

        logger.debug("spCd       : [{}]", recvParam.get("spCd"));
        logger.debug("custId     : [{}]", recvParam.get("custId"));
        logger.debug("servId     : [{}]", recvParam.get("servId"));
        logger.debug("telNo      : [{}]", recvParam.get("telNo"));
        logger.debug("userId     : [{}]", recvParam.get("userId"));
        logger.debug("userNm     : [{}]", recvParam.get("userNm"));
        logger.debug("custUserNo : [{}]", recvParam.get("custUserNo"));
        logger.debug("mpOsTp     : [{}]", recvParam.get("mpOsTp"));

        //2017-05-10 : jiyun - 무조건 DB Insert (환경설정에 문제시 result 값에 필수필드가 없음)
        if (checkResultDataOK) {
            resultStr = cnsPayDao.insertTbgRawPgApprGtrDataJob( recvParam );
            String cardQuota = connector.getResultData("CardQuota");
            if( cardQuota.equals("00") ) {
                recvParam.put( "cardQuota", "일시불" );
            }
            else {
                recvParam.put( "cardQuota", connector.getResultData("CardQuota") );        // 할부개월(00:일시불,02:2개월)
            }
        }

        if (paySuccess) {
            //결제 성공시 DB처리 하세요.
            //2017-05-10 : jiyun - 결제 프로시져 호출 (regServPg)
            Map<String, Object> dbParam = new HashMap<String, Object>();
            dbParam.put("spCd"       , recvParam.get("spCd"));
            dbParam.put("custId"     , recvParam.get("custId"));
            dbParam.put("servId"     , recvParam.get("servId"));
            dbParam.put("mpNo"       , recvParam.get("telNo"));
            dbParam.put("payTid"     , recvParam.get("tid"));
            dbParam.put("payMethod"  , recvParam.get("payMethod"));
            dbParam.put("userId"     , recvParam.get("userId"));
            dbParam.put("custUserNo" , recvParam.get("custUserNo"));

            String strResult = this.userService.callProc("joinServPayPg", dbParam);
            logger.debug("userService.joinServPayPg strResult {}", strResult);

            String[] arrResult = strResult.split("\\|");
            if( "00".equals(arrResult[0]) ) {
                model.addAttribute("resultCd", "00");
//                model.addAttribute("resultData", "정상처리 되었습니다 !");
            } else {
                model.addAttribute("resultCd", arrResult[0]);
                model.addAttribute("resultData", arrResult[1]);
            }

            String rstStr = mobileAuthDao.mmsSendMessage( recvParam );
            if( !rstStr.equals( ConstantDefine.SQL_ROK ) ) {
                logger.debug("MMS Message Send Fail", strResult);
            }

        } else {
            // 결제 실패시 DB처리 하세요.
        }

        model.addAttribute("resultData", recvParam);

        return "billing/pay/payResultMEx";
    }

}
