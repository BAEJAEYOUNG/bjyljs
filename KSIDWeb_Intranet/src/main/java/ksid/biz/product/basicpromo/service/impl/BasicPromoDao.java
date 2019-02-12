/*
 *
 */
package ksid.biz.product.basicpromo.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BasicPromoDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BasicPromo";
    }

    @Override
    protected String getMapperId() {

        return "BasicPromo";
    }

}
