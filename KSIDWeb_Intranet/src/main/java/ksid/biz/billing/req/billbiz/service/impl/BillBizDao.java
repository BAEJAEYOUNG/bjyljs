/*
 *
 */
package ksid.biz.billing.req.billbiz.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BillBizDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BillBiz";
    }

    @Override
    protected String getMapperId() {

        return "BillBiz";
    }

}
