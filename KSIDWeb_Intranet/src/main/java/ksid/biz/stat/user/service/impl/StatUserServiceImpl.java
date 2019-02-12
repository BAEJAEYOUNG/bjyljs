package ksid.biz.stat.user.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.stat.user.service.StatUserService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("statUserService")
public class StatUserServiceImpl extends BaseServiceImpl<Map<String, Object>> implements StatUserService {

    @Autowired
    private StatUserDao statUserdao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.statUserdao;
    }

}
