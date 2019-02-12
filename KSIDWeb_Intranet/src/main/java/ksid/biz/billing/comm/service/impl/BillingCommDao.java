/*
 *
 */
package ksid.biz.billing.comm.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BillingCommDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BillingComm";
    }

    @Override
    protected String getMapperId() {

        return "BillingComm";
    }

}
