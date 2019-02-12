package ksid.biz.cnspay.web;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.httpclient.util.DateUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.Gson;

import kr.co.lgcns.module.lite.CnsPayWebConnector4NS;
import ksid.biz.cnspay.service.CnsPayCancelService;
import ksid.biz.cnspay.service.impl.CnsPayDao;
import ksid.biz.devauth.mobileauth.service.MobileAuthService;
import ksid.biz.devauth.mobileauth.service.impl.MobileAuthDao;
import ksid.core.webmvc.base.web.BaseController;
import ksid.core.webmvc.util.ConstantDefine;
import ksid.core.webmvc.util.OsUtilLib;
import ksid.core.webmvc.util.PayUtil;

@Controller
@RequestMapping(value= {"cnspaycancel"})
public class CnsPayCancelController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(CnsPayCancelController.class);

    @Autowired
    private CnsPayCancelService cnsPayCancelService;

    @Autowired
    private CnsPayDao cnsPayDao;

    @Autowired
    private MobileAuthDao  mobileAuthDao;

    @Autowired
    private MobileAuthService mobileAuthService;


    @RequestMapping(value= {"request"})
    public String root(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CnsPayCancelController.root param [{}]", param);

        Gson gson = new Gson();
        String jsonParam = gson.toJson(param);

        logger.debug(jsonParam);

        model.addAttribute("requestParam", jsonParam);

        return "billing/pay/payCancelRequest";
    }

    @RequestMapping(value= {"result"})
    public String view(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

        logger.debug("CnsPayCancelController.result request TID [{}]", (String)request.getParameter("TID"));
//        CnsPayCancelController.result request TID [cnstest30m01011705110931310374]

        logger.debug("CnsPayCancelController.result param [{}]", param);


        String ediDate = PayUtil.getDate("yyyyMMddHHmmss"); // 전문생성일시

        Map<String, Object> selMidParam = mobileAuthDao.selectPGMidInfo(param);
        String retValue = StringUtils.defaultString( (String) selMidParam.get("retValue") );
        if( !retValue.equals(ConstantDefine.SQL_ROK) ) {
            logger.debug("CnsPayCancelController Mid :encodeKey Fail [{}]", selMidParam.get( "midKey" ));
        }

        //상점서명키 (꼭 해당 상점키로 바꿔주세요)

        String encodeKey = StringUtils.defaultString( (String) selMidParam.get( "midKey" ) );
//        String encodeKey = "33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==";

        //KSID Mid
//        String encodeKey = "g2JABVU54X3z5stUiVnxRva68GQ8JdbF1r70x8qpV06mm9CVzdcUkINryOwVHz8KCR3xziS4wCOyqZW5cka8yQ==";

        //가맹점 MID payMid
        String MID = StringUtils.defaultString( (String) selMidParam.get( "payMid" ) );
//        String MID = (String)param.get("MID");
        String CancelAmt = (String)param.get("CancelAmt");
        //취소구분(0:전체,1:부분)
        String payCancelCmd = "C";  //전체취소
        if( "1".equals((String)param.get("PartialCancelCode")) ) payCancelCmd = "P"; //부분취소

        ////////위변조방지 처리/////////
        //결제 취소 요청용 해쉬 키값
        String md_src = ediDate + MID + CancelAmt;
        String hash_String = PayUtil.SHA256Salt(md_src, encodeKey);

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
        Map<String, Object> cnsPayHomeData = this.cnsPayCancelService.selData("getCnspayDir", rparam);
        if(cnsPayHomeData != null) {
            cnspayHomeDir = StringUtils.defaultString((String)cnsPayHomeData.get("codeNm"));
        }

        rparam.put("codeGroupCd", "CNSPAY_LOG_DIR");
        Map<String, Object> cnsPayLogData = this.cnsPayCancelService.selData("getCnspayDir", rparam);
        if(cnsPayLogData != null) {
            cnspayLogDir = StringUtils.defaultString((String)cnsPayLogData.get("codeNm"));
        }
        logger.debug("CnsPayCancelController cnspayHomeDir[{}] cnspayLogDir[{}]", cnspayHomeDir, cnspayLogDir);
        connector.setLogHome(cnspayLogDir);
        connector.setCnsPayHome(cnspayHomeDir);

        // 2. 요청 페이지 파라메터 셋팅
        connector.setRequestData(request);

        // 3. 추가 파라메터 셋팅
        connector.addRequestData("actionType", "CL0");  // actionType : CL0 취소, PY0 승인
        connector.addRequestData("MallIP", request.getRemoteAddr());    // 상점 고유 ip

        connector.addRequestData("EdiDate", ediDate);                //취소요청 해쉬용 파라미터
        connector.addRequestData("EncryptData", hash_String);        //취소요청 해쉬용 파라미터

        // 4. CNSPAY Lite 서버 접속하여 처리
        connector.requestAction();

        Map<String, Object> rtnMap = new HashMap<String, Object>();

        //2017-05-11 : jiyun - 환경 설정문제시 에러체크
        String resultCode = connector.getResultData("ResultCode");
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


        // 5. 결과 처리
        rtnMap.put("resultCode",  connector.getResultData("ResultCode"));  // 결과코드 (정상 :2001(취소성공), 2002(취소진행중), 2211(가상계좌 환불성공) 그 외 에러)
        rtnMap.put("resultMsg",   connector.getResultData("ResultMsg"));    // 결과메시지
        rtnMap.put("cancelAmt",   connector.getResultData("CancelAmt"));    // 취소금액
        rtnMap.put("cancelDate",  connector.getResultData("CancelDate"));  // 취소일
        rtnMap.put("cancelTime",  connector.getResultData("CancelTime"));  // 취소시간
        rtnMap.put("cancelNum",   connector.getResultData("CancelNum"));    // 취소번호
        rtnMap.put("payMethod",   connector.getResultData("PayMethod"));    // 취소 결제수단
        rtnMap.put("mid",         connector.getResultData("MID"));             // 상점 ID
        rtnMap.put("tid",         connector.getResultData("TID"));                // TID
        rtnMap.put("errorCD",     connector.getResultData("ErrorCD"));        // 상세 에러코드
        rtnMap.put("errorMsg",    connector.getResultData("ErrorMsg"));      // 상세 에러메시지
        rtnMap.put("authDate",    connector.getResultData("AuthDate"));      // 거래시간
        rtnMap.put("stateCD",     connector.getResultData("StateCD"));        // 거래상태
        rtnMap.put("promotionCd", connector.getResultData("PromotionCd"));
        rtnMap.put("discountAmt", connector.getResultData("DiscountAmt"));
        rtnMap.put("recoverYn",   connector.getResultData("RecoverYn"));

        rtnMap.put("preCancelCode", connector.getResultData("PreCancelCode")); // 전취소 후취소 구분

        logger.debug("CnsPayCancelController.result rtnMap [{}]", rtnMap);

        Map<String, Object> selData = cnsPayDao.selectPgCustUserNo( param );
        String resultStr = (String) selData.get( "retValue" );
        if( !resultStr.equals(ConstantDefine.SQL_ROK) ) {
            logger.debug("selectPgCustUserNo userID, userNm, custUserNo Get Fail");
        }

        //2017-05-11 : jiyun - 무조건 DB Insert (환경설정에 문제시 result 값에 필수필드가 없음)
        if (checkResultDataOK) {

            // 6. PG 결제취소 처리 데이터 INSERT
            Map<String, Object> payCancelMap = new HashMap<String, Object>();

            String udrDtm = (connector.getResultData("CancelDate").equals("00000000") == true) ? DateUtil.formatDate(new Date(), "yyyyMMddHHmmss") : connector.getResultData("CancelDate") + connector.getResultData("CancelTime");
            String cancelDtm = connector.getResultData("CancelDate") + connector.getResultData("CancelTime");

            payCancelMap.put("udrDtm"           , udrDtm                                    ); /* 결제일시 */
            payCancelMap.put("spCd"             , (String)param.get("spCd")                 ); /* 서비스제공자 */
            payCancelMap.put("custId"           , (String)param.get("custId")               ); /* 고객사 */
            payCancelMap.put("servId"           , (String)param.get("servId")               ); /* 서비스아이디 */
            payCancelMap.put("telNo"            , (String)param.get("telNo")                ); /* 휴대폰 */
            payCancelMap.put("userId"           , (String)param.get("userId")               ); /* 사용자 */
            payCancelMap.put("userNm"           , (String)selData.get("userNm")             );
            payCancelMap.put("custUserNo"       , (String)selData.get("custUserNo")         );
            payCancelMap.put("payCancelCmd"     , payCancelCmd                              ); /* 취소명령(C:전체,P:부분) */
            payCancelMap.put("rstResultCd"      , connector.getResultData("ResultCode")     ); /* 결제 결과코드 */
            payCancelMap.put("rstResultMsg"     , connector.getResultData("ResultMsg")      ); /* 결제 결과메시지 */
            payCancelMap.put("rstErrorCd"       , connector.getResultData("ErrorCD")        ); /* 에러코드 */
            payCancelMap.put("rstErrorMsg"      , connector.getResultData("ErrorMsg")       ); /* 에러메시지 */
            payCancelMap.put("rstCancelAmt"     , connector.getResultData("CancelAmt")      ); /* 취소금액 */
            payCancelMap.put("rstCancelDtm"     , cancelDtm                                 ); /* 취소일시 */
            payCancelMap.put("rstCancelMethod"  , connector.getResultData("PayMethod")      ); /* 취소 결제수단 */
            payCancelMap.put("rstCancelMid"     , (String)param.get("MID")                  ); /* 가맹점 ID */
            payCancelMap.put("rstCancelTid"     , (String)param.get("TID")                  ); /* 거래 ID */
            payCancelMap.put("rstStateCd"       , connector.getResultData("StateCD")        ); /* 거래상태코드 */
            payCancelMap.put("rstPartialFg"     , connector.getResultData("CcPartCl")       ); /* 부분취소 가능여부 */
            payCancelMap.put("rstCancelNo"      , connector.getResultData("CancelNum")      ); /* 취소번호 */
            payCancelMap.put("rstAuthDtm"       , connector.getResultData("AuthDate")       ); /* 승인날짜 */
            payCancelMap.put("rstPromCd"        , connector.getResultData("PromotionCd")    ); /* 프로모션 코드 */
            payCancelMap.put("rstDiscountAmt"   , connector.getResultData("DiscountAmt")    ); /* 프로모션 할인금액 */
            payCancelMap.put("rstRecoverFg"     , connector.getResultData("RecoverYn")      ); /* 프로모션혜택복원여부 */
            payCancelMap.put("rstCancelCd"      , connector.getResultData("PreCancelCode")  ); /* 매입취소구분 */

            logger.debug("payCancelMap [{}]", payCancelMap.get("rstResultCd"));

            try {
                this.cnsPayCancelService.insData(payCancelMap);
            } catch (Exception e) {
                logger.debug("insCnsPayCancel error [{}]", e.getMessage());
            }
        }

        // 취소성공일때만 데이터를 등록하고 사용자를 해지하자. (2001 :해지성공,  2015: 해당거래 취소실패(기취소 거래)
        //if( "2001".equals(resultCode) == true || "2015".equals(resultCode) == true ) {
        //20180308-농협중앙회:가상계좌-환불성공(2211)
        if( "2001".equals(resultCode) == true || "2211".equals(resultCode) == true ) {
            Map<String, Object> svcParam = new HashMap<String, Object>();
            svcParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
            svcParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
            svcParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
            svcParam.put( "svcType", "SVCPAYCANCEL" );
            svcParam.put( "custUserNo", StringUtils.defaultString((String)selData.get("custUserNo")) );
            svcParam.put( "code", "200" );
            mobileAuthService.serviceHistWrite(svcParam);
            // 7. 사용자 가입 해지
            Map<String, Object> deregServMap = new HashMap<String, Object>();

            deregServMap.put("spCd"             , (String)param.get("spCd")                 ); /* 서비스제공자 */
            deregServMap.put("custId"           , (String)param.get("custId")               ); /* 고객사 */
            deregServMap.put("servId"           , (String)param.get("servId")               ); /* 서비스아이디 */
            deregServMap.put("mpNo"             , (String)param.get("telNo")                ); /* 휴대폰 */
            deregServMap.put("userId"           , (String)param.get("userId")               ); /* 사용자아이디 */
            deregServMap.put("cancelRsn"        , (String)param.get("CancelMsg")            ); /* 취소사유 */

            logger.debug("deregServMap [{}]", deregServMap);

            String strResult = this.cnsPayCancelService.callProc("cancelServAll", deregServMap);

            logger.debug("cnsPayCancelService.cancelServAll strResult {}", strResult);

            String[] arrResult = strResult.split("\\|");

            if( "00".equals(arrResult[0]) ) {
                model.addAttribute("resultCd", "00");
                model.addAttribute("resultData", "정상처리 되었습니다 !");
            } else {
                model.addAttribute("resultCd", arrResult[0]);
                model.addAttribute("resultData", arrResult[1]);
            }
        }
        else {
            Map<String, Object> svcParam = new HashMap<String, Object>();
            svcParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
            svcParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
            svcParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
            svcParam.put( "svcType", "SVCPAYCANCEL" );
            svcParam.put( "custUserNo", StringUtils.defaultString((String)selData.get("custUserNo")) );
            svcParam.put( "code", "201" );
            mobileAuthService.serviceHistWrite(svcParam);
        }

        model.addAttribute("result", rtnMap);

        return "billing/pay/payCancelResult";
    }


    @RequestMapping(value= {"requestEx"})
    public String requestEx(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CnsPayCancelController.root requestEx param [{}]", param);

        Gson gson = new Gson();
        String jsonParam = gson.toJson(param);

        logger.debug(jsonParam);

        model.addAttribute("requestParam", jsonParam);

        return "billing/pay/payCancelRequestEx";
    }

    @RequestMapping(value= {"resultEx"})
    public String resultEx(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

        logger.debug("CnsPayCancelController.result request TID [{}]", (String)request.getParameter("TID"));
//        CnsPayCancelController.result request TID [cnstest30m01011705110931310374]

        logger.debug("CnsPayCancelController.result resultEx param [{}]", param);


        String ediDate = PayUtil.getDate("yyyyMMddHHmmss"); // 전문생성일시

        Map<String, Object> selMidParam = mobileAuthDao.selectPGMidInfo(param);
        String retValue = StringUtils.defaultString( (String) selMidParam.get("retValue") );
        if( !retValue.equals(ConstantDefine.SQL_ROK) ) {
            logger.debug("CnsPayCancelController Mid :encodeKey Fail [{}]", selMidParam.get( "midKey" ));
        }

        //상점서명키 (꼭 해당 상점키로 바꿔주세요)

        String encodeKey = StringUtils.defaultString( (String) selMidParam.get( "midKey" ) );
//        String encodeKey = "33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==";

        //KSID Mid
//        String encodeKey = "g2JABVU54X3z5stUiVnxRva68GQ8JdbF1r70x8qpV06mm9CVzdcUkINryOwVHz8KCR3xziS4wCOyqZW5cka8yQ==";

        //가맹점 MID payMid
        String MID = StringUtils.defaultString( (String) selMidParam.get( "payMid" ) );
//        String MID = (String)param.get("MID");
        String CancelAmt = (String)param.get("CancelAmt");
        //취소구분(0:전체,1:부분)
        String payCancelCmd = "C";  //전체취소
        if( "1".equals((String)param.get("PartialCancelCode")) ) payCancelCmd = "P"; //부분취소

        ////////위변조방지 처리/////////
        //결제 취소 요청용 해쉬 키값
        String md_src = ediDate + MID + CancelAmt;
        String hash_String = PayUtil.SHA256Salt(md_src, encodeKey);

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
        Map<String, Object> cnsPayHomeData = this.cnsPayCancelService.selData("getCnspayDir", rparam);
        if(cnsPayHomeData != null) {
            cnspayHomeDir = StringUtils.defaultString((String)cnsPayHomeData.get("codeNm"));
        }

        rparam.put("codeGroupCd", "CNSPAY_LOG_DIR");
        Map<String, Object> cnsPayLogData = this.cnsPayCancelService.selData("getCnspayDir", rparam);
        if(cnsPayLogData != null) {
            cnspayLogDir = StringUtils.defaultString((String)cnsPayLogData.get("codeNm"));
        }
        logger.debug("CnsPayCancelController cnspayHomeDir[{}] cnspayLogDir[{}]", cnspayHomeDir, cnspayLogDir);
        connector.setLogHome(cnspayLogDir);
        connector.setCnsPayHome(cnspayHomeDir);

        // 2. 요청 페이지 파라메터 셋팅
        connector.setRequestData(request);

        // 3. 추가 파라메터 셋팅
        connector.addRequestData("actionType", "CL0");  // actionType : CL0 취소, PY0 승인
        connector.addRequestData("MallIP", request.getRemoteAddr());    // 상점 고유 ip

        connector.addRequestData("EdiDate", ediDate);                //취소요청 해쉬용 파라미터
        connector.addRequestData("EncryptData", hash_String);        //취소요청 해쉬용 파라미터

        // 4. CNSPAY Lite 서버 접속하여 처리
        connector.requestAction();

        Map<String, Object> rtnMap = new HashMap<String, Object>();

        //2017-05-11 : jiyun - 환경 설정문제시 에러체크
        String resultCode = connector.getResultData("ResultCode");
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


        // 5. 결과 처리
        rtnMap.put("resultCode",  connector.getResultData("ResultCode"));  // 결과코드 (정상 :2001(취소성공), 2002(취소진행중), 2211(가상계좌 환불성공) 그 외 에러)
        rtnMap.put("resultMsg",   connector.getResultData("ResultMsg"));    // 결과메시지
        rtnMap.put("cancelAmt",   connector.getResultData("CancelAmt"));    // 취소금액
        rtnMap.put("cancelDate",  connector.getResultData("CancelDate"));  // 취소일
        rtnMap.put("cancelTime",  connector.getResultData("CancelTime"));  // 취소시간
        rtnMap.put("cancelNum",   connector.getResultData("CancelNum"));    // 취소번호
        rtnMap.put("payMethod",   connector.getResultData("PayMethod"));    // 취소 결제수단
        rtnMap.put("mid",         connector.getResultData("MID"));             // 상점 ID
        rtnMap.put("tid",         connector.getResultData("TID"));                // TID
        rtnMap.put("errorCD",     connector.getResultData("ErrorCD"));        // 상세 에러코드
        rtnMap.put("errorMsg",    connector.getResultData("ErrorMsg"));      // 상세 에러메시지
        rtnMap.put("authDate",    connector.getResultData("AuthDate"));      // 거래시간
        rtnMap.put("stateCD",     connector.getResultData("StateCD"));        // 거래상태
        rtnMap.put("promotionCd", connector.getResultData("PromotionCd"));
        rtnMap.put("discountAmt", connector.getResultData("DiscountAmt"));
        rtnMap.put("recoverYn",   connector.getResultData("RecoverYn"));

        rtnMap.put("preCancelCode", connector.getResultData("PreCancelCode")); // 전취소 후취소 구분

        logger.debug("CnsPayCancelController.result rtnMap [{}]", rtnMap);

        Map<String, Object> selData = cnsPayDao.selectPgCustUserNo( param );
        String resultStr = (String) selData.get( "retValue" );
        if( !resultStr.equals(ConstantDefine.SQL_ROK) ) {
            logger.debug("selectPgCustUserNo userID, userNm, custUserNo Get Fail");
        }

        //2017-05-11 : jiyun - 무조건 DB Insert (환경설정에 문제시 result 값에 필수필드가 없음)
        if (checkResultDataOK) {

            // 6. PG 결제취소 처리 데이터 INSERT
            Map<String, Object> payCancelMap = new HashMap<String, Object>();

            String udrDtm = (connector.getResultData("CancelDate").equals("00000000") == true) ? DateUtil.formatDate(new Date(), "yyyyMMddHHmmss") : connector.getResultData("CancelDate") + connector.getResultData("CancelTime");
            String cancelDtm = connector.getResultData("CancelDate") + connector.getResultData("CancelTime");

            payCancelMap.put("udrDtm"           , udrDtm                                    ); /* 결제일시 */
            payCancelMap.put("spCd"             , (String)param.get("spCd")                 ); /* 서비스제공자 */
            payCancelMap.put("custId"           , (String)param.get("custId")               ); /* 고객사 */
            payCancelMap.put("servId"           , (String)param.get("servId")               ); /* 서비스아이디 */
            payCancelMap.put("telNo"            , (String)param.get("telNo")                ); /* 휴대폰 */
            payCancelMap.put("userId"           , (String)param.get("userId")               ); /* 사용자 */
            payCancelMap.put("userNm"           , (String)selData.get("userNm")             );
            payCancelMap.put("custUserNo"       , (String)selData.get("custUserNo")         );
            payCancelMap.put("payCancelCmd"     , payCancelCmd                              ); /* 취소명령(C:전체,P:부분) */
            payCancelMap.put("rstResultCd"      , connector.getResultData("ResultCode")     ); /* 결제 결과코드 */
            payCancelMap.put("rstResultMsg"     , connector.getResultData("ResultMsg")      ); /* 결제 결과메시지 */
            payCancelMap.put("rstErrorCd"       , connector.getResultData("ErrorCD")        ); /* 에러코드 */
            payCancelMap.put("rstErrorMsg"      , connector.getResultData("ErrorMsg")       ); /* 에러메시지 */
            payCancelMap.put("rstCancelAmt"     , connector.getResultData("CancelAmt")      ); /* 취소금액 */
            payCancelMap.put("rstCancelDtm"     , cancelDtm                                 ); /* 취소일시 */
            payCancelMap.put("rstCancelMethod"  , connector.getResultData("PayMethod")      ); /* 취소 결제수단 */
            payCancelMap.put("rstCancelMid"     , (String)param.get("MID")                  ); /* 가맹점 ID */
            payCancelMap.put("rstCancelTid"     , (String)param.get("TID")                  ); /* 거래 ID */
            payCancelMap.put("rstStateCd"       , connector.getResultData("StateCD")        ); /* 거래상태코드 */
            payCancelMap.put("rstPartialFg"     , connector.getResultData("CcPartCl")       ); /* 부분취소 가능여부 */
            payCancelMap.put("rstCancelNo"      , connector.getResultData("CancelNum")      ); /* 취소번호 */
            payCancelMap.put("rstAuthDtm"       , connector.getResultData("AuthDate")       ); /* 승인날짜 */
            payCancelMap.put("rstPromCd"        , connector.getResultData("PromotionCd")    ); /* 프로모션 코드 */
            payCancelMap.put("rstDiscountAmt"   , connector.getResultData("DiscountAmt")    ); /* 프로모션 할인금액 */
            payCancelMap.put("rstRecoverFg"     , connector.getResultData("RecoverYn")      ); /* 프로모션혜택복원여부 */
            payCancelMap.put("rstCancelCd"      , connector.getResultData("PreCancelCode")  ); /* 매입취소구분 */

            logger.debug("payCancelMap [{}]", payCancelMap.get("rstResultCd"));

            try {
                this.cnsPayCancelService.insData(payCancelMap);
            } catch (Exception e) {
                logger.debug("insCnsPayCancel error [{}]", e.getMessage());
            }
        }

        // 취소성공일때만 데이터를 등록하고 사용자를 해지하자. (2001 :해지성공,  2015: 해당거래 취소실패(기취소 거래)
        //if( "2001".equals(resultCode) == true || "2015".equals(resultCode) == true ) {
        //20180308-농협중앙회:가상계좌-환불성공(2211)
        if( "2001".equals(resultCode) == true || "2211".equals(resultCode) == true) {
            Map<String, Object> svcParam = new HashMap<String, Object>();
            svcParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
            svcParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
            svcParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
            svcParam.put( "svcType", "SVCPAYCANCEL" );
            svcParam.put( "custUserNo", StringUtils.defaultString((String)selData.get("custUserNo")) );
            svcParam.put( "code", "200" );
            mobileAuthService.serviceHistWrite(svcParam);
            // 7. 사용자 가입 해지
            Map<String, Object> deregServMap = new HashMap<String, Object>();

            deregServMap.put("spCd"             , (String)param.get("spCd")                 ); /* 서비스제공자 */
            deregServMap.put("custId"           , (String)param.get("custId")               ); /* 고객사 */
            deregServMap.put("servId"           , (String)param.get("servId")               ); /* 서비스아이디 */
            deregServMap.put("mpNo"             , (String)param.get("telNo")                ); /* 휴대폰 */
            deregServMap.put("userId"           , (String)param.get("userId")               ); /* 사용자아이디 */
            deregServMap.put("cancelRsn"        , (String)param.get("CancelMsg")            ); /* 취소사유 */

            logger.debug("deregServMap [{}]", deregServMap);

            String strResult = this.cnsPayCancelService.callProc("cancelServAll", deregServMap);

            logger.debug("cnsPayCancelService.cancelServAll strResult {}", strResult);

            String[] arrResult = strResult.split("\\|");

            if( "00".equals(arrResult[0]) ) {
                model.addAttribute("resultCd", "00");
                model.addAttribute("resultData", "정상처리 되었습니다 !");
            } else {
                model.addAttribute("resultCd", arrResult[0]);
                model.addAttribute("resultData", arrResult[1]);
            }
        }
        else {
            Map<String, Object> svcParam = new HashMap<String, Object>();
            svcParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
            svcParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
            svcParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
            svcParam.put( "svcType", "SVCPAYCANCEL" );
            svcParam.put( "custUserNo", StringUtils.defaultString((String)selData.get("custUserNo")) );
            svcParam.put( "code", "201" );
            mobileAuthService.serviceHistWrite(svcParam);
        }

        model.addAttribute("result", rtnMap);

        return "billing/pay/payCancelResultEx";
    }
}
