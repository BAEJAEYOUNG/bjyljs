/*
 *
 */
package ksid.biz.admin.system.auth.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class AuthDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Auth";
    }

    @Override
    protected String getMapperId() {

        return "Auth";
    }

}
