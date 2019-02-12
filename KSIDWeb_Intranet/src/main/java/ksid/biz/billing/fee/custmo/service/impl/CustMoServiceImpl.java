package ksid.biz.billing.fee.custmo.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.fee.custmo.service.CustMoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("custMoService")
public class CustMoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CustMoService {

    @Autowired
    private CustMoDao custMoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.custMoDao;
    }

}
