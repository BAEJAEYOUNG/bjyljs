package ksid.biz.billing.fee.usermo.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.fee.usermo.service.UserMoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("userMoService")
public class UserMoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements UserMoService {

    @Autowired
    private UserMoDao userMoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.userMoDao;
    }

}
