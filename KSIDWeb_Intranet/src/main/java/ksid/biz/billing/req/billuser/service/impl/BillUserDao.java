/*
 *
 */
package ksid.biz.billing.req.billuser.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BillUserDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BillUser";
    }

    @Override
    protected String getMapperId() {

        return "BillUser";
    }

}
