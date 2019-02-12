package ksid.biz.registration.user.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.sp.service.SpService;
import ksid.biz.registration.user.service.UserService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("userService")
public class UserServiceImpl extends BaseServiceImpl<Map<String, Object>> implements UserService {

    @Autowired
    private UserDao userDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.userDao;
    }

    @Override
    public String callProc(String statementId, Map<String, Object> param) {

        return this.userDao.callProc( statementId, param );

    }

    @Override
    public Map<String, Object> selectCustFixBill(Map<String, Object> param) {

        return this.userDao.selectCustFixBill( param );
    }

}
