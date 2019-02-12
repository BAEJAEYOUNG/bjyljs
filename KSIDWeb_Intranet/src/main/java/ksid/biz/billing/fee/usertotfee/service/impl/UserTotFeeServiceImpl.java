package ksid.biz.billing.fee.usertotfee.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.fee.usertotfee.service.UserTotFeeService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("userTotFeeService")
public class UserTotFeeServiceImpl extends BaseServiceImpl<Map<String, Object>> implements UserTotFeeService {

    @Autowired
    private UserTotFeeDao userTotFeeDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.userTotFeeDao;
    }

}
