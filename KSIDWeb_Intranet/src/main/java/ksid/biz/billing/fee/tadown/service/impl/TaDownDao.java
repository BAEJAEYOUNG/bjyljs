/*
 *
 */
package ksid.biz.billing.fee.tadown.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class TaDownDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_TaDown";
    }

    @Override
    protected String getMapperId() {

        return "TaDown";
    }

}
