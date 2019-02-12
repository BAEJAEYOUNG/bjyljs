package ksid.biz.registration.userservicecancel.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.userservicecancel.service.UserServiceCancelService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("userServiceCancelService")
public class UserServiceCancelServiceImpl extends BaseServiceImpl<Map<String, Object>> implements UserServiceCancelService {

    @Autowired
    private UserServiceCancelDao userServiceCancelDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.userServiceCancelDao;
    }

}
