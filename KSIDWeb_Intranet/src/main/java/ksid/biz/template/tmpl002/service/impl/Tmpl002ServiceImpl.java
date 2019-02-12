package ksid.biz.template.tmpl002.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.template.tmpl002.service.Tmpl002Service;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("tmpl002Service")
public class Tmpl002ServiceImpl extends BaseServiceImpl<Map<String, Object>> implements Tmpl002Service {

    @Autowired
    private Tmpl002Dao tmpl002dao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.tmpl002dao;
    }

}
