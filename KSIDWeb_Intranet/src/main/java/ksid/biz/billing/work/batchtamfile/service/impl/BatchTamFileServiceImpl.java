package ksid.biz.billing.work.batchtamfile.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.batchtamfile.service.BatchTamFileService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("batchTamFile")
public class BatchTamFileServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BatchTamFileService {

    @Autowired
    private BatchTamFileDao batchTamFileDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.batchTamFileDao;
    }

    @Override
    public Map<String, Object> getTamFileHis(Map<String, Object> param) {

        return batchTamFileDao.getTamFileHis(param);
    }

}
