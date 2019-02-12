package ksid.biz.ocuuser.userinfo.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.ocuuser.userinfo.service.UserInfoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("userInfoService")
public class UserInfoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements UserInfoService {

    @Autowired
    private UserInfoDao userInfoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.userInfoDao;
    }

}
