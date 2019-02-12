package ksid.biz.billing.req.billuser.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.req.billuser.service.BillUserService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("billUserService")
public class BillUserServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BillUserService {

    @Autowired
    private BillUserDao billUserDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.billUserDao;
    }

}
