/*
 *
 */
package ksid.biz.stat.statservtrfday.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class StatServTrfDayDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_StatServTrfDay";
    }

    @Override
    protected String getMapperId() {

        return "StatServTrfDay";
    }

}
