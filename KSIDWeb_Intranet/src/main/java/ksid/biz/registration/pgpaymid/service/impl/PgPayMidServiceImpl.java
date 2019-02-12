package ksid.biz.registration.pgpaymid.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.pgpaymid.service.PgPayMidService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("pgPayMidService")
public class PgPayMidServiceImpl extends BaseServiceImpl<Map<String, Object>> implements PgPayMidService {

    @Autowired
    private PgPayMidDao pgPayMidDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.pgPayMidDao;
    }

}
