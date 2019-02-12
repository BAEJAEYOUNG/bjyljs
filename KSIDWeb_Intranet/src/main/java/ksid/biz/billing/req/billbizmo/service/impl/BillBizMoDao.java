/*
 *
 */
package ksid.biz.billing.req.billbizmo.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BillBizMoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BillBizMo";
    }

    @Override
    protected String getMapperId() {

        return "BillBizMo";
    }

}
