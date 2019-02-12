/*
 *
 */
package ksid.biz.billing.work.tamfilehis.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class TamFileGtrHisDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_TamFileGtrHis";
    }

    @Override
    protected String getMapperId() {

        return "TamFileGtrHis";
    }

}
