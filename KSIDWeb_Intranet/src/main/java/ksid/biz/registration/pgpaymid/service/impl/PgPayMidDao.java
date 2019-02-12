/*
 *
 */
package ksid.biz.registration.pgpaymid.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class PgPayMidDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_PgPayMid";
    }

    @Override
    protected String getMapperId() {

        return "PgPayMid";
    }

}
