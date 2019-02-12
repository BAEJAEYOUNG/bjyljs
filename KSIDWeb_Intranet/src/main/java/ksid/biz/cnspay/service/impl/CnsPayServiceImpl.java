package ksid.biz.cnspay.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.cnspay.service.CnsPayService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("cnsPayService")
public class CnsPayServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CnsPayService {

    @Autowired
    private CnsPayDao cnsPayDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.cnsPayDao;
    }

}
