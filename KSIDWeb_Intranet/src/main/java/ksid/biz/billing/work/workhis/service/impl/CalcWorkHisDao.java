/*
 *
 */
package ksid.biz.billing.work.workhis.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class CalcWorkHisDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_CalcWorkHis";
    }

    @Override
    protected String getMapperId() {

        return "CalcWorkHis";
    }

}
