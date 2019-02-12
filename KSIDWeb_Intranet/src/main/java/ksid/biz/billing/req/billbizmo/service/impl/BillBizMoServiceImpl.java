package ksid.biz.billing.req.billbizmo.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.req.billbizmo.service.BillBizMoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("billBizMoService")
public class BillBizMoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BillBizMoService {

    @Autowired
    private BillBizMoDao billBizMoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.billBizMoDao;
    }

}
