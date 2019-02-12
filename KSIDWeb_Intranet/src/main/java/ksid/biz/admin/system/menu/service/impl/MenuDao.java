/*
 *
 */
package ksid.biz.admin.system.menu.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class MenuDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Menu";
    }

    @Override
    protected String getMapperId() {

        return "Menu";
    }

}
