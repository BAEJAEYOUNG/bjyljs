package ksid.biz.salestat.salestatmonth.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.salestat.salestatmonth.service.SaleStatMonthService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("saleStatMonthService")
public class SaleStatMonthServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SaleStatMonthService {

    @Autowired
    private SaleStatMonthDao saleStatMonthdao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.saleStatMonthdao;
    }

}
