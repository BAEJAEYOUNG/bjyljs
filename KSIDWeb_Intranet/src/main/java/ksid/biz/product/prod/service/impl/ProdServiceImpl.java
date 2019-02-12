package ksid.biz.product.prod.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.product.prod.service.ProdService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("prodService")
public class ProdServiceImpl extends BaseServiceImpl<Map<String, Object>> implements ProdService {

    @Autowired
    private ProdDao prodDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.prodDao;
    }

}
