package ksid.biz.billing.bill.mstudr.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.bill.mstudr.service.MstUdrService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("mstUdrService")
public class MstUdrServiceImpl extends BaseServiceImpl<Map<String, Object>> implements MstUdrService {

    @Autowired
    private MstUdrDao mstUdrDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.mstUdrDao;
    }

}
