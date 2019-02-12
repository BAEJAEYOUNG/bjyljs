package ksid.biz.sp.stat.salestatmonth.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.sp.stat.salestatmonth.service.SvcPvdSaleStatMonthService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("svcPvdSaleStatMonthService")
public class SvcPvdSaleStatMonthServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SvcPvdSaleStatMonthService {

    @Autowired
    private SvcPvdSaleStatMonthDao svcPvdSaleStatMonthdao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.svcPvdSaleStatMonthdao;
    }

}
