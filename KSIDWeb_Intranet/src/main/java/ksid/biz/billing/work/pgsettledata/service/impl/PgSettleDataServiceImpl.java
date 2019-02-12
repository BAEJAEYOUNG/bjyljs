package ksid.biz.billing.work.pgsettledata.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.pgsettledata.service.PgSettleDataService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("pgSettleDataService")
public class PgSettleDataServiceImpl extends BaseServiceImpl<Map<String, Object>> implements PgSettleDataService {

    @Autowired
    private PgSettleDataDao pgSettleDataDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.pgSettleDataDao;
    }

}
