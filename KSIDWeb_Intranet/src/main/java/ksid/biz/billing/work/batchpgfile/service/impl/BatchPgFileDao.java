/*
 *
 */
package ksid.biz.billing.work.batchpgfile.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class BatchPgFileDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BatchPgFile";
    }

    @Override
    protected String getMapperId() {

        return "BatchPgFile";
    }


    public Map<String, Object> getPgFileHis(Map<String, Object> param) {

        return this.selData("getPgFileHis", param);
    }


}
