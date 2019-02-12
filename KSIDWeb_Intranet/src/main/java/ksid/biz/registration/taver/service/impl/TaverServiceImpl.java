package ksid.biz.registration.taver.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.registration.taver.service.TaverService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("taverService")
public class TaverServiceImpl extends BaseServiceImpl<Map<String, Object>> implements TaverService {

    @Autowired
    private TaverDao taverDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.taverDao;
    }

}
