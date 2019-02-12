package ksid.biz.billing.settle.setpgtrade.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.settle.setpgtrade.service.SetPgTradeService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("setPgTradeService")
public class SetPgTradeServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SetPgTradeService {

    @Autowired
    private SetPgTradeDao setPgTradeDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.setPgTradeDao;
    }

}
