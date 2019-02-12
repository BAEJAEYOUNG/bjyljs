package ksid.biz.salestat.salestatday.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.salestat.salestatday.service.SaleStatDayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("saleStatDayService")
public class SaleStatDayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SaleStatDayService {

    @Autowired
    private SaleStatDayDao saleStatDaydao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.saleStatDaydao;
    }

}
