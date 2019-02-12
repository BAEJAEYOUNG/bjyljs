package ksid.biz.billing.req.billcustmo.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.req.billcustmo.service.BillCustMoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;
@Service("billCustMoService")
public class BillCustMoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BillCustMoService {

    @Autowired
    private BillCustMoDao billCustMoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.billCustMoDao;
    }

}
