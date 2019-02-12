package ksid.biz.main.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.main.service.MainService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("mainService")
public class MainServiceImpl extends BaseServiceImpl<Map<String, Object>> implements MainService {

    @Autowired
    private MainDao mainDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.mainDao;
    }

}
