/*
 *
 */
package ksid.biz.billing.fee.userwt.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class UserWtDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_UserWt";
    }

    @Override
    protected String getMapperId() {

        return "UserWt";
    }

}
