package ksid.biz.billing.req.billbiz.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.req.billbiz.service.BillBizService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("billBizService")
public class BillBizServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BillBizService {

    @Autowired
    private BillBizDao billBizDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.billBizDao;
    }

}
