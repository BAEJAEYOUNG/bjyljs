/*
 *
 */
package ksid.biz.billing.bill.gtrdata.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class GtrDataDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_GtrData";
    }

    @Override
    protected String getMapperId() {

        return "GtrData";
    }

}
