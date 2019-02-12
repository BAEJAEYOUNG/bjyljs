package ksid.biz.stat.custuser.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.stat.custuser.service.StatCustUserService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("statCustUserService")
public class StatCustUserServiceImpl extends BaseServiceImpl<Map<String, Object>> implements StatCustUserService {

    @Autowired
    private StatCustUserDao statCustUserDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.statCustUserDao;
    }

}
