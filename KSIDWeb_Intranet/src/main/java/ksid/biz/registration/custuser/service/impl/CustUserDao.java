/*
 *
 */
package ksid.biz.registration.custuser.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class CustUserDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_CustUser";
    }

    @Override
    protected String getMapperId() {

        return "CustUser";
    }

}
