package ksid.biz.sp.stat.pgalldata.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.sp.stat.pgalldata.service.SvcPvdPgAllDataService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("svcPvdPgAllDataService")
public class SvcPvdPgAllDataServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SvcPvdPgAllDataService {

    @Autowired
    private SvcPvdPgAllDataDao svcPvdPgAllDataDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.svcPvdPgAllDataDao;
    }

}
