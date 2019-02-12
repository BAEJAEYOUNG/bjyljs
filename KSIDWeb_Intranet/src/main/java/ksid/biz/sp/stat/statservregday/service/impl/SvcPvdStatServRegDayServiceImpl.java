package ksid.biz.sp.stat.statservregday.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.sp.stat.statservregday.service.SvcPvdStatServRegDayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("svcPvdStatServRegDayService")
public class SvcPvdStatServRegDayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SvcPvdStatServRegDayService {

    @Autowired
    private SvcPvdStatServRegDayDao svcPvdStatServRegDayDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.svcPvdStatServRegDayDao;
    }

}
