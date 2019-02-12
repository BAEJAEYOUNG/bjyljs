package ksid.biz.salestat.settlepgstatday.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.salestat.settlepgstatday.service.SettlePgStatDayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("settlePgStatDayService")
public class SettlePgStatDayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SettlePgStatDayService {

    @Autowired
    private SettlePgStatDayDao settlePgStatDaydao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.settlePgStatDaydao;
    }

}
