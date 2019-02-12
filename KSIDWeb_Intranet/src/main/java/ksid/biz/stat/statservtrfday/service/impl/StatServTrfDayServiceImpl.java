package ksid.biz.stat.statservtrfday.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.stat.statservtrfday.service.StatServTrfDayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("statServTrfDayService")
public class StatServTrfDayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements StatServTrfDayService {

    @Autowired
    private StatServTrfDayDao statServTrfDaydao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.statServTrfDaydao;
    }

}
