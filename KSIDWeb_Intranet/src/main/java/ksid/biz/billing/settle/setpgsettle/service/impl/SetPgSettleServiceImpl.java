package ksid.biz.billing.settle.setpgsettle.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.settle.setpgsettle.service.SetPgSettleService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("setPgSettleService")
public class SetPgSettleServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SetPgSettleService {

    @Autowired
    private SetPgSettleDao setPgSettleDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.setPgSettleDao;
    }

}
