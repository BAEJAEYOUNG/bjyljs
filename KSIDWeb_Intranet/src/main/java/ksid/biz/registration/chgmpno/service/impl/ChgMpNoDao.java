/*
 *
 */
package ksid.biz.registration.chgmpno.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class ChgMpNoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_ChgMpNo";
    }

    @Override
    protected String getMapperId() {

        return "ChgMpNo";
    }

    public String callProc( String statementId, Map<String,Object> param ) {

        param.put("retMsg", null);

        String sqlMapId = getNameSpace() + "." + statementId;

        //System.out.println("sqlMapId : " + sqlMapId);

        try {

            this.getSqlSession().update(sqlMapId, param);

        } catch (Exception e) {

            throw new RuntimeException(String.format("%s 데이터 등록 오류", sqlMapId));
        }

        return (String) param.get("retMsg");

    }

}
