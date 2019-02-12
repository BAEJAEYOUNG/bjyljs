/*
 *
 */
package ksid.biz.billing.fee.usermo.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class UserMoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_UserMo";
    }

    @Override
    protected String getMapperId() {

        return "UserMo";
    }

}
