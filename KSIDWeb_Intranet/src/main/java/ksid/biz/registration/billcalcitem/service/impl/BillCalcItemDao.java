/*
 *
 */
package ksid.biz.registration.billcalcitem.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BillCalcItemDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BillCalcItem";
    }

    @Override
    protected String getMapperId() {

        return "BillCalcItem";
    }

}
