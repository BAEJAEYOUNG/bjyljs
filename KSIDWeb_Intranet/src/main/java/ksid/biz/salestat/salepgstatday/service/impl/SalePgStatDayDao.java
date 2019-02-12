/*
 *
 */
package ksid.biz.salestat.salepgstatday.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SalePgStatDayDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SalePgStatDay";
    }

    @Override
    protected String getMapperId() {

        return "SalePgStatDay";
    }

}
