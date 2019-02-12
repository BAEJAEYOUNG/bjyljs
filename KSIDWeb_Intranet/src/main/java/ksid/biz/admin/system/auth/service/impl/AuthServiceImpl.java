package ksid.biz.admin.system.auth.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.admin.system.auth.service.AuthService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("authService")
public class AuthServiceImpl extends BaseServiceImpl<Map<String, Object>> implements AuthService {

    @Autowired
    private AuthDao authDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.authDao;
    }

}
