package ksid.biz.registration.pg.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.pg.service.PgService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("pgService")
public class PgServiceImpl extends BaseServiceImpl<Map<String, Object>> implements PgService {

    @Autowired
    private PgDao pgDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.pgDao;
    }

}
