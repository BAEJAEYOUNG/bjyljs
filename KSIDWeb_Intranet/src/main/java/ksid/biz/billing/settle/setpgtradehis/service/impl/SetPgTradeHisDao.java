/*
 *
 */
package ksid.biz.billing.settle.setpgtradehis.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SetPgTradeHisDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SetPgTradeHis";
    }

    @Override
    protected String getMapperId() {

        return "SetPgTradeHis";
    }

}
