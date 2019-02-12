package ksid.biz.billing.settle.settadown.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.settle.settadown.service.SetTaDownService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("setTaDownService")
public class SetTaDownServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SetTaDownService {

    @Autowired
    private SetTaDownDao setTaDownDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.setTaDownDao;
    }

}
