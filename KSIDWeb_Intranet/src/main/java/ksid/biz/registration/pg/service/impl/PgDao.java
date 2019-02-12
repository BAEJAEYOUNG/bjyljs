/*
 *
 */
package ksid.biz.registration.pg.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class PgDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Pg";
    }

    @Override
    protected String getMapperId() {

        return "Pg";
    }

}
