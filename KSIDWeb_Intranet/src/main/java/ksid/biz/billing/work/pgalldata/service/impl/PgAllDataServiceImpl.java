package ksid.biz.billing.work.pgalldata.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.pgalldata.service.PgAllDataService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("pgAllDataService")
public class PgAllDataServiceImpl extends BaseServiceImpl<Map<String, Object>> implements PgAllDataService {

    @Autowired
    private PgAllDataDao pgAllDataDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.pgAllDataDao;
    }

}
