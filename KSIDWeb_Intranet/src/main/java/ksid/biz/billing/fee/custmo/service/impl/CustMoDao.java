/*
 *
 */
package ksid.biz.billing.fee.custmo.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class CustMoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_CustMo";
    }

    @Override
    protected String getMapperId() {

        return "CustMo";
    }

}
