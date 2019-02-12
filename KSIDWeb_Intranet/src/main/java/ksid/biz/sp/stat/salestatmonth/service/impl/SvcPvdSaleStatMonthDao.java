/*
 *
 */
package ksid.biz.sp.stat.salestatmonth.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SvcPvdSaleStatMonthDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SvcPvdSaleStatMonth";
    }

    @Override
    protected String getMapperId() {

        return "SvcPvdSaleStatMonth";
    }

}
