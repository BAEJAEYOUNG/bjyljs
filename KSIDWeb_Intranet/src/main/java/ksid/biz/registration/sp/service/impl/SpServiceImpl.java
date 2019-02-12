package ksid.biz.registration.sp.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.sp.service.SpService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("spService")
public class SpServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SpService {

    @Autowired
    private SpDao spDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.spDao;
    }

}
