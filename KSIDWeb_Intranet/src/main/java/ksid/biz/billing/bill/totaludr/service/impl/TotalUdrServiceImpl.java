package ksid.biz.billing.bill.totaludr.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.bill.totaludr.service.TotalUdrService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("totalUdrService")
public class TotalUdrServiceImpl extends BaseServiceImpl<Map<String, Object>> implements TotalUdrService {

    @Autowired
    private TotalUdrDao totalUdrDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.totalUdrDao;
    }

}
