/*
 *
 */
package ksid.biz.stat.cust.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class StatCustDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_StatCust";
    }

    @Override
    protected String getMapperId() {

        return "StatCust";
    }

}
