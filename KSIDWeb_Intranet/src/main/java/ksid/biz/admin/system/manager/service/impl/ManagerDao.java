/*
 *
 */
package ksid.biz.admin.system.manager.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class ManagerDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Manager";
    }

    @Override
    protected String getMapperId() {

        return "Manager";
    }

}
