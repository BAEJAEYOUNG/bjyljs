package ksid.biz.admin.system.menu.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.admin.system.menu.service.MenuService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("menuService")
public class MenuServiceImpl extends BaseServiceImpl<Map<String, Object>> implements MenuService {

    @Autowired
    private MenuDao menuDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.menuDao;
    }

}
