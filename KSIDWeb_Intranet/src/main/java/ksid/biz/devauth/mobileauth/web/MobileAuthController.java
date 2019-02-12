package ksid.biz.devauth.mobileauth.web;

import java.io.File;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.devauth.mobileauth.service.MobileAuthService;
import ksid.biz.devauth.mobileauth.service.impl.MobileAuthDao;
import ksid.biz.util.CommonConstantDefine;
import ksid.core.webmvc.base.web.BaseController;
import ksid.core.webmvc.util.ConstantDefine;
import ksid.core.webmvc.util.DateLib;
import ksid.core.webmvc.util.OsUtilLib;

@Controller
@RequestMapping(value= {"devauth/mobileauth"})
public class MobileAuthController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(MobileAuthController.class);


    @Autowired
    private MobileAuthDao mobileAuthDao;

    @Autowired
    private MobileAuthService mobileAuthService;

    @RequestMapping(value= {"authNumReq"})
    public String authNumReq(@RequestParam Map<String, Object> param, Model model) {
        String resultStr = "";

        logger.debug("authNumReq.view param [{}]", param);

        resultStr = mobileAuthDao.mobileAuthReqJob( param );

        logger.debug("resultStr : [{}]", resultStr);
        model.addAttribute("resultCd", resultStr);
//        model.addAttribute("resultData", resultData);
        return "json";
    }


    @RequestMapping(value= {"authConfirm"})
    public String authConfirm(@RequestParam Map<String, Object> param, Model model) {
        String resultStr = "";

        logger.debug("authConfirm.view param [{}]", param);

        resultStr = mobileAuthDao.mobileAuthConfirmJob(param);

        logger.debug("resultStr : [{}]", resultStr);
        model.addAttribute("resultCd", resultStr);
//        model.addAttribute("resultData", resultData);
        return "json";
    }


    @RequestMapping(value= {"authNumDel"})
    public String authNumDel(@RequestParam Map<String, Object> param, Model model) {
        String resultStr = "";

        logger.debug("authNumDel.view param [{}]", param);

        resultStr = mobileAuthDao.mobileAuthDelJob( 1, param );

        logger.debug("resultStr : [{}]", resultStr);
        model.addAttribute("resultCd", resultStr);
//        model.addAttribute("resultData", resultData);
        return "json";
    }

    @RequestMapping(value= {"authUserNumDel"})
    public String authUserNumDel(@RequestParam Map<String, Object> param, Model model) {
        String resultStr = "";

        logger.debug("authNumDel.view param [{}]", param);

        resultStr = mobileAuthDao.mobileAuthDelJob( 2, param );

        logger.debug("resultStr : [{}]", resultStr);
        model.addAttribute("resultCd", resultStr);
//        model.addAttribute("resultData", resultData);
        return "json";
    }



    @RequestMapping(value= {"authRegChk"})
    public String authRegChk(@RequestParam Map<String, Object> param, Model model) {
        String resultStr = "";

        logger.debug("authRegChk.view param [{}]", param);

        resultStr = mobileAuthDao.mobileAuthRegChkJob( param );

        logger.debug("resultStr : [{}]", resultStr);
        model.addAttribute("resultCd", resultStr);
//        model.addAttribute("resultData", resultData);
        return "json";
    }


    @RequestMapping(value= {"svrComboList"})
    public String svrComboList(@RequestParam Map<String, Object> param, Model model) {
        String resultStr = "";

        logger.debug("svrComboList.view param [{}]", param);

        resultStr = mobileAuthDao.mobileAuthReqJob( param );

        logger.debug("resultStr : [{}]", resultStr);
        model.addAttribute("resultCd", resultStr);
//        model.addAttribute("resultData", resultData);
        return "json";
    }

    @RequestMapping(value= {"userRegCheck"})
    public String userRegCheck(@RequestParam Map<String, Object> param, Model model) {
        String resultStr = "";

        logger.debug("userRegCheck.view param [{}]", param);

        resultStr = mobileAuthDao.userRegStateCheckJob( param );

        logger.debug("resultStr : [{}]", resultStr);
        model.addAttribute("resultCd", resultStr);
        return "json";
    }


    @RequestMapping(value= {"servicehist"})
    public String serviceHistWrite(@RequestParam Map<String, Object> param, Model model) {

        Map<String, Object> sendParam = mobileAuthService.serviceHistWrite(param);

        logger.debug("sendParam : [{}]", sendParam);
        model.addAttribute("rstParam", sendParam);
        return "json";
    }


    @RequestMapping(value= {"fidoCodeRst"})
    public String fidoResultCodeMsg(@RequestParam Map<String, Object> param, Model model) {
        Map<String, Object> sendParam = new HashMap<String, Object>();

        logger.debug("fidoCodeRst.view param [{}]", param);

        List<Map<String, Object>> selCodeInfo = mobileAuthDao.selDataList( "selFidoCodeStr", param );
        if( selCodeInfo.size() != 1 ) {
            logger.debug("Fido Error Code Search Fail Select Count [{}]", selCodeInfo.size());
            String errCode = "알수 없는 코드 : " + StringUtils.defaultString((String)selCodeInfo.get(0).get("code"));
            sendParam.put( "codeRemark", errCode );
            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
            model.addAttribute("rstParam", sendParam);
            return "json";
        }


        logger.debug("sel CodeRemark : [{}]", StringUtils.defaultString((String)selCodeInfo.get(0).get("codeRemark")));
        sendParam.put( "codeRemark", StringUtils.defaultString((String)selCodeInfo.get(0).get("codeRemark")) );
        sendParam.put( "retValue", ConstantDefine.SQL_ROK );

        logger.debug("sendParam : [{}]", sendParam);
        model.addAttribute("rstParam", sendParam);
        return "json";
    }


    @RequestMapping(value= {"userStatChk"})
    public String userStatChk(@RequestParam Map<String, Object> param, Model model) throws ParseException {
        String resultStr = "";
        Map<String, Object> sendParam = new HashMap<String, Object>();

        logger.debug("userStatChk.view param [{}]", param);

        Date curtDate = new Date();
        List<Map<String, Object>> selListUserNo = mobileAuthDao.selDataList( "selUserNoCheck", param );
        if( selListUserNo.size() != 1 ) {
            logger.debug("CustUserNo Search Fail Select Count [{}]", selListUserNo.size());
            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
            model.addAttribute("rstParam", sendParam);
            return "json";
        }
        String telNo = StringUtils.defaultString( (String) selListUserNo.get(0).get("mpNo") );
        String userId = StringUtils.defaultString( (String) selListUserNo.get(0).get("userId") );
        String phoneOs = StringUtils.defaultString( (String) selListUserNo.get(0).get("mpOsTp") );
        param.put( "mpNo", telNo );
        param.put( "userId", userId );

        List<Map<String, Object>> selListData2 = mobileAuthDao.selDataList( "selTslCustProdUserBill", param );
        String spNo    = telNo.substring(0, 3);
        String kookBun = telNo.substring(3, 7);
        String junBun  = telNo.substring(7, 11);
        sendParam.put( "spNo",       spNo );
        sendParam.put( "kookBun",    kookBun );
        sendParam.put( "junBun",     junBun );
        sendParam.put( "phoneOs",    phoneOs );
        sendParam.put( "custUserNo", StringUtils.defaultString((String) param.get("custUserNo")) );

        if(  selListData2.size() != 1 ) {
            sendParam.put( "retValue", ConstantDefine.SQL_ROK );
        }
        else {
            sendParam.put( "payState", StringUtils.defaultString((String) selListData2.get(0).get("payState")) );
            String edDtm = StringUtils.defaultString((String) selListData2.get(0).get("servEdDtm"));
            String dateStr = edDtm.substring(0, 4) + "년" + edDtm.substring(4, 6) + "월" + edDtm.substring(6, 8) + "일";
            int billStat = Integer.parseInt(StringUtils.defaultString((String) selListData2.get(0).get("billState")) );
            if( billStat == 0) {
                // 사용 기간 Over 체크
                String eDateSplit = StringUtils.defaultString( (String) selListData2.get(0).get("servEdDtm") ).substring(0, 8);
                int endDate = Integer.parseInt( eDateSplit );
                int localDate = Integer.parseInt( DateLib.getLocalDate() );
                if(localDate > endDate) {
                    logger.debug("학번[{}] 서비스 기간 만료 - 종료일[{}], 현재일[{}]", StringUtils.defaultString((String) sendParam.get("custUserNo")), endDate, localDate);
                    sendParam.put( "svcEdDate", dateStr );
                    sendParam.put( "retValue", CommonConstantDefine.USER_PROID_OVER );
                }
                else {
                    if( StringUtils.defaultString((String)sendParam.get("payState")).equals("N") ) {
                        logger.debug("[{}] 결재 사용자", userId);
                        sendParam.put( "retValue", CommonConstantDefine.USER_PAY );
                    }
                    else {
                        logger.debug("[{}] 서비스 유효기간 1달 남은 사용자 결제 가능", userId);
                        sendParam.put( "svcEdDate", dateStr );
                        sendParam.put( "retValue", CommonConstantDefine.USER_PROID_NOT );
                    }

                }
            }
            else if( billStat != 0 ) {
                logger.debug("[{}] 미결재 사용자", userId);
                sendParam.put( "retValue", ConstantDefine.SQL_ROK );
            }
        }

        logger.debug("sendParam : [{}]", sendParam);
        model.addAttribute("rstParam", sendParam);
        return "json";
    }

    @RequestMapping(value= {"userStatChkFree"})
    public String userStatChkFree(@RequestParam Map<String, Object> param, Model model) throws ParseException {
        String resultStr = "";
        Map<String, Object> sendParam = new HashMap<String, Object>();

        logger.debug("userStatChk.view param [{}]", param);

        Date curtDate = new Date();
        List<Map<String, Object>> selListUserNo = mobileAuthDao.selDataList( "selUserNoCheck", param );
        if( selListUserNo.size() != 1 ) {
            logger.debug("CustUserNo Search Fail Select Count [{}]", selListUserNo.size());
            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
            model.addAttribute("rstParam", sendParam);
            return "json";
        }
        String telNo = StringUtils.defaultString( (String) selListUserNo.get(0).get("mpNo") );
        String userId = StringUtils.defaultString( (String) selListUserNo.get(0).get("userId") );
        String phoneOs = StringUtils.defaultString( (String) selListUserNo.get(0).get("mpOsTp") );
        param.put( "mpNo", telNo );
        param.put( "userId", userId );
        String spNo    = telNo.substring(0, 3);
        String kookBun = telNo.substring(3, 7);
        String junBun  = telNo.substring(7, 11);
        sendParam.put( "spNo",       spNo );
        sendParam.put( "kookBun",    kookBun );
        sendParam.put( "junBun",     junBun );
        sendParam.put( "phoneOs",    phoneOs );
        sendParam.put( "custUserNo", StringUtils.defaultString((String) param.get("custUserNo")) );

        logger.debug("sendParam : [{}]", sendParam);
        model.addAttribute("rstParam", sendParam);
        return "json";
    }


    @RequestMapping(value= {"userStatChkMB"})
    public String userStatChkMB(@RequestParam Map<String, Object> param, Model model) throws ParseException {
        String resultStr = "";
        Map<String, Object> sendParam = new HashMap<String, Object>();
        Map<String, Object> insParam = new HashMap<String, Object>();

        logger.debug("userStatChk.view param [{}]", param);

        Date curtDate = new Date();
        List<Map<String, Object>> selListUserNo = mobileAuthDao.selDataList( "selUserNoCheck", param );
        if( selListUserNo.size() != 1 ) {
            logger.debug("CustUserNo Search Fail Select Count [{}]", selListUserNo.size());
            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
            model.addAttribute("rstParam", sendParam);
            return "json";
        }
        String telNo = StringUtils.defaultString( (String) selListUserNo.get(0).get("mpNo") );
        String userId = StringUtils.defaultString( (String) selListUserNo.get(0).get("userId") );
        String phoneOs = StringUtils.defaultString( (String) selListUserNo.get(0).get("mpOsTp") );
        param.put( "mpNo", telNo );
        param.put( "userId", userId );

        List<Map<String, Object>> selListData2 = mobileAuthDao.selDataList( "selTslCustProdUserBill", param );
        String spNo    = telNo.substring(0, 3);
        String kookBun = telNo.substring(3, 7);
        String junBun  = telNo.substring(7, 11);
        sendParam.put( "spNo",       spNo );
        sendParam.put( "kookBun",    kookBun );
        sendParam.put( "junBun",     junBun );
        sendParam.put( "phoneOs",    phoneOs );
        sendParam.put( "custUserNo", StringUtils.defaultString((String) param.get("custUserNo")) );

        if(  selListData2.size() != 1 ) {
            sendParam.put( "retValue", ConstantDefine.SQL_ROK );
        }
        else {
            sendParam.put( "payState", StringUtils.defaultString((String) selListData2.get(0).get("payState")) );
            String edDtm = StringUtils.defaultString((String) selListData2.get(0).get("servEdDtm"));
            String dateStr = edDtm.substring(0, 4) + "년" + edDtm.substring(4, 6) + "월" + edDtm.substring(6, 8) + "일";
            int billStat = Integer.parseInt(StringUtils.defaultString((String) selListData2.get(0).get("billState")) );
            if( billStat == 0) {
                // 사용 기간 Over 체크
                String eDateSplit = StringUtils.defaultString( (String) selListData2.get(0).get("servEdDtm") ).substring(0, 8);
                int endDate = Integer.parseInt( eDateSplit );
                int localDate = Integer.parseInt( DateLib.getLocalDate() );
                if(localDate > endDate) {
                    logger.debug("학번[{}] 서비스 기간 만료 - 종료일[{}], 현재일[{}]", StringUtils.defaultString((String) sendParam.get("custUserNo")), endDate, localDate);
                    sendParam.put( "svcEdDate", dateStr );
                    sendParam.put( "retValue", CommonConstantDefine.USER_PROID_OVER );
                }
                else {
                    if( StringUtils.defaultString((String)sendParam.get("payState")).equals("N") ) {
                        logger.debug("[{}] 결재 사용자", userId);
                        sendParam.put( "retValue", CommonConstantDefine.USER_PAY );
                        insParam.put( "svcType",    "FIDOMBAUTH" );
                        insParam.put( "spCd",       StringUtils.defaultString((String) param.get("spCd")) );
                        insParam.put( "custId",     StringUtils.defaultString((String) param.get("custId")) );
                        insParam.put( "servId",     StringUtils.defaultString((String) param.get("servId")) );
                        insParam.put( "userId",     StringUtils.defaultString((String) param.get("custUserNo")) );
                        mobileAuthService.serviceHistWrite(insParam);
                    }
                    else {
                        logger.debug("[{}] 서비스 유효기간 1달 남은 사용자 결제 가능", userId);
                        sendParam.put( "svcEdDate", dateStr );
                        sendParam.put( "retValue", CommonConstantDefine.USER_PROID_NOT );
                    }

                }
            }
            else if( billStat != 0 ) {
                logger.debug("[{}] 미결재 사용자", userId);
                sendParam.put( "retValue", ConstantDefine.SQL_ROK );
            }
        }

        logger.debug("sendParam : [{}]", sendParam);
        model.addAttribute("rstParam", sendParam);
        return "json";
    }


    @RequestMapping(value= {"mobileOsChg"})
    public String mobileOsChange(@RequestParam Map<String, Object> param, Model model) throws ParseException {
        Map<String, Object> sendParam = new HashMap<String, Object>();

        logger.debug("mobileOsChg.view param [{}]", param);

        List<Map<String, Object>> selListUserNo = mobileAuthDao.selDataList( "selUserNoCheck", param );
        if( selListUserNo.size() != 1 ) {
            logger.debug("CustUserNo Search Fail Select Count [{}]", selListUserNo.size());
            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
            model.addAttribute("rstParam", sendParam);
            return "json";
        }

        String telNo = StringUtils.defaultString( (String) selListUserNo.get(0).get("mpNo") );
        String userId = StringUtils.defaultString( (String) selListUserNo.get(0).get("userId") );
        String phoneOs = StringUtils.defaultString( (String) param.get("phoneOS") );

        param.put( "mpNo", telNo );
        param.put( "userId", userId );

        if( phoneOs.equals("ANDROID") ) {
            param.put( "mpOsTp", "A" );
        }
         else if( phoneOs.equals("iOS") ) {
             param.put( "mpOsTp", "I" );

        }

        param.put( "chgDtm", DateLib.getLocalDateTime() );

        int updCnt = this.mobileAuthDao.updData("updUserMpOs", param);
        if( updCnt == 1 ) {
            sendParam.put( "retValue", ConstantDefine.SQL_ROK );
        }
        else {
            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
        }

        logger.debug("sendParam : [{}]", sendParam);
        model.addAttribute("rstParam", sendParam);
        return "json";
    }
    @RequestMapping(value= {"mobileOsChgFree"})
    public String mobileOsChgFree(@RequestParam Map<String, Object> param, Model model) throws ParseException {
        Map<String, Object> sendParam = new HashMap<String, Object>();

        logger.debug("mobileOsChg.view param [{}]", param);

        List<Map<String, Object>> selListUserNo = mobileAuthDao.selDataList( "selUserNoCheck", param );
        if( selListUserNo.size() != 1 ) {
            logger.debug("CustUserNo Search Fail Select Count [{}]", selListUserNo.size());
            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
            model.addAttribute("rstParam", sendParam);
            return "json";
        }

        String telNo = StringUtils.defaultString( (String) selListUserNo.get(0).get("mpNo") );
        String userId = StringUtils.defaultString( (String) selListUserNo.get(0).get("userId") );
        String phoneOs = StringUtils.defaultString( (String) param.get("phoneOS") );

        param.put( "mpNo", telNo );
        param.put( "userId", userId );

        if( phoneOs.equals("ANDROID") ) {
            param.put( "mpOsTp", "A" );
        }
         else if( phoneOs.equals("iOS") ) {
             param.put( "mpOsTp", "I" );

        }

        param.put( "chgDtm", DateLib.getLocalDateTime() );

        int updCnt = this.mobileAuthDao.updData("updUserMpOs", param);
        if( updCnt == 1 ) {
            sendParam.put( "retValue", ConstantDefine.SQL_ROK );
        }
        else {
            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
        }

        logger.debug("sendParam : [{}]", sendParam);
        model.addAttribute("rstParam", sendParam);
        return "json";
    }


    @RequestMapping(value= {"authReqNumCheck"})
    public String authReqNumCheck(@RequestParam Map<String, Object> param, Model model) {
        String resultStr = "";

        logger.debug("authReqNumCheck.view param [{}]", param);

        resultStr = mobileAuthDao.mobileAuthReqNumChkJob( param );

        logger.debug("resultStr : [{}]", resultStr);
        model.addAttribute("resultCd", resultStr);
//        model.addAttribute("resultData", resultData);
        return "json";
    }

}
