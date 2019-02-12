/*
 *
 */
package ksid.biz.billing.req.billusermo.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BillUserMoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BillUserMo";
    }

    @Override
    protected String getMapperId() {

        return "BillUserMo";
    }

}
