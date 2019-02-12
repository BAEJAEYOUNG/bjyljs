/*
 *
 */
package ksid.biz.billing.settle.settadown.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SetTaDownDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SetTaDown";
    }

    @Override
    protected String getMapperId() {

        return "SetTaDown";
    }

}
