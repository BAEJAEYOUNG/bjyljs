package ksid.biz.billing.settle.setpgsettlehis.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.settle.setpgsettlehis.service.SetPgSettleHisService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("setPgSettleServiceHis")
public class SetPgSettleHisServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SetPgSettleHisService {

    @Autowired
    private SetPgSettleHisDao setPgSettleHisDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.setPgSettleHisDao;
    }

}
