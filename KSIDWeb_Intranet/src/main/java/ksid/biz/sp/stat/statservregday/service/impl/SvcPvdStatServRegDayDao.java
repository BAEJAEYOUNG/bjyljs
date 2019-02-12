/*
 *
 */
package ksid.biz.sp.stat.statservregday.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SvcPvdStatServRegDayDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SvcPvdStatServRegDay";
    }

    @Override
    protected String getMapperId() {

        return "SvcPvdStatServRegDay";
    }

}
