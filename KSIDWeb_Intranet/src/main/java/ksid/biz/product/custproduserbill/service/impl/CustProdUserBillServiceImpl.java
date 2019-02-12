package ksid.biz.product.custproduserbill.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.product.custproduserbill.service.CustProdUserBillService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("custProdUserBillService")
public class CustProdUserBillServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CustProdUserBillService {

    @Autowired
    private CustProdUserBillDao custProdUserBillDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.custProdUserBillDao;
    }

}
