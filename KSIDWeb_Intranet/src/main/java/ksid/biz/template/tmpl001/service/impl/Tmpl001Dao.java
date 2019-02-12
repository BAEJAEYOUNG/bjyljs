/*
 *
 */
package ksid.biz.template.tmpl001.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class Tmpl001Dao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Tmpl001";
    }

    @Override
    protected String getMapperId() {

        return "Tmpl001";
    }

}
