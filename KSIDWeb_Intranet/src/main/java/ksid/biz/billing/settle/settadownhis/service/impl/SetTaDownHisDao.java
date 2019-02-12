/*
 *
 */
package ksid.biz.billing.settle.settadownhis.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SetTaDownHisDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SetTaDownHis";
    }

    @Override
    protected String getMapperId() {

        return "SetTaDownHis";
    }

}
