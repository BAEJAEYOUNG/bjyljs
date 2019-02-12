package ksid.biz.sp.registration.user.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.sp.registration.user.service.SvcPvdUserService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("svcPvdUserService")
public class SvcPvdUserServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SvcPvdUserService  {

    @Autowired
    private SvcPvdUserDao svcPvdUserDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.svcPvdUserDao;
    }

//    @Override
//    public String callProc(String statementId, Map<String, Object> param) {
//
//        return this.svcPvdUserDao.callProc( statementId, param );
//
//    }
//
//    @Override
//    public Map<String, Object> selectCustFixBill(Map<String, Object> param) {
//
//        return this.svcPvdUserDao.selectCustFixBill( param );
//    }

}
