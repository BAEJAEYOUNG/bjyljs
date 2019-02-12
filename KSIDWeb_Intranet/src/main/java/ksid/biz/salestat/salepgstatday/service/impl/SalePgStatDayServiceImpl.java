package ksid.biz.salestat.salepgstatday.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.salestat.salepgstatday.service.SalePgStatDayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("salePgStatDayService")
public class SalePgStatDayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SalePgStatDayService {

    @Autowired
    private SalePgStatDayDao salePgStatDaydao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.salePgStatDaydao;
    }

}
