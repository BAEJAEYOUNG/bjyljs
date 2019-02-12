package ksid.biz.product.basicpromo.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.product.basicpromo.service.BasicPromoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("basicPromoService")
public class BasicPromoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BasicPromoService {

    @Autowired
    private BasicPromoDao basicPromoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.basicPromoDao;
    }

}
