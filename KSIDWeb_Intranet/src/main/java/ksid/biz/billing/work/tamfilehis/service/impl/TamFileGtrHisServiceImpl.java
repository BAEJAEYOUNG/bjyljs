package ksid.biz.billing.work.tamfilehis.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.tamfilehis.service.TamFileGtrHisService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("tamFileGtrHisService")
public class TamFileGtrHisServiceImpl extends BaseServiceImpl<Map<String, Object>> implements TamFileGtrHisService {

    @Autowired
    private TamFileGtrHisDao tamFileGtrHisDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.tamFileGtrHisDao;
    }

}
