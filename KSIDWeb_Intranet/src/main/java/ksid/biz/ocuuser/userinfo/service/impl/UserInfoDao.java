/*
 *
 */
package ksid.biz.ocuuser.userinfo.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class UserInfoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_UserInfo";
    }

    @Override
    protected String getMapperId() {

        return "UserInfo";
    }

}
