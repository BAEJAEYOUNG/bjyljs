package ksid.biz.billing.work.pgcanceldata.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.pgcanceldata.service.PgCancelDataService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("pgCancelDataService")
public class PgCancelDataServiceImpl extends BaseServiceImpl<Map<String, Object>> implements PgCancelDataService {

    @Autowired
    private PgCancelDataDao pgCancelDataDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.pgCancelDataDao;
    }

}
