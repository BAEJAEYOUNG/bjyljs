package ksid.biz.billing.settle.settadownhis.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.settle.settadownhis.service.SetTaDownHisService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("setTaDownServiceHis")
public class SetTaDownHisServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SetTaDownHisService {

    @Autowired
    private SetTaDownHisDao setTaDownHisDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.setTaDownHisDao;
    }

}
