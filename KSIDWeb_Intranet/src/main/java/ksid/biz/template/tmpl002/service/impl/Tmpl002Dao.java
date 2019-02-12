/*
 *
 */
package ksid.biz.template.tmpl002.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class Tmpl002Dao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Tmpl002";
    }

    @Override
    protected String getMapperId() {

        return "Tmpl002";
    }

}
