/*
 *
 */
package ksid.biz.product.cls.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class ClsDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Lcls";
    }

    @Override
    protected String getMapperId() {

        return "Lcls";
    }

}
