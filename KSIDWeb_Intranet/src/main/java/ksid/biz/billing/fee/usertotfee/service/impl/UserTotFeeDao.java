/*
 *
 */
package ksid.biz.billing.fee.usertotfee.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class UserTotFeeDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_UserTotFee";
    }

    @Override
    protected String getMapperId() {

        return "UserTotFee";
    }

}