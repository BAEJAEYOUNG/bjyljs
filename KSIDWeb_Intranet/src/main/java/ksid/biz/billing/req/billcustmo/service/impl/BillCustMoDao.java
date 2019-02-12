/*
 *
 */
package ksid.biz.billing.req.billcustmo.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BillCustMoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BillCustMo";
    }

    @Override
    protected String getMapperId() {

        return "BillCustMo";
    }

}
