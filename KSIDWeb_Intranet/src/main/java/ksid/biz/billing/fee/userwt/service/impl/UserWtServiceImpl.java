package ksid.biz.billing.fee.userwt.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.fee.userwt.service.UserWtService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("userWtService")
public class UserWtServiceImpl extends BaseServiceImpl<Map<String, Object>> implements UserWtService {

    @Autowired
    private UserWtDao userWtDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.userWtDao;
    }

}
