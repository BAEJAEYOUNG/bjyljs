/*
 *
 */
package ksid.biz.admin.system.code.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class CodeDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Code";
    }

    @Override
    protected String getMapperId() {

        return "Code";
    }

}
