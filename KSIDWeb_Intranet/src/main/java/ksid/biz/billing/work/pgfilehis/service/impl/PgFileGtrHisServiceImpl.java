package ksid.biz.billing.work.pgfilehis.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.pgfilehis.service.PgFileGtrHisService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("pgFileGtrHisService")
public class PgFileGtrHisServiceImpl extends BaseServiceImpl<Map<String, Object>> implements PgFileGtrHisService {

    @Autowired
    private PgFileGtrHisDao pgFileGtrHisDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.pgFileGtrHisDao;
    }

}
