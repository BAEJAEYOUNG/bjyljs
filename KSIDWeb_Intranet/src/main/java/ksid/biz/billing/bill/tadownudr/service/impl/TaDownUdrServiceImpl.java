package ksid.biz.billing.bill.tadownudr.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.bill.tadownudr.service.TaDownUdrService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("taDownUdrService")
public class TaDownUdrServiceImpl extends BaseServiceImpl<Map<String, Object>> implements TaDownUdrService {

    @Autowired
    private TaDownUdrDao taDownUdrDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.taDownUdrDao;
    }

}
