/*
 *
 */
package ksid.biz.main.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class MainDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Main";
    }

    @Override
    protected String getMapperId() {

        return "Main";
    }

}
