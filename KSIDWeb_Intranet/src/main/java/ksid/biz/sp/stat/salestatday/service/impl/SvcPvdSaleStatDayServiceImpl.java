package ksid.biz.sp.stat.salestatday.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.sp.stat.salestatday.service.SvcPvdSaleStatDayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("svcPvdSaleStatDayService")
public class SvcPvdSaleStatDayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SvcPvdSaleStatDayService {

    @Autowired
    private SvcPvdSaleStatDayDao svcPvdSaleStatDaydao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.svcPvdSaleStatDaydao;
    }

}
