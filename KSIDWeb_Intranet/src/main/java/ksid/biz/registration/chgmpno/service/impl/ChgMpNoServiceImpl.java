package ksid.biz.registration.chgmpno.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.chgmpno.service.ChgMpNoService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("chgMpNoService")
public class ChgMpNoServiceImpl extends BaseServiceImpl<Map<String, Object>> implements ChgMpNoService {

    @Autowired
    private ChgMpNoDao chgMpNoDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.chgMpNoDao;
    }


    @Override
    public String callProc(String statementId, Map<String, Object> param) {

        return this.chgMpNoDao.callProc( statementId, param );

    }
}
