package ksid.biz.salestat.salestatquarter.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.salestat.salestatquarter.service.SaleStatQuarterService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("saleStatQuarterService")
public class SaleStatQuarterServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SaleStatQuarterService {

    @Autowired
    private SaleStatQuarterDao saleStatQuarterdao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.saleStatQuarterdao;
    }

}
