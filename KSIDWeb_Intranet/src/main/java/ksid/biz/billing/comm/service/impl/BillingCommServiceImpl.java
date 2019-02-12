package ksid.biz.billing.comm.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.comm.service.BillingCommService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("billingCommService")
public class BillingCommServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BillingCommService {

    @Autowired
    private BillingCommDao billingCommDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.billingCommDao;
    }

}
