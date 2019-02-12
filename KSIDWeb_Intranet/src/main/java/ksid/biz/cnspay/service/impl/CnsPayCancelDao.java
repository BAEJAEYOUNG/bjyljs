package ksid.biz.cnspay.service.impl;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

@Repository
public class CnsPayCancelDao extends BaseDao<Map<String, Object>> {
    protected static final Logger logger = LoggerFactory.getLogger(CnsPayCancelDao.class);

    @Override
    protected String getNameSpace() {

        return "NS_CnsPayCancel";
    }

    @Override
    protected String getMapperId() {

        return "CnsPayCancel";
    }

    public String callProc( String statementId, Map<String,Object> param ) {

        param.put("retMsg", null);

        String sqlMapId = getNameSpace() + "." + statementId;

        System.out.println("sqlMapId : " + sqlMapId);

        try {

            this.getSqlSession().update(sqlMapId, param);

        } catch (Exception e) {

            throw new RuntimeException(String.format("%s 데이터 등록 오류", sqlMapId));
        }

        return (String) param.get("retMsg");

    }
}

