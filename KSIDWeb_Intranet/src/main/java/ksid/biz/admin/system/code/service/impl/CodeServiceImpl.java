package ksid.biz.admin.system.code.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.admin.system.code.service.CodeService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("codeService")
public class CodeServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CodeService {

    @Autowired
    private CodeDao codeDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.codeDao;
    }

}
