/*
 *
 */
package ksid.biz.product.prod.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class ProdDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Prod";
    }

    @Override
    protected String getMapperId() {

        return "Prod";
    }

}
