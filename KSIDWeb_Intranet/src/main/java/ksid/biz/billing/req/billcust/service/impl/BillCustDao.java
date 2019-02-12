/*
 *
 */
package ksid.biz.billing.req.billcust.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BillCustDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BillCust";
    }

    @Override
    protected String getMapperId() {

        return "BillCust";
    }

}
