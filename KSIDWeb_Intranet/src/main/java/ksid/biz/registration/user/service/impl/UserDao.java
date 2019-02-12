/*
 *
 */
package ksid.biz.registration.user.service.impl;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class UserDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_User";
    }

    @Override
    protected String getMapperId() {

        return "User";
    }

    public String callProc( String statementId, Map<String,Object> param ) {

        param.put("retMsg", null);

        String sqlMapId = getNameSpace() + "." + statementId;

        //System.out.println("sqlMapId : " + sqlMapId);

        try {

            this.getSqlSession().update(sqlMapId, param);

        } catch (Exception e) {

            throw new RuntimeException(String.format("%s 데이터 등록 오류 - " + e.getMessage(), sqlMapId));
        }

        return (String) param.get("retMsg");

    }

    public Map<String, Object> selectCustFixBill(Map<String, Object> param) {

        return this.selData("selCustFixBill", param);

    }

}
