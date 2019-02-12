/*
 *
 */
package ksid.biz.billing.work.pgcanceldata.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class PgCancelDataDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_PgCancelGtrData";
    }

    @Override
    protected String getMapperId() {

        return "PgCancelGtrData";
    }

}
