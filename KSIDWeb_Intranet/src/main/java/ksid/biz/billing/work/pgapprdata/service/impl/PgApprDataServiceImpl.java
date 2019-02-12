package ksid.biz.billing.work.pgapprdata.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.pgapprdata.service.PgApprDataService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("pgApprDataService")
public class PgApprDataServiceImpl extends BaseServiceImpl<Map<String, Object>> implements PgApprDataService {

    @Autowired
    private PgApprDataDao pgApprDataDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.pgApprDataDao;
    }

}
