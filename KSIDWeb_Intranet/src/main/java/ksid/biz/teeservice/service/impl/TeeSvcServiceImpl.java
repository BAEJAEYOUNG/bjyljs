package ksid.biz.teeservice.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.teeservice.service.TeeSvcService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("teeSvcService")
public class TeeSvcServiceImpl extends BaseServiceImpl<Map<String, Object>> implements TeeSvcService {
    @Autowired
    private TeeSvcDao teeSvcDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.teeSvcDao;
    }
}
