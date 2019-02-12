/*
 *
 */
package ksid.biz.login.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class LoginDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Login";
    }

    @Override
    protected String getMapperId() {

        return "Login";
    }

}
