/*
 *
 */
package ksid.biz.stat.user.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class StatUserDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_StatUser";
    }

    @Override
    protected String getMapperId() {

        return "StatUser";
    }

}
