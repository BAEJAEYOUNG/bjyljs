/*
 *
 */
package ksid.biz.billing.settle.setpgtrade.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SetPgTradeDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SetPgTrade";
    }

    @Override
    protected String getMapperId() {

        return "SetPgTrade";
    }

}
