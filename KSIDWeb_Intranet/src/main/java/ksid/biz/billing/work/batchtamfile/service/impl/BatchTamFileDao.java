/*
 *
 */
package ksid.biz.billing.work.batchtamfile.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BatchTamFileDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BatchTamFile";
    }

    @Override
    protected String getMapperId() {

        return "BatchTamFile";
    }


    public Map<String, Object> getTamFileHis(Map<String, Object> param) {

        return this.selData("getTamFileHis", param);
    }


}
