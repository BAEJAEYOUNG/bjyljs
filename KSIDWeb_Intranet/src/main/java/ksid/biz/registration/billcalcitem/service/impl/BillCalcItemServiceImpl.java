package ksid.biz.registration.billcalcitem.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.billcalcitem.service.BillCalcItemService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("billCalcItemService")
public class BillCalcItemServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BillCalcItemService {

    @Autowired
    private BillCalcItemDao billCalcItemDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.billCalcItemDao;
    }

}
