package ksid.biz.cnspay.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.cnspay.service.CnsPayCancelService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("cnsPayCancelService")
public class CnsPayCancelServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CnsPayCancelService {

    @Autowired
    private CnsPayCancelDao cnsPayCancelDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.cnsPayCancelDao;
    }

    @Override
    public String callProc(String statementId, Map<String, Object> param) {

        return this.cnsPayCancelDao.callProc( statementId, param );

    }

}
