package ksid.biz.stat.statservregday.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.stat.statservregday.service.StatServRegDayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("statServRegDayService")
public class StatServRegDayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements StatServRegDayService {

    @Autowired
    private StatServRegDayDao statServRegDaydao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.statServRegDaydao;
    }

}
