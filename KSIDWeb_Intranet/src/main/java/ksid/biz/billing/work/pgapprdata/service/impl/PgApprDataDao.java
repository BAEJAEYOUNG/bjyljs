/*
 *
 */
package ksid.biz.billing.work.pgapprdata.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class PgApprDataDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_PgApprGtrData";
    }

    @Override
    protected String getMapperId() {

        return "PgApprGtrData";
    }

}
