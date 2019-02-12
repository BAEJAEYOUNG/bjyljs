package ksid.biz.billing.req.billcust.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.req.billcust.service.BillCustService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("billCustService")
public class BillCustServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BillCustService {

    @Autowired
    private BillCustDao billCustDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.billCustDao;
    }

}
