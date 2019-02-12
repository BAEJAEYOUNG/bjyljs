/*
 *
 */
package ksid.biz.billing.work.pgsettledata.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class PgSettleDataDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_PgSettleGtrData";
    }

    @Override
    protected String getMapperId() {

        return "PgSettleGtrData";
    }

}
