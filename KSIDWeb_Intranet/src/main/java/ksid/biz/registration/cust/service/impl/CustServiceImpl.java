package ksid.biz.registration.cust.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.cust.service.CustService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("custService")
public class CustServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CustService {

    @Autowired
    private CustDao custDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.custDao;
    }

}
