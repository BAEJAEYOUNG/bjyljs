package ksid.biz.billing.work.pgtradedata.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.pgtradedata.service.PgTradeDataService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("pgTradeDataService")
public class PgTradeDataServiceImpl extends BaseServiceImpl<Map<String, Object>> implements PgTradeDataService {

    @Autowired
    private PgTradeDataDao pgTradeDataDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.pgTradeDataDao;
    }

}
