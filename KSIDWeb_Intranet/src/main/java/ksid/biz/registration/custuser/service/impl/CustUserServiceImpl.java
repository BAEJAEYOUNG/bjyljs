package ksid.biz.registration.custuser.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.custuser.service.CustUserService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("custUserService")
public class CustUserServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CustUserService{

    @Autowired
    private CustUserDao custUserDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.custUserDao;
    }

}
