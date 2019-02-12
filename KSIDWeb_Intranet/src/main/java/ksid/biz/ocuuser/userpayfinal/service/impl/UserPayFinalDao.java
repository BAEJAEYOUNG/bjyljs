package ksid.biz.ocuuser.userpayfinal.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.util.ConstantDefine;
import ksid.core.webmvc.util.DateLib;
import ksid.core.webmvc.util.StringLib;

@Repository
public class UserPayFinalDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_UserInfo";
    }

    @Override
    protected String getMapperId() {

        return "UserInfo";
    }

    public Map<String, Object> selectCustUserNoAndUserId(Map<String, Object> param) {
        Map<String, Object> selParam = new HashMap<String, Object>();

        logger.debug("param spCd       : [{}]", param.get("spCd"));
        logger.debug("param custId     : [{}]", param.get("custId"));
        logger.debug("param servId     : [{}]", param.get("servId"));
        logger.debug("param custUserNo : [{}]", param.get("custUserNo"));
        logger.debug("param telNo      : [{}]", param.get("telNo"));
        logger.debug("param amt        : [{}]", param.get("amt"));

        List<Map<String, Object>> selListdata1 = selDataList( "selCustUserNo", param );
        if( selListdata1.size() != 1  ) {
            logger.debug("selCustUserNo Fail Select Count [{}]", selListdata1.size());
            selParam.put( "retValue", "ConstantDefine.SQL_RFAIL" );
            return( selParam );
        }

        param.put( "userId", StringUtils.defaultString((String) selListdata1.get(0).get("userId")) );

        List<Map<String, Object>> selListdata2 = selDataList( "selUserInfoList", param );
        if( selListdata2.size() != 1  ) {
            logger.debug("selUserInfoList Fail Select Count [{}]", selListdata2.size());
            selParam.put( "retValue", "ConstantDefine.SQL_RFAIL" );
            return( selParam );
        }

        String payMthod = (String) param.get("payMethod");

        if( payMthod.equals("CARD") ) {
            selParam.put( "payMthod",  "신용카드" );
        }
        else if( payMthod.equals("BANK") ) {
            selParam.put( "payMthod",  "계좌이체" );
        }

        String telNo = StringUtils.defaultString((String) param.get("telNo"));

        String spNo    = telNo.substring(0, 3);
        String kookBun = telNo.substring(3, 7);
        String junBun  = telNo.substring(7, 11);
        String cnvTelNo = spNo + "-" + kookBun + "-" + junBun;

        selParam.put( "userId",     StringUtils.defaultString((String) param.get("userId")) );
        selParam.put( "payAmt",     StringLib.commaWon(String.valueOf(param.get("amt"))) );
        selParam.put( "telNo",      cnvTelNo );
        selParam.put( "custUserNo", StringUtils.defaultString((String)selListdata1.get(0).get("custUserNo")) );
        selParam.put( "payRstDtm",  DateLib.getDateTimeText(StringUtils.defaultString((String) param.get("payRstDtm"))) );
        selParam.put( "servStDtm",  DateLib.getDateYYYYMMDDText(StringUtils.defaultString((String) selListdata2.get(0).get("servStDtm"))) );
        selParam.put( "servEdDtm",  DateLib.getDateYYYYMMDDText(StringUtils.defaultString((String) selListdata2.get(0).get("servEdDtm"))) );
        selParam.put( "servNm",     selListdata2.get(0).get("servNm") );
        selParam.put( "retValue",   "ConstantDefine.SQL_OK" );

        logger.debug("selParam userId     : [{}]", selParam.get("userId"));
        logger.debug("selParam payMthod   : [{}]", selParam.get("payMthod"));
        logger.debug("selParam payAmt     : [{}]", selParam.get("payAmt"));
        logger.debug("selParam telNo      : [{}]", selParam.get("telNo"));
        logger.debug("selParam custUserNo : [{}]", selParam.get("custUserNo"));
        logger.debug("selParam servStDtm  : [{}]", selParam.get("servStDtm"));
        logger.debug("selParam servEdDtm  : [{}]", selParam.get("servEdDtm"));
        logger.debug("selParam servNm     : [{}]", selParam.get("servNm"));

        return(selParam);
    }

}
