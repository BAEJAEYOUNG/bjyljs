/*
 *
 */
package ksid.biz.sp.stat.pgalldata.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SvcPvdPgAllDataDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SvcPvdPgAllGtrData";
    }

    @Override
    protected String getMapperId() {

        return "SvcPvdPgAllGtrData";
    }

}
