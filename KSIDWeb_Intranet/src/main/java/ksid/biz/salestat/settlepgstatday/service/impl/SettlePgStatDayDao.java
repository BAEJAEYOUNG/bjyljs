/*
 *
 */
package ksid.biz.salestat.settlepgstatday.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SettlePgStatDayDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SettlePgStatDay";
    }

    @Override
    protected String getMapperId() {

        return "SettlePgStatDay";
    }

}
