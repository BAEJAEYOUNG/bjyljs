/*
 *
 */
package ksid.biz.sp.stat.salestatday.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SvcPvdSaleStatDayDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SvcPvdSaleStatDay";
    }

    @Override
    protected String getMapperId() {

        return "SvcPvdSaleStatDay";
    }

}
