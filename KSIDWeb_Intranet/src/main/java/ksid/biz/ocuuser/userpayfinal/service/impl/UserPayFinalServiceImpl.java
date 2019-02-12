package ksid.biz.ocuuser.userpayfinal.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.ocuuser.userpayfinal.service.UserPayFinalService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("userPayFinalService")
public class UserPayFinalServiceImpl extends BaseServiceImpl<Map<String, Object>> implements UserPayFinalService{
    @Autowired
    private UserPayFinalDao userPayFinalDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.userPayFinalDao;
    }

}
