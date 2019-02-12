package ksid.biz.product.cls.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.product.cls.service.ClsService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("clsService")
public class ClsServiceImpl extends BaseServiceImpl<Map<String, Object>> implements ClsService {

    @Autowired
    private ClsDao clsDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.clsDao;
    }

}
