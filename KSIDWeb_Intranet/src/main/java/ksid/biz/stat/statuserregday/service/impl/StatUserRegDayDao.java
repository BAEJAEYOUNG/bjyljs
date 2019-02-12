/*
 *
 */
package ksid.biz.stat.statuserregday.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class StatUserRegDayDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_StatUserRegDay";
    }

    @Override
    protected String getMapperId() {

        return "StatUserRegDay";
    }

}
