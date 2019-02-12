package ksid.biz.cnspay.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import ksid.biz.devauth.mobileauth.service.impl.MobileAuthDao;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.util.ConstantDefine;
import ksid.core.webmvc.util.DateLib;
import ksid.core.webmvc.util.StringLib;

@Repository
public class CnsPayDao extends BaseDao<Map<String, Object>> {
    protected static final Logger logger = LoggerFactory.getLogger(CnsPayDao.class);

    @Override
    protected String getNameSpace() {
        return "NS_CnsPay";
    }

    @Override
    protected String getMapperId() {
        return "CnsPay";
    }

    public String insertTbgRawPgApprGtrDataJob(Map<String, Object> param) {

        Map<String, Object> insParam = new HashMap<String, Object>();

        insParam.put( "spCd",           param.get("spCd") );
        insParam.put( "custId",         param.get("custId") );
        insParam.put( "servId",         param.get("servId") );
        insParam.put( "telNo",          param.get("telNo") );
        insParam.put( "userId",         param.get("userId") );
        insParam.put( "userNm",         param.get("userNm") );
        insParam.put( "custUserNo",     param.get("custUserNo") );
        insParam.put( "rstResultCd",    param.get("resultCode") );
        insParam.put( "rstResultMsg",   param.get("resultMsg") );
        insParam.put( "rstPayTid",      param.get("tid") );
        insParam.put( "rstPayOid",      param.get("moid") );
        insParam.put( "rstPayMid",      param.get("mid") );
        insParam.put( "rstPayMethod",   param.get("payMethod") );
        insParam.put( "rstPayAmt",      param.get("amt") );
        insParam.put( "rstAuthDtm",     param.get("authDate") );
        insParam.put( "rstAuthCd",      param.get("authCode") );
        insParam.put( "rstCardCd",      param.get("cardCode") );
        insParam.put( "rstCardNm",      param.get("cardName") );
        insParam.put( "rstCardQuota",   param.get("cardQuota") );
        insParam.put( "rstCardBin",     param.get("cardBin") );
        insParam.put( "rstVanCd",       param.get("vanCode") );
        insParam.put( "rstCardPt",      param.get("cardPoint") );
        insParam.put( "rstBankCd",      param.get("bankCode") );
        insParam.put( "rstBankNm",      param.get("bankName") );
        insParam.put( "rstRcptTp",      param.get("rcptType") );
        insParam.put( "rstRcptAuthCd",  param.get("rcptAuthCode") );
        insParam.put( "rstRcptTid",     param.get("rcptTID") );
        insParam.put( "rstVbankCd",     param.get("vbankBankCode") );
        insParam.put( "rstVbankNm",     param.get("vbankBankName") );
        insParam.put( "rstVbankNo",     param.get("vbankNum") );
        insParam.put( "rstVbankExpDtm", param.get("vbankExpDate") );
        insParam.put( "rstCarrier",     param.get("carrier") );
        insParam.put( "rstDstAddr",     param.get("dstAddr") );

        logger.debug(" spCd          : [{}]", insParam.get( "spCd" ));
        logger.debug(" custId        : [{}]", insParam.get( "custId" ));
        logger.debug(" servId        : [{}]", insParam.get( "servId" ));
        logger.debug(" telNo         : [{}]", insParam.get( "telNo" ));
        logger.debug(" userId        : [{}]", insParam.get( "userId" ));
        logger.debug(" userNm        : [{}]", insParam.get( "userNm" ));
        logger.debug(" custUserNo    : [{}]", insParam.get( "custUserNo" ));
        logger.debug(" rstResultCd   : [{}]", insParam.get( "rstResultCd" ));
        logger.debug(" rstResultMsg  : [{}]", insParam.get( "rstResultMsg" ));
        logger.debug(" rstPayTid     : [{}]", insParam.get( "rstPayTid" ));
        logger.debug(" rstPayOid     : [{}]", insParam.get( "rstPayOid" ));
        logger.debug(" rstPayMid     : [{}]", insParam.get( "rstPayMid" ));
        logger.debug(" rstPayMethod  : [{}]", insParam.get( "rstPayMethod" ));
        logger.debug(" rstPayAmt     : [{}]", insParam.get( "rstPayAmt" ));
        logger.debug(" rstAuthDtm    : [{}]", insParam.get( "rstAuthDtm" ));
        logger.debug(" rstAuthCd     : [{}]", insParam.get( "rstAuthCd" ));
        logger.debug(" rstCardCd     : [{}]", insParam.get( "rstCardCd" ));
        logger.debug(" rstCardNm     : [{}]", insParam.get( "rstCardNm" ));
        logger.debug(" rstCardQuota  : [{}]", insParam.get( "rstCardQuota" ));
        logger.debug(" rstCardBin    : [{}]", insParam.get( "rstCardBin" ));
        logger.debug(" rstVanCd      : [{}]", insParam.get( "rstVanCd" ));
        logger.debug(" rstCardPt     : [{}]", insParam.get( "rstCardPt" ));
        logger.debug(" rstBankCd     : [{}]", insParam.get( "rstBankCd" ));
        logger.debug(" rstBankNm     : [{}]", insParam.get( "rstBankNm" ));
        logger.debug(" rstRcptTp     : [{}]", insParam.get( "rstRcptTp" ));
        logger.debug(" rstRcptAuthCd : [{}]", insParam.get( "rstRcptAuthCd" ));
        logger.debug(" rstRcptTid    : [{}]", insParam.get( "rstRcptTid" ));
        logger.debug(" rstVbankCd    : [{}]", insParam.get( "rstVbankCd" ));
        logger.debug(" rstVbankNm    : [{}]", insParam.get( "rstVbankNm" ));
        logger.debug(" rstVbankNo    : [{}]", insParam.get( "rstVbankNo" ));
        logger.debug(" rstVbankExpD  : [{}]", insParam.get( "rstVbankExpDtm" ));
        logger.debug(" rstCarrier    : [{}]", insParam.get( "rstCarrier" ));
        logger.debug(" rstDstAddr    : [{}]", insParam.get( "rstDstAddr" ));

        try {
            int insCnt = insData( "insTbgRawPgApprGtrData", insParam );
            if( insCnt != ConstantDefine.INS_DEL_MAX_CNT ) {
                logger.debug("insertTbgRawPgApprGtrDataJob Insert[TBG_RAW_PG_APPR_GTR_DATA] Fail");
                return( ConstantDefine.SQL_RFAIL );
            }
        } catch( Exception e ) {
            logger.debug("insertTbgRawPgApprGtrDataJob Exception 발생 - Insert[TBG_RAW_PG_APPR_GTR_DATA] Fail");
            return( ConstantDefine.SQL_RFAIL );
        }


        return( ConstantDefine.SQL_ROK );
    }


    public Map<String, Object> selectPgUserIdGetJob(Map<String, Object> param) {

        Map<String, Object> selParam = new HashMap<String, Object>();

//        selParam.put( "mpNo", param.get("telNo") );

        List<Map<String, Object>> selList = selDataList( "selPgReqUserIdGet", param );
        if( selList.size() != 1 ) {
            logger.debug("selectPgUserIdGetJob [{}] 고객에 대한 USER ID 가 미존재 합니다.", param.get("telNo"));
            selParam.put( "retValue", ConstantDefine.SQL_RFAIL );
            return( selParam );
        }

        selParam.put( "userId",     selList.get(0).get("userId") );
        selParam.put( "userNm",     selList.get(0).get("userNm") );
        selParam.put( "custUserNo", selList.get(0).get("custUserNo") );
        selParam.put( "mpOsTp",     selList.get(0).get("mpOsTp") );
        selParam.put( "retValue",   ConstantDefine.SQL_ROK );

        return( selParam );
    }


    public Map<String, Object> selectPgCustUserNo(Map<String, Object> param) {

        Map<String, Object> selParam = new HashMap<String, Object>();

//        selParam.put( "mpNo", param.get("telNo") );

        List<Map<String, Object>> selList = selDataList( "selPgCustUserNo", param );
        if( selList.size() != 1 ) {
            logger.debug("selectPgCustUserNo [{}] 고객에 대한 USER ID 가 미존재 합니다.", param.get("telNo"));
            selParam.put( "retValue", ConstantDefine.SQL_RFAIL );
            return( selParam );
        }

        selParam.put( "userId",     selList.get(0).get("userId") );
        selParam.put( "userNm",     selList.get(0).get("userNm") );
        selParam.put( "custUserNo", selList.get(0).get("custUserNo") );
        selParam.put( "mpOsTp",     selList.get(0).get("mpOsTp") );
        selParam.put( "retValue",   ConstantDefine.SQL_ROK );

        return( selParam );
    }


    public String selectPgOrderIdGetJob() {
//        Map<String, Object> selParam = new HashMap<String, Object>();

        List<Map<String, Object>> selList = selDataList( "selPgOrderIdGet", null );

        if( selList.size() < 1) {
            logger.debug("selectPgOrderIdGetJob 주문번호 추출 실패");
            return( ConstantDefine.SQL_RFAIL );
        }

        String resultStr = (String) selList.get(0).get("orderId");

        return( resultStr );
    }


    public Map<String, Object> getCnspayDir(Map<String, Object> param)
    {
        return selData("getCnspayDir", param);
    }

}

