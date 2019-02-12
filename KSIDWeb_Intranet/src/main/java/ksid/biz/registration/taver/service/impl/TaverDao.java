/*
 *
 */
package ksid.biz.registration.taver.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class TaverDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Taver";
    }

    @Override
    protected String getMapperId() {

        return "Taver";
    }

}
