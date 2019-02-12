package ksid.biz.billing.settle.setpgtradehis.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.settle.setpgtradehis.service.SetPgTradeHisService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("setPgTradeServiceHis")
public class SetPgTradeHisServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SetPgTradeHisService {

    @Autowired
    private SetPgTradeHisDao setPgTradeHisDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.setPgTradeHisDao;
    }

}
