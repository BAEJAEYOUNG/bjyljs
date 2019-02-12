/*
 *
 */
package ksid.biz.registration.sp.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SpDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Sp";
    }

    @Override
    protected String getMapperId() {

        return "Sp";
    }

}
