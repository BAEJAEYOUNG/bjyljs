package ksid.biz.product.eventpromo.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.product.eventpromo.service.EventPromoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("eventPromoService")
public class EventPromoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements EventPromoService {

    @Autowired
    private EventPromoDao eventPromoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.eventPromoDao;
    }

}
