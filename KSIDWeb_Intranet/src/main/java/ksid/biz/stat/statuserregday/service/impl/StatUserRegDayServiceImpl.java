package ksid.biz.stat.statuserregday.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.stat.statuserregday.service.StatUserRegDayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("statUserRegDayService")
public class StatUserRegDayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements StatUserRegDayService {

    @Autowired
    private StatUserRegDayDao statUserRegDaydao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.statUserRegDaydao;
    }

}
