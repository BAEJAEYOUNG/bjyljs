package ksid.biz.sp.stat.custuser.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.sp.stat.custuser.service.SvcPvdStatCustUserService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("svcPvdStatCustUserService")
public class SvcPvdStatCustUserServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SvcPvdStatCustUserService {

    @Autowired
    private SvcPvdStatCustUserDao svcPvdStatCustUserDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.svcPvdStatCustUserDao;
    }

}
