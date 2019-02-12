/*
 *
 */
package ksid.biz.salestat.salestatday.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SaleStatDayDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SaleStatDay";
    }

    @Override
    protected String getMapperId() {

        return "SaleStatDay";
    }

}
