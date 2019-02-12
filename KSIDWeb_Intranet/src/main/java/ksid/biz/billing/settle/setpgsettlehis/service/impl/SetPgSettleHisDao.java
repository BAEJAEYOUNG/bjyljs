/*
 *
 */
package ksid.biz.billing.settle.setpgsettlehis.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SetPgSettleHisDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SetPgSettleHis";
    }

    @Override
    protected String getMapperId() {

        return "SetPgSettleHis";
    }

}
