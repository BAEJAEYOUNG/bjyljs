package ksid.biz.teeservice.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

@Repository
public class TeeSvcDao extends BaseDao<Map<String, Object>> {
    @Override
    protected String getNameSpace() {

        return "NS_User";
    }

    @Override
    protected String getMapperId() {

        return "User";
    }
}
