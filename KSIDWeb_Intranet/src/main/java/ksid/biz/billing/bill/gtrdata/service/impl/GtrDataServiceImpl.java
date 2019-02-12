package ksid.biz.billing.bill.gtrdata.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.bill.gtrdata.service.GtrDataService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("gtrDataService")
public class GtrDataServiceImpl extends BaseServiceImpl<Map<String, Object>> implements GtrDataService {

    @Autowired
    private GtrDataDao gtrDataDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.gtrDataDao;
    }

}
