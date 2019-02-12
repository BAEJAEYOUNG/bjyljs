/*
 *
 */
package ksid.biz.billing.work.pgfilehis.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class PgFileGtrHisDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_PgFileGtrHis";
    }

    @Override
    protected String getMapperId() {

        return "PgFileGtrHis";
    }

}
