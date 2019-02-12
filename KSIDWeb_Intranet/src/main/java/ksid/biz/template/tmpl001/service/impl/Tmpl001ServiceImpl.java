package ksid.biz.template.tmpl001.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.template.tmpl001.service.Tmpl001Service;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("tmpl001Service")
public class Tmpl001ServiceImpl extends BaseServiceImpl<Map<String, Object>> implements Tmpl001Service {

    @Autowired
    private Tmpl001Dao tmpl001dao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.tmpl001dao;
    }

}
