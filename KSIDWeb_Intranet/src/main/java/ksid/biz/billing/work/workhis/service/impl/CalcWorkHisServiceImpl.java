package ksid.biz.billing.work.workhis.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.workhis.service.CalcWorkHisService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("calcWorkHisService")
public class CalcWorkHisServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CalcWorkHisService {

    @Autowired
    private CalcWorkHisDao calcWorkHisDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.calcWorkHisDao;
    }

}
