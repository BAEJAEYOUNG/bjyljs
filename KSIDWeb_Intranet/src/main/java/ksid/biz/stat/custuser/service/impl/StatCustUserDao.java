/*
 *
 */
package ksid.biz.stat.custuser.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class StatCustUserDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_StatCustUser";
    }

    @Override
    protected String getMapperId() {

        return "StatCustUser";
    }

}
