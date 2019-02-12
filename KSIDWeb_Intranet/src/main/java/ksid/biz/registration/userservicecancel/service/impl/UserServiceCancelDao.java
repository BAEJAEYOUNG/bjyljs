/*
 *
 */
package ksid.biz.registration.userservicecancel.service.impl;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class UserServiceCancelDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_UserServiceCancel";
    }

    @Override
    protected String getMapperId() {

        return "UserServiceCancel";
    }

}
