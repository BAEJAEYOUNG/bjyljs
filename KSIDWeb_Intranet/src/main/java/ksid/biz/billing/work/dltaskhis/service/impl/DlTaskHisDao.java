/*
 *
 */
package ksid.biz.billing.work.dltaskhis.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class DlTaskHisDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_DlTaskHis";
    }

    @Override
    protected String getMapperId() {

        return "DlTaskHis";
    }

}
