package ksid.biz.billing.req.billusermo.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.req.billusermo.service.BillUserMoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("billUserMoService")
public class BillUserMoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BillUserMoService {

    @Autowired
    private BillUserMoDao billUserMoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.billUserMoDao;
    }

}
