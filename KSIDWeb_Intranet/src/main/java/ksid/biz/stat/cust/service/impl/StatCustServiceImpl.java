package ksid.biz.stat.cust.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.stat.cust.service.StatCustService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("statCustService")
public class StatCustServiceImpl extends BaseServiceImpl<Map<String, Object>> implements StatCustService {

    @Autowired
    private StatCustDao statCustDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.statCustDao;
    }

}
