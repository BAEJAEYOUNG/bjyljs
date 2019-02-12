package ksid.biz.billing.fee.tadown.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.fee.tadown.service.TaDownService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("taDownService")
public class TaDownServiceImpl extends BaseServiceImpl<Map<String, Object>> implements TaDownService {

    @Autowired
    private TaDownDao custMoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.custMoDao;
    }

}
