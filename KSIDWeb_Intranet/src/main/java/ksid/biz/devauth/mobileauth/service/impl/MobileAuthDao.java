package ksid.biz.devauth.mobileauth.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import ksid.biz.ocuuser.userpayfinal.service.impl.UserPayFinalDao;
import ksid.biz.util.CommonConstantDefine;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.util.CryptoLib;
import ksid.core.webmvc.util.DateLib;
import ksid.core.webmvc.util.KeyGenerate;
import ksid.core.webmvc.util.PayUtil;
import ksid.core.webmvc.util.StringLib;

@Repository
public class MobileAuthDao extends BaseDao<Map<String, Object>> {
    protected static final Logger logger = LoggerFactory.getLogger(MobileAuthDao.class);
    protected static String SEND_MSG_1 = "[지문인증서비스] 인증번호[";
    protected static String SEND_MSG_2 = "] 입니다. 정확히 입력해 주십시오.";
    protected static String SHA256_PASSWD = "ksid0165";
    protected static String SMS_USERID = "ksid01";
    protected static String SMS_SUBJECT = "인증번호";
    protected static String CALLBACK_NUM = "03180600270";
//    protected static String CALLBACK_NUM = "03180600165";
    public static String RESULT_MMS_SEND_TITLE = "◆ 지문 인증 서비스 ◆";
    public static String RESULT_MMS_SEND_SUBTITLE = "지문 인증 서비스 결제가 완료 되었습니다.";
    public static String RESULT_MMS_SEND_BREAKDOWN_0 = "※ 서비스 및 결제 내역";
    public static String RESULT_MMS_SEND_BREAKDOWN_1 = "1. 서비스명 :";
    public static String RESULT_MMS_SEND_BREAKDOWN_2 = "2. 서비스 유효기간 :";
    public static String RESULT_MMS_SEND_BREAKDOWN_3 = "3. 결제 금액 :";
    public static String RESULT_MMS_SEND_BREAKDOWN_4 = "4. 결제 방법 :";
    public static String RESULT_MMS_SEND_BREAKDOWN_5 = "5. 결제 일시 :";
    public static String RESULT_MMS_SEND_APP_TITLE = "※ 한국전자인증FIDO앱 다운로드";
    protected static String RESULT_MMS_SEND_APP_URL_IOS = "https://itunes.apple.com/app/id1275327576​";
    protected static String RESULT_MMS_SEND_APP_URL_ANDROID = "https://play.google.com/store/apps/details?id=com.crosscert.ocu";
    public static String RESULT_MMS_SEND_SI_TITLE = "※ 고객지원정보";
    public static String RESULT_MMS_SEND_SI_1 = "- 전화번호 :";
    public static String RESULT_MMS_SEND_SI_2 = "- 고객지원시간 : 09시30분 ~ 17시30분(월~금)";


    @Autowired
    UserPayFinalDao userPayFinalDao;

    @Override
    protected String getNameSpace() {
        return "NS_MobileAuth";
    }

    @Override
    protected String getMapperId() {
        return "MobileAuth";
    }


    public String mobileAuthReqJob(Map<String, Object> param) {
        String sendMsg = "", resultStr = "";
        String telNo = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");
        String authCodeStr = KeyGenerate.deviceAuthCodeMake();
        String shaStr = CryptoLib.sha256Convert( authCodeStr, SHA256_PASSWD );
        sendMsg = SEND_MSG_1 + authCodeStr + SEND_MSG_2;

        logger.debug("모바일 인증번호 생성 START");
        logger.debug("param custUserNo : [{}]", param.get("custUserNo"));
        logger.debug("sendMsg     : [{}]", sendMsg);
        logger.debug("sendMsgConv : [{}]", CryptoLib.base64EncoderConv(sendMsg));

        param.put( "telNo",       telNo);
        param.put( "sendDtm",     DateLib.getLocalDateTime() );
        param.put( "authCd",      shaStr );
        param.put( "sendMsgOrg",  sendMsg );
        param.put( "sendMsgConv", sendMsg );
//        param.put( "sendMsgConv", CryptoLib.base64EncoderConv(sendMsg) );

//        resultStr = selectAuthReqNumCheck( param );
//        if( !resultStr.equals( CommonConstantDefine.SQL_ROK ) ) {
//            logger.debug("selectAuthReqNumCheck Fail");
//            return(resultStr);
//        }
        String stType = StringUtils.defaultString((String)param.get("type") );
        if( stType.equals(CommonConstantDefine.WEB_SVC_REG) ) {
         // 인증번호 전송 전 학번 및 사번 확인
            List<Map<String, Object>> selCustUserNo = selDataList( "selTctCustUsr", param );
            if( selCustUserNo.size() == 1 ) {
                logger.debug("이미 가입된 학번 존재합니다.");
                return (CommonConstantDefine.CUSTUSERNO_RFAIL );
            }



         // 인증번호 전송 전 가입 휴대번호 확인
//            List<Map<String, Object>> selTelNo = selDataList( "selUserTelNo", param );
//            if( selTelNo.size() == 1 ) {
//                logger.debug("이미 가입된 휴대번호 존재합니다.");
//                return( CommonConstantDefine.TELNO_RFAIL );
//            }
        }
        else if( stType.equals(CommonConstantDefine.WEB_SVC_PAY) || stType.equals(CommonConstantDefine.WEB_SVC_CANCEL) ) {
         // 인증번호 전송 전 학번 및 사번 확인
            List<Map<String, Object>> selCustUserNo = selDataList( "selTctCustUsr", param );
            if( selCustUserNo.size() == 0 ) {
                logger.debug("가입된 학번 정보가 없습니다.");
                return( CommonConstantDefine.CUSTUSERNO_RFAIL );
            }

         // 인증번호 전송 전 가입 휴대번호 확인
//            List<Map<String, Object>> selTelNo = selDataList( "selUserTelNo", param );
//            if( selTelNo.size() == 0 ) {
//                logger.debug("가입된 휴대폰 정보가 없습니다.");
//                return( CommonConstantDefine.TELNO_RFAIL );
//            }

            resultStr = selectMobileAuthStateInfo( param );
            logger.debug("resultStr : {}", resultStr);
            if( !resultStr.equals(CommonConstantDefine.SQL_ROK) && !resultStr.equals(CommonConstantDefine.AUTH_RFAIL) ) {
                return( resultStr );
            }
        }


        // SMS 전송 테이블 Insert
        resultStr = insertRealSmsSend( param );
        if( !resultStr.equals( CommonConstantDefine.SQL_ROK ) ) {
            logger.debug("insertRealSmsSend Fail");
            return( resultStr );
        }

        // SMS Send History DB Write
        resultStr = smsSendHis( param );
        if( !resultStr.equals( CommonConstantDefine.SQL_ROK ) ) {
            logger.debug("insertSmsSendInfo Fail");
            return( resultStr );
        }

        resultStr = insertMobileAuthInfo( param );
        if( !resultStr.equals( CommonConstantDefine.SQL_ROK ) ) {
            logger.debug("insertSmsSendInfo Fail");
            return( resultStr );
        }

        logger.debug("모바일 인증번호 생성 STOP");
        return( CommonConstantDefine.SQL_ROK );
    }


    public String mobileAuthConfirmJob(Map<String, Object> param) {
        int rst;
        String resultStr = "";

        logger.debug("모바일 인증번호 인증 확인 START");

        resultStr = selectMobileAuthInfo( param );
        if( !resultStr.equals(CommonConstantDefine.SQL_ROK) ) {
            return( resultStr );
        }

        resultStr = updateMobileAuthInfo( param );
        if( !resultStr.equals(CommonConstantDefine.SQL_ROK) ) {
            return( resultStr );
        }

        logger.debug("모바일 인증번호 인증 확인 STOP");
        return( resultStr );
    }


    public String mobileAuthDelJob(int flag , Map<String, Object> param) {
        int rst;
        String resultStr = "";

        logger.debug("모바일 인증번호 인증 삭제 START");
        if( flag == 1 ) {
        rst = deleteMobileAuthInfo( param );
            if( rst != CommonConstantDefine.ROK ) {
                return(CommonConstantDefine.SQL_RFAIL);
            }
        }
        else if( flag == 2 ) {
            rst = deleteMobileAuthInfoCustNo( param );
        }

        logger.debug("모바일 인증번호 인증 삭제 STOP");
        return( CommonConstantDefine.SQL_ROK );
    }


    public String mobileAuthRegChkJob(Map<String, Object> param) {
        String resultStr = "";

        logger.debug("모바일 인증번호 가입 검사 START");

        resultStr = selectMobileAuthStateInfo(param);

        logger.debug("모바일 인증번호 가입 검사 STOP");
        return( resultStr );
    }


    public String mobileAuthReqNumChkJob(Map<String, Object> param) {
        String resultStr = "";

        logger.debug("모바일 인증번호 가입 검사 START");

        resultStr = selectMobileAuthStateInfo(param);

        logger.debug("모바일 인증번호 가입 검사 STOP");
        return( resultStr );
    }

    // 사용자 가입 유무 확인
    public String userRegStateCheckJob(Map<String, Object> param) {
        String resultStr = "";

        logger.debug("사용자 가입 상태 확인 START");

        resultStr = selectUserRegStateCheck(param);

        logger.debug("사용자 가입 상태 확인 STOP");
        return( resultStr );
    }


    public String insertRealSmsSend(Map<String, Object> sparam)
    {
        String sendMsg = "";
        Map<String, Object> insParam = new HashMap<String, Object>();

        logger.debug("telNo    : [{}]", insParam.get("telNo"));

        insParam.put( "userId",   SMS_USERID );
        insParam.put( "subject",  sparam.get("sendDtm") );
        insParam.put( "smsMsg",   sparam.get("sendMsgOrg") );
        insParam.put( "nowDate",  DateLib.getLocalDateTime() );
        insParam.put( "sendDate", DateLib.getLocalDateTime() );
        insParam.put( "callback", CALLBACK_NUM );
        String destMsg = sparam.get("telNo") + "^" + sparam.get("telNo");
        insParam.put( "destInfo", destMsg );

        logger.debug("userId      : [{}]", insParam.get("userId"));
        logger.debug("subject     : [{}]", insParam.get("subject"));
        logger.debug("smsMsg      : [{}]", insParam.get("smsMsg"));
        logger.debug("callbackUrl : [{}]", insParam.get("callbackUrl"));
        logger.debug("nowDate     : [{}]", insParam.get("nowDate"));
        logger.debug("sendDate    : [{}]", insParam.get("sendDate"));
        logger.debug("callback    : [{}]", insParam.get("callback"));
        logger.debug("destInfo    : [{}]", insParam.get("destInfo"));

        try {
            int insCnt = insData( "insSdkSmsSend", insParam );
            if( insCnt != CommonConstantDefine.INS_DEL_MAX_CNT ) {
                logger.debug("insertRealSmsSend Insert[SDK_SMS_SEND] Fail");
                return( CommonConstantDefine.SQL_RFAIL );
            }
        } catch(Exception e) {
            logger.debug("insertRealSmsSend Exception 발생 - Insert[SDK_SMS_SEND] Fail");
            return( CommonConstantDefine.SQL_RFAIL );
        }
        return( CommonConstantDefine.SQL_ROK );
    }


    public String insertRealMmsSend(Map<String, Object> sparam)
    {
        String sendMsg = "";
        Map<String, Object> insParam = new HashMap<String, Object>();

        logger.debug("telNo    : [{}]", insParam.get("telNo"));

        logger.debug("sendMsgOrg    : [{}]", sparam.get("sendMsgOrg"));
        insParam.put( "userId",   SMS_USERID );
        insParam.put( "nowDate",  DateLib.getLocalDateTime() );
        insParam.put( "sendDate", DateLib.getLocalDateTime() );
        insParam.put( "callback", CALLBACK_NUM );
        String destMsg = sparam.get("telNo") + "^" + sparam.get("telNo");
        insParam.put( "destInfo", destMsg );
        insParam.put( "mmsMsg",   sparam.get("sendMsgOrg") );

        logger.debug("userId      : [{}]", insParam.get("userId"));
        logger.debug("mmsMsg      : [{}]", insParam.get("mmsMsg"));
        logger.debug("nowDate     : [{}]", insParam.get("nowDate"));
        logger.debug("sendDate    : [{}]", insParam.get("sendDate"));
        logger.debug("callback    : [{}]", insParam.get("callback"));
        logger.debug("destInfo    : [{}]", insParam.get("destInfo"));

        try {
            int insCnt = insData( "insSdkMmsSend", insParam );
            if( insCnt != CommonConstantDefine.INS_DEL_MAX_CNT ) {
                logger.debug("insertRealMmsSend Insert[SDK_MMS_SEND] Fail");
                return( CommonConstantDefine.SQL_RFAIL );
            }
        } catch(Exception e) {
            logger.debug("insertRealMmsSend Exception 발생 - Insert[SDK_MMS_SEND] Fail");
            return( CommonConstantDefine.SQL_RFAIL );
        }
        return( CommonConstantDefine.SQL_ROK );
    }



    // 기기 인증 SMS 발송 DB(TIM_SMS_SEND_INFO) INSERT
    public String insertSmsSendInfo(Map<String, Object> sparam)
    {
        String sendMsg = "";
        Map<String, Object> insParam = new HashMap<String, Object>();

        insParam.put( "telNo",    sparam.get("telNo") );
        insParam.put( "authCd",   sparam.get("authCd") );
        insParam.put( "sendDtm",  sparam.get("sendDtm") );
        insParam.put( "sendKind", CommonConstantDefine.SMS );
        insParam.put( "sendMsg",  sparam.get("sendMsgOrg") );
        insParam.put( "regDtm",   DateLib.getLocalDateTime() );

        logger.debug("telNo    : [{}]", insParam.get("telNo"));
        logger.debug("authCd   : [{}]", insParam.get("authCd"));
        logger.debug("sendDtm  : [{}]", insParam.get("sendDtm"));
        logger.debug("sendKind : [{}]", insParam.get("sendKind"));
        logger.debug("sendMsg  : [{}]", insParam.get("sendMsg"));
        logger.debug("regDtm   : [{}]", insParam.get("regDtm"));

        try {
            int insCnt = insData( "insTidSmsSendInfo", insParam );
            if( insCnt != CommonConstantDefine.INS_DEL_MAX_CNT ) {
                logger.debug("smsSendDbInsert Insert[TIM_SMS_SEND_INFO] Fail");
                return( CommonConstantDefine.SQL_RFAIL );
            }
        } catch(Exception e) {
            logger.debug("smsSendDbInsert Exception 발생 - Insert[TIM_SMS_SEND_INFO] Fail");
            return( CommonConstantDefine.SQL_RFAIL );
        }
        return( CommonConstantDefine.SQL_ROK );
    }


    // 기기 인증 코드 DB(TIM_MOBILE_AUTH_INFO) INSERT
    public String insertMobileAuthInfo(Map<String, Object> sparam)
    {
        Map<String, Object> insParam = new HashMap<String, Object>();
        logger.debug("sendDtm : [{}]", sparam.get("sendDtm"));

        insParam.put( "spCd",       sparam.get("spCd") );
        insParam.put( "custId",     sparam.get("custId") );
        insParam.put( "servId",     sparam.get("servId") );
        insParam.put( "telNo",      sparam.get("telNo") );
        insParam.put( "custUserNo", sparam.get("custUserNo") );
        insParam.put( "authCd",     sparam.get("authCd") );
        insParam.put( "authStatus", CommonConstantDefine.MOBILE_AUTH_NOK );
        insParam.put( "validDtm",   sparam.get("sendDtm") );


        logger.debug("spCd       : [{}]", insParam.get("spCd"));
        logger.debug("custId     : [{}]", insParam.get("custId"));
        logger.debug("servId     : [{}]", insParam.get("servId"));
        logger.debug("telNo      : [{}]", insParam.get("telNo"));
        logger.debug("custUserNo : [{}]", insParam.get("custUserNo"));
        logger.debug("authCd     : [{}]", insParam.get("authCd"));
        logger.debug("authStatus : [{}]", insParam.get("authStatus"));
        logger.debug("validDtm   : [{}]", insParam.get("sendDtm"));

        try {
            int insCnt = insData( "insTimMobileAuthInfo", insParam );
            if( insCnt != CommonConstantDefine.INS_DEL_MAX_CNT ) {
                logger.debug("insTimMobileAuthInfo Insert[TIM_MOBILE_AUTH_INFO] Fail");
                return( CommonConstantDefine.SQL_RFAIL );
            }
        } catch(Exception e) {
            logger.debug("insTimMobileAuthInfo Exception 발생 - Insert[TIM_MOBILE_AUTH_INFO] Fail");
            return( CommonConstantDefine.SQL_RFAIL );
        }
        return( CommonConstantDefine.SQL_ROK );
    }


    public String smsSendHis(Map<String, Object> param) {
        Map<String, Object> insParam = new HashMap<String, Object>();

        insParam.put( "spCd",       param.get("spCd") );
        insParam.put( "custId",     param.get("custId") );
        insParam.put( "servId",     param.get("servId") );
        insParam.put( "telNo",      param.get("telNo") );
        insParam.put( "sendDtm",    DateLib.getLocalDateTime() );
        insParam.put( "sendKind",   CommonConstantDefine.SMS );
        insParam.put( "sendMsg",    param.get("sendMsgConv") );

        try {
            int insCnt = insData( "insTimSmsSendHis", insParam );
            if( insCnt != 1 ) {
                logger.debug("Insert[TIM_SMS_SEND_HIS] Fail");
                return( CommonConstantDefine.SQL_RFAIL );
            }
        } catch (Exception e) {
            logger.debug("Exception 발생 - Insert[TIM_SMS_SEND_HIS]");
            return( CommonConstantDefine.SQL_RFAIL );
        }
        return( CommonConstantDefine.SQL_ROK );
    }


    public String selectMobileAuthInfo(Map<String, Object> param) {
        int rst;
        Map<String, Object> selParam = new HashMap<String, Object>();

        String curDate = DateLib.getLocalDateTime();
        String telNo = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");
        String shaStr = CryptoLib.sha256Convert( (String) param.get("authNo"), SHA256_PASSWD );

        selParam.put( "spCd",   param.get("spCd") );
        selParam.put( "custId", param.get("custId") );
        selParam.put( "servId", param.get("servId") );
        selParam.put( "telNo",  telNo );
        selParam.put( "authCd", shaStr );

        logger.debug("selParam spCd   : [{}]", selParam.get("spCd"));
        logger.debug("selParam custId : [{}]", selParam.get("custId"));
        logger.debug("selParam servId : [{}]", selParam.get("servId"));
        logger.debug("selParam telNo  : [{}]", selParam.get("telNo"));
        logger.debug("selParam authCd : [{}]", selParam.get("authCd"));

        List<Map<String, Object>> selListdata = selDataList( "selMobileAuthInfo", selParam );
        if( selListdata.size() != 1  ) {
            return( CommonConstantDefine.SQL_RFAIL );
        }

        String authDate = (String) selListdata.get(0).get("validDtm");
        long secDate = DateLib.getDateTimeBetweenToSec(curDate, authDate);

        // UIReflash 시 인증 시간 체크 2분 (120)
//        if( secDate >= 120 ) {
//            logger.debug("인증 유효시간 2분 초과 -> 인증시간 [{}], 가입시간 [{}]", authDate, curDate);
//            rst = deleteMobileAuthInfo( param );
//            if( rst != CommonConstantDefine.ROK ) {
////                return(CommonConstantDefine.SQL_RFAIL);
//            }
//            return(CommonConstantDefine.TIMEOUT_RFAIL);
//        }


        int authStat = Integer.parseInt( (String) selListdata.get(0).get("authStatus") );
        logger.debug("authStat :  [{}]", authStat);
        if( authStat == 1 ) {
            logger.debug("이미 인증된 번호입니다. ");
            return( CommonConstantDefine.AUTH_RFAIL );
        }
        return( CommonConstantDefine.SQL_ROK );
    }


    public String updateMobileAuthInfo(Map<String, Object> param) {
        Map<String, Object> selParam = new HashMap<String, Object>();

        logger.debug("authCd   : [{}]", param.get("authNo"));

        String telNo = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");
        String shaStr = CryptoLib.sha256Convert( (String) param.get("authNo"), SHA256_PASSWD );

        logger.debug("telNo   : [{}]", telNo);

        selParam.put( "spCd",   param.get("spCd") );
        selParam.put( "custId", param.get("custId") );
        selParam.put( "servId", param.get("servId") );
        selParam.put( "telNo",  telNo );
        selParam.put( "authCd", shaStr );

        int updCnt = updData( "updMobileAuthInfo", selParam );
        if( updCnt != 1  ) {
            return( CommonConstantDefine.SQL_RFAIL );
        }
        return( CommonConstantDefine.SQL_ROK );
    }


    public int deleteMobileAuthInfo(Map<String, Object> param) {
        Map<String, Object> selParam = new HashMap<String, Object>();

        String telNo = StringUtils.defaultString((String)param.get("spNo"))
                     + StringUtils.defaultString((String)param.get("kookBun"))
                     + StringUtils.defaultString((String)param.get("junBun"));
//        String authNo = StringUtils.defaultString((String)param.get("authNo"));
//        String shaStr = null;
//        logger.debug("authNo   : [{}]", authNo );
//        if (authNo.length() > 0) {
//            shaStr = CryptoLib.sha256Convert( authNo, SHA256_PASSWD );
//        } else {
//            return(CommonConstantDefine.RFAIL);
//        }

        selParam.put( "spCd",   StringUtils.defaultString((String)param.get("spCd")) );
        selParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        selParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );
        selParam.put( "telNo",  telNo );
//        selParam.put("authCd", shaStr);

        logger.debug("spCd   : [{}]", selParam.get("spCd"));
        logger.debug("custId : [{}]", selParam.get("custId"));
        logger.debug("servId : [{}]", selParam.get("servId"));
        logger.debug("telNo  : [{}]", selParam.get("telNo"));

        int delCnt = delData( "delMobileAuthInfo", selParam );
        if( delCnt != 1  ) {
            return( CommonConstantDefine.RFAIL );
        }
        return( CommonConstantDefine.ROK );
    }


    public int deleteMobileAuthInfoCustNo(Map<String, Object> param) {
        Map<String, Object> selParam = new HashMap<String, Object>();

        selParam.put( "spCd",       StringUtils.defaultString((String)param.get("spCd")) );
        selParam.put( "custId",     StringUtils.defaultString((String)param.get("custId")) );
        selParam.put( "servId",     StringUtils.defaultString((String)param.get("servId")) );
        selParam.put( "custUserNo", StringUtils.defaultString((String)param.get("custUserNo")) );

        logger.debug("spCd   : [{}]", selParam.get("spCd"));
        logger.debug("custId : [{}]", selParam.get("custId"));
        logger.debug("servId : [{}]", selParam.get("servId"));
        logger.debug("custUserNo  : [{}]", selParam.get("custUserNo"));

        int delCnt = delData( "delMobileAuthInfoCustNo", selParam );
        if( delCnt != 1  ) {
            return( CommonConstantDefine.RFAIL );
        }
        return( CommonConstantDefine.ROK );
    }


    public String selectMobileAuthStateInfo(Map<String, Object> param) {
        int rst;
        Map<String, Object> selParam = new HashMap<String, Object>();
        String curDate = DateLib.getLocalDateTime();
        String telNo = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");
        String shaStr = CryptoLib.sha256Convert( (String) param.get("authNo"), SHA256_PASSWD );
        logger.debug("param authNm   : [{}]", param.get("authNo"));
        logger.debug("param shaStr   : [{}]", shaStr);
        selParam.put( "spCd",   param.get("spCd") );
        selParam.put( "custId", param.get("custId") );
        selParam.put( "servId", param.get("servId") );
        selParam.put( "telNo",  telNo );
        selParam.put( "authCd", shaStr );

        logger.debug("selParam spCd   : [{}]", selParam.get("spCd"));
        logger.debug("selParam custId : [{}]", selParam.get("custId"));
        logger.debug("selParam servId : [{}]", selParam.get("servId"));
        logger.debug("selParam telNo  : [{}]", selParam.get("telNo"));
        logger.debug("selParam authCd : [{}]", selParam.get("authCd"));

        List<Map<String, Object>> selListdata = selDataList( "selMobileAuthStatusInfo", selParam );
        if( selListdata.size() != 1  ) {
            return( CommonConstantDefine.AUTH_RFAIL );
        }
        int authStat = Integer.parseInt( (String) selListdata.get(0).get("authStatus") );
        logger.debug("authStat :  [{}]", authStat);
        if( authStat == 2 ) {
            logger.debug("휴대폰 미인증 상태입니다. ");
            return( CommonConstantDefine.AUTH_RFAIL );
        }

//        String authDate = (String) selListdata.get(0).get("validDtm");
//
//        long secDate = DateLib.getDateTimeBetweenToSec(curDate, authDate);

        // 생성 된 인증 번호에 대해 10분 인증상태 유지(600)
//        if( secDate >= 120 ) {
//            logger.debug("가입 유효시간 10분 초과 -> 인증시간 [{}], 가입시간 [{}]", authDate, curDate);
//            rst = deleteMobileAuthInfo(param);
//            if( rst != CommonConstantDefine.ROK ) {
////                return(CommonConstantDefine.SQL_RFAIL);
//            }
//            return(CommonConstantDefine.TIMEOUT_RFAIL);
//        }
        return( CommonConstantDefine.SQL_ROK );
    }


 // 사용자 가입 정보 SELECT
    public String selectUserRegStateCheck(Map<String, Object> param) {
        String resultStr = "";
        Map<String, Object> selParam = new HashMap<String, Object>();

        String curDate = DateLib.getLocalDateTime();
        String telNo = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

        selParam.put( "spCd",       param.get("spCd") );
        selParam.put( "custId",     param.get("custId") );
        selParam.put( "servId",     param.get("servId") );
        selParam.put( "mpNo",       telNo );
        selParam.put( "custUserNo", StringUtils.defaultString((String)param.get("custUserNo")) );

        // 금결원 핸드폰 Key 구조
//        List<Map<String, Object>> selListUserNo = selDataList( "selUserNoCheck", selParam );
//        if( selListUserNo.size() > 0 ) {
//            String selTelNo = (String) selListUserNo.get(0).get( "mpNo" );
//            logger.debug("a 111-1" );
//            if( !telNo.equals( selTelNo ) ) {
//                logger.debug("a 111-2" );
//                logger.debug("[{}] 가입 고객 사용자 정보 불일치, 번호변경 가능성", telNo);
//                return( CommonConstantDefine.USERINFO_RFAIL );
//            }
//        }
//        logger.debug("a 22222" );
//        logger.debug("selListUserNo userid  : [{}]", StringUtils.defaultString((String) selListUserNo.get(0).get("userId")) );
//        selParam.put( "userId", StringUtils.defaultString((String) selListUserNo.get(0).get("userId")) );

        List<Map<String, Object>> selListData1 = selDataList( "selUserRegCheck", selParam );
        if( selListData1.size() != 1  ) {
            logger.debug("[{}] 미가입 사용자", telNo);
            return( CommonConstantDefine.SQL_RFAIL );
        }

        selParam.put( "userId", StringUtils.defaultString((String) selListData1.get(0).get("userId")) );
        logger.debug("selParam after spCd   : [{}]", selListData1.get(0).get("spCd"));
        logger.debug("selParam after custId : [{}]", selListData1.get(0).get("custId"));
        logger.debug("selParam after userId : [{}]", selListData1.get(0).get("userId"));
        List<Map<String, Object>> selListData2 = selDataList( "selTslUserServProdPay", selParam );
        if( selListData2.size() != 1 ) {
            logger.debug("[{}] 미결재 사용자", StringUtils.defaultString((String)selParam.get("custUserNo")));
            return( CommonConstantDefine.AUTH_RFAIL );
        }

        List<Map<String, Object>> selListData3 = selDataList( "selDeregPayChk", selParam );
        if( selListData3.size() == 1  ) {
            int intCurDate = Integer.parseInt( curDate.substring(0, 8) );
            String payDtm = StringUtils.defaultString( (String)selListData3.get(0).get("payDtm") );
            String cancelDay = String.valueOf( selListData3.get(0).get("cancelDay"));
            int intCancelDay = Integer.parseInt( DateLib.addDaysToDateString(payDtm.substring(0, 8), Integer.parseInt(cancelDay)) );
            logger.debug("intCurDate : [{}]", intCurDate);
            logger.debug("payDtm     : [{}]", payDtm);
            logger.debug("cancelDay  : [{}]", cancelDay);
            logger.debug("intCancelDay  : [{}]", intCancelDay);
            if( intCurDate < intCancelDay ) {
                return( CommonConstantDefine.USER_PAY );
            }
        }

        return( CommonConstantDefine.SQL_ROK );
    }


    public String selectAuthReqNumCheck(Map<String, Object> param) {
        int rst;
        Map<String, Object> selParam = new HashMap<String, Object>();
        String curDate = DateLib.getLocalDateTime();
        String telNo = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

        selParam.put( "spCd",   param.get("spCd") );
        selParam.put( "custId", param.get("custId") );
        selParam.put( "servId", param.get("servId") );
        selParam.put( "telNo",  telNo );

        logger.debug("selParam spCd   : [{}]", selParam.get("spCd"));
        logger.debug("selParam custId : [{}]", selParam.get("custId"));
        logger.debug("selParam servId : [{}]", selParam.get("servId"));
        logger.debug("selParam telNo  : [{}]", selParam.get("telNo"));

        List<Map<String, Object>> selListdata = selDataList( "selAuthReqNumCheck", selParam );
        if( selListdata.size() > 0  ) {
            return( CommonConstantDefine.AUTH_RFAIL );
        }

        return( CommonConstantDefine.SQL_ROK );
    }


    public Map<String, Object> selectPGMidInfo(Map<String, Object> param) {
        Map<String, Object> selParam = new HashMap<String, Object>();

        List<Map<String, Object>> selListdata = selDataList( "selMidJoinInfo", param );
        if( selListdata.size() != 1  ) {
            selParam.put( "retValue", CommonConstantDefine.SQL_RFAIL );
            return( selParam );
        }

        selParam.put( "pgCd",     StringUtils.defaultString((String) selListdata.get(0).get("pgCd")) );
        selParam.put( "payMid",   StringUtils.defaultString((String) selListdata.get(0).get("payMid")) );
        selParam.put( "midKey",   StringUtils.defaultString((String) selListdata.get(0).get("midKey")) );
        selParam.put( "retValue", CommonConstantDefine.SQL_ROK );

        return(selParam );
    }

    public Map<String, Object> selectPayReqInfo(Map<String, Object> param) {
        Map<String, Object> selParam = new HashMap<String, Object>();


        List<Map<String, Object>> selListdata = selDataList( "selBilPrice", param );
        if( selListdata.size() != 1  ) {
            selParam.put( "retValue", CommonConstantDefine.SQL_RFAIL );
            return( selParam );
        }

        Map<String, Object> selMidParam = selectPGMidInfo(param);
        String retValue = StringUtils.defaultString( (String) selMidParam.get("retValue") );
        if( !retValue.equals(CommonConstantDefine.SQL_ROK) ) {
            selParam.put( "retValue", CommonConstantDefine.SQL_RFAIL );
            return( selParam );
        }
        String ediDate = PayUtil.getDate("yyyyMMddHHmmss");

        String MID         = StringUtils.defaultString( (String) selMidParam.get("payMid") );
        String merchantKey = StringUtils.defaultString( (String) selMidParam.get("midKey") );

        int Amt = Integer.parseInt(String.valueOf(selListdata.get(0).get("billPrice")));
        String md_src = ediDate + MID + Amt;
        String hashString = PayUtil.SHA256Salt( md_src, merchantKey );

        selParam.put( "servNm",     StringUtils.defaultString((String) selListdata.get(0).get("servNm")) );
        selParam.put( "billPrice",  Amt );
        selParam.put( "spNo",       StringUtils.defaultString((String) param.get("spNo")) );
        selParam.put( "kookBun",    StringUtils.defaultString((String) param.get("kookBun")) );
        selParam.put( "junBun",     StringUtils.defaultString((String) param.get("junBun")) );
        selParam.put( "ediDate",    ediDate );
        selParam.put( "hashString", hashString );
        selParam.put( "mid",        MID );
        selParam.put( "retValue",   CommonConstantDefine.SQL_ROK );

        return( selParam );
    }


    public Map<String, Object> selectMmsSendInfo(Map<String, Object> param) {
        Map<String, Object> selParam = new HashMap<String, Object>();

        logger.debug("param spCd   : [{}]", param.get("spCd"));
        logger.debug("param custId : [{}]", param.get("custId"));
        logger.debug("param servId : [{}]", param.get("servId"));
        logger.debug("param userId : [{}]", param.get("userId"));

        List<Map<String, Object>> selListdata = selDataList( "selMmsSendInfo", param );
        if( selListdata.size() != 1  ) {
            selParam.put( "retValue", "CommonConstantDefine.SQL_RFAIL" );
            return( selParam );
        }

        selParam.put( "servNm",    selListdata.get(0).get("servNm") );
        selParam.put( "servStDtm", selListdata.get(0).get("servStDtm") );
        selParam.put( "servEdDtm", selListdata.get(0).get("servEdDtm") );
        String strPrice = String.valueOf(selListdata.get(0).get("billPrice"));
        logger.debug("selParam strPrice : [{}]", strPrice);
        selParam.put( "billPrice", strPrice );
        selParam.put( "retValue",  "CommonConstantDefine.SQL_OK" );

        logger.debug("selParam servNm    : [{}]", selParam.get("servNm"));
        logger.debug("selParam servStDtm : [{}]", selParam.get("servStDtm"));
        logger.debug("selParam servEdDtm : [{}]", selParam.get("servEdDtm"));
        logger.debug("selParam billPrice : [{}]", selParam.get("billPrice"));

        return( selParam );
    }

    public String mmsSendMessage(Map<String, Object> recvParam) {
        String resultStr = "";

        recvParam.put( "payRstDtm",    DateLib.getLocalDateTime() );
        Map<String, Object> mmsInfoData = userPayFinalDao.selectCustUserNoAndUserId( recvParam );

        String retValue = (String) mmsInfoData.get( "retValue" );
        logger.debug("mmsSendMessage retValue : [{}]", retValue);
        if( retValue.equals("CommonConstantDefine.SQL_RFAIL") ) {
            logger.debug("mmsSendMessage Fail");
            return( CommonConstantDefine.SQL_RFAIL );
        }

        recvParam.put( "sendDtm",    DateLib.getLocalDateTime() );
        StringBuffer mmsMsg = new StringBuffer("");
        mmsMsg.append( RESULT_MMS_SEND_TITLE );
        mmsMsg.append( "\n" );
        mmsMsg.append( RESULT_MMS_SEND_SUBTITLE );
        mmsMsg.append( "\n\n" );
        mmsMsg.append( RESULT_MMS_SEND_BREAKDOWN_0 );
        mmsMsg.append( "\n" );
        mmsMsg.append( RESULT_MMS_SEND_BREAKDOWN_1 );
        mmsMsg.append( " " );
        mmsMsg.append( (String) mmsInfoData.get("servNm") );
        mmsMsg.append( "\n" );
        mmsMsg.append( RESULT_MMS_SEND_BREAKDOWN_2 );
        mmsMsg.append( " " );
        mmsMsg.append( (String) mmsInfoData.get("servStDtm") );
        mmsMsg.append( " ~ " );
        mmsMsg.append( (String) mmsInfoData.get("servEdDtm") );
        mmsMsg.append( "\n" );
        mmsMsg.append( RESULT_MMS_SEND_BREAKDOWN_3 );
        mmsMsg.append( " " );
        mmsMsg.append( (String)mmsInfoData.get("payAmt") );
        mmsMsg.append( "원" );
        mmsMsg.append( "\n" );
        mmsMsg.append( RESULT_MMS_SEND_BREAKDOWN_4 );
        mmsMsg.append( " " );
        mmsMsg.append( (String) mmsInfoData.get("payMthod") );
        mmsMsg.append( "\n" );
        mmsMsg.append( RESULT_MMS_SEND_BREAKDOWN_5 );
        mmsMsg.append( " " );
        mmsMsg.append( (String) mmsInfoData.get("payRstDtm") );
        mmsMsg.append( "\n\n" );

        String mobileOs = StringUtils.defaultString((String)recvParam.get("mpOsTp") );
        if( mobileOs.equals("I") ) {
            mmsMsg.append( RESULT_MMS_SEND_APP_TITLE );
            mmsMsg.append( "[iOS]" );
            mmsMsg.append( "\n" );
            mmsMsg.append( RESULT_MMS_SEND_APP_URL_IOS );
        }
        else if( mobileOs.equals("A") ) {
            mmsMsg.append( RESULT_MMS_SEND_APP_TITLE );
            mmsMsg.append( "[Android]" );
            mmsMsg.append( "\n" );
            mmsMsg.append( RESULT_MMS_SEND_APP_URL_ANDROID );
        }
//        mmsMsg.append( (String)recvParam.get("mpOsTp") );
//        mmsMsg.append( "\n\n" );
//        mmsMsg.append( RESULT_MMS_SEND_SI_TITLE );
//        mmsMsg.append( "\n" );
//        mmsMsg.append( RESULT_MMS_SEND_SI_1 );
//        mmsMsg.append( " " );
//        mmsMsg.append( "031-8060-0165" );
//        mmsMsg.append( "\n" );
//        mmsMsg.append( RESULT_MMS_SEND_SI_2 );
        recvParam.put( "sendMsgOrg", mmsMsg.toString() );
        resultStr = insertRealMmsSend( recvParam );
        if( !resultStr.equals( CommonConstantDefine.SQL_ROK ) ) {
            logger.debug("mmsSendMessage Fail");
            return( CommonConstantDefine.SQL_RFAIL );
        }

        return( CommonConstantDefine.SQL_ROK );
    }

}
