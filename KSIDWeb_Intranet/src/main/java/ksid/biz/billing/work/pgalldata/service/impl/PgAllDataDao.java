/*
 *
 */
package ksid.biz.billing.work.pgalldata.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class PgAllDataDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_PgAllGtrData";
    }

    @Override
    protected String getMapperId() {

        return "PgAllGtrData";
    }

}
