/*
 *
 */
package ksid.biz.registration.cust.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class CustDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Cust";
    }

    @Override
    protected String getMapperId() {

        return "Cust";
    }

}
