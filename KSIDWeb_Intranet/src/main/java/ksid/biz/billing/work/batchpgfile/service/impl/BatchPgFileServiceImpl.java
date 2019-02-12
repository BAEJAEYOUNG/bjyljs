package ksid.biz.billing.work.batchpgfile.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.batchpgfile.service.BatchPgFileService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("batchPgFile")
public class BatchPgFileServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BatchPgFileService {

    @Autowired
    private BatchPgFileDao batchPgFileDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.batchPgFileDao;
    }

    @Override
    public Map<String, Object> getPgFileHis(Map<String, Object> param) {

        return batchPgFileDao.getPgFileHis(param);
    }

}
