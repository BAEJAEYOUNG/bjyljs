/*
 *
 */
package ksid.biz.billing.bill.tadownudr.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class TaDownUdrDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_TaDownUdr";
    }

    @Override
    protected String getMapperId() {

        return "TaDownUdr";
    }

}
