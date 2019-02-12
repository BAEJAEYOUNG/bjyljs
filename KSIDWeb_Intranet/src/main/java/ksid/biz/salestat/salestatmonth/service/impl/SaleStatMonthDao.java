/*
 *
 */
package ksid.biz.salestat.salestatmonth.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SaleStatMonthDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SaleStatMonth";
    }

    @Override
    protected String getMapperId() {

        return "SaleStatMonth";
    }

}
