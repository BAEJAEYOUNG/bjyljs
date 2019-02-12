/*
 *
 */
package ksid.biz.stat.statservregday.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class StatServRegDayDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_StatServRegDay";
    }

    @Override
    protected String getMapperId() {

        return "StatServRegDay";
    }

}
