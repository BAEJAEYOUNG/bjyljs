package ksid.biz.billing.work.dltaskhis.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.dltaskhis.service.DlTaskHisService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("dlTaskHisService")
public class DlTaskHisServiceImpl extends BaseServiceImpl<Map<String, Object>> implements DlTaskHisService {

    @Autowired
    private DlTaskHisDao dlTaskHisDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.dlTaskHisDao;
    }

}
