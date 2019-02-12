package ksid.biz.admin.system.manager.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.admin.system.manager.service.ManagerService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("managerService")
public class ManagerServiceImpl extends BaseServiceImpl<Map<String, Object>> implements ManagerService {

    @Autowired
    private ManagerDao managerDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.managerDao;
    }

}
