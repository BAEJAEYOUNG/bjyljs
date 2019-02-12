/*
 *
 */
package ksid.biz.product.eventpromo.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class EventPromoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_EventPromo";
    }

    @Override
    protected String getMapperId() {

        return "EventPromo";
    }

}
