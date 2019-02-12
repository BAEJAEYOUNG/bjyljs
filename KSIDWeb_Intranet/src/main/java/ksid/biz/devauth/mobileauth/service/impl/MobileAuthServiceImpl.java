package ksid.biz.devauth.mobileauth.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.devauth.mobileauth.service.MobileAuthService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;
import ksid.core.webmvc.util.ConstantDefine;
import ksid.core.webmvc.util.DateLib;

@Service("mobileAuthService")
public class MobileAuthServiceImpl extends BaseServiceImpl<Map<String, Object>> implements MobileAuthService {

    @Autowired
    private MobileAuthDao mobileAuthDao;

    public Map<String, Object> serviceHistWrite(Map<String, Object> param) {

        Map<String, Object> insParam = new HashMap<String, Object>();
        Map<String, Object> sendParam = new HashMap<String, Object>();
        logger.debug("servicehist.view param [{}]", param);
        String realDate = DateLib.getLocalDateTime();

        insParam.put( "tId",        realDate );
        insParam.put( "cmd",        StringUtils.defaultString((String) param.get("svcType")) );
        insParam.put( "stDtm",      realDate );
        insParam.put( "spCd",       StringUtils.defaultString((String) param.get("spCd")) );
        insParam.put( "custId",     StringUtils.defaultString((String) param.get("custId")) );
        insParam.put( "servId",     StringUtils.defaultString((String) param.get("servId")) );
        insParam.put( "userId",     StringUtils.defaultString((String) param.get("custUserNo")) );
        if(StringUtils.defaultString((String) param.get("svcType")).equals("SVCREG")) {
            insParam.put( "authMethod", "서비스가입" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("SVCINFO")) {
            insParam.put( "authMethod", "서비스조회" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("SVCDEREG")) {
            insParam.put( "authMethod", "서비스해지" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("SVCPAY")) {
            insParam.put( "authMethod", "서비스결제" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("SVCPAYCANCEL")) {
            insParam.put( "authMethod", "서비스결제취소" );
        }

        else if(StringUtils.defaultString((String) param.get("svcType")).equals("FIDOREG")) {
            insParam.put( "authMethod", "지문등록" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("FIDOAUTH")) {
            insParam.put( "authMethod", "PC지문로그인" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("FIDOMBAUTH")) {
            insParam.put( "authMethod", "모바일지문로그인" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("FIDODEREG")) {
            insParam.put( "authMethod", "지문해지" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("FIDOPCCON")) {
            insParam.put( "authMethod", "PC와연결" );
        }
        else if(StringUtils.defaultString((String) param.get("svcType")).equals("FIDOPCRECCON")) {
            insParam.put( "authMethod", "PC와재연결" );
        }

        String rstCode = StringUtils.defaultString((String) param.get("code"));
        if( rstCode.equals("200") ||  rstCode.equals("0")) {
            insParam.put( "resultCd", "SUCC" );
        }
        else {
            insParam.put( "resultCd", "FAIL" );
        }
        insParam.put( "statusCd", rstCode );

        logger.debug("insParam tid        : [{}]", insParam.get("tId"));
        logger.debug("insParam cmd        : [{}]", insParam.get("cmd"));
        logger.debug("insParam stDtm      : [{}]", insParam.get("stDtm"));
        logger.debug("insParam spCd       : [{}]", insParam.get("spCd"));
        logger.debug("insParam custId     : [{}]", insParam.get("custId"));
        logger.debug("insParam servId     : [{}]", insParam.get("servId"));
        logger.debug("insParam userId     : [{}]", insParam.get("userId"));
        logger.debug("insParam authMethod : [{}]", insParam.get("authMethod"));
        logger.debug("insParam resultCd   : [{}]", insParam.get("resultCd"));
        logger.debug("insParam statusCd   : [{}]", insParam.get("statusCd"));
        try {
            int icnt = mobileAuthDao.insData("insServHisDetail", insParam);
            if( icnt != ConstantDefine.INS_DEL_MAX_CNT ) {
                logger.debug("insTaRaw Insert[TBG_RAW_TA_DOWN_GTR_DATA] Fail");
//                return(ConstantDefine.RFAIL);
            }
        } catch(Exception e) {
            logger.debug("insTaRaw Exception 발생 - Insert[TBG_RAW_TA_DOWN_GTR_DATA] Fail");
//            return(ConstantDefine.RFAIL);
        }

//        List<Map<String, Object>> selCodeInfo = mobileAuthDao.selDataList( "selFidoCodeStr", param );
//        if( selCodeInfo.size() != 1 ) {
//            logger.debug("Fido Error Code Search Fail Select Count [{}]", selCodeInfo.size());
//            String errCode = "알수 없는 코드 : " + StringUtils.defaultString((String)selCodeInfo.get(0).get("code"));
//            sendParam.put( "codeRemark", errCode );
//            sendParam.put( "retValue", ConstantDefine.SQL_RFAIL );
//            model.addAttribute("rstParam", sendParam);
//            return "json";
//        }
//
//
//        logger.debug("sel CodeRemark : [{}]", StringUtils.defaultString((String)selCodeInfo.get(0).get("codeRemark")));
//        sendParam.put( "codeRemark", StringUtils.defaultString((String)selCodeInfo.get(0).get("codeRemark")) );
//        sendParam.put( "retValue", ConstantDefine.SQL_ROK );
        sendParam.put( "retValue", ConstantDefine.SQL_ROK );

        return sendParam;

    }

    public BaseDao<Map<String, Object>> getDao() {

        return this.mobileAuthDao;
    }

}
