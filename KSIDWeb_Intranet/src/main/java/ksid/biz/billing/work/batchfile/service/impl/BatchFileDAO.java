package ksid.biz.billing.work.batchfile.service.impl;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Repository;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import ksid.core.webmvc.base.service.impl.BaseDao;

@Repository
public class BatchFileDAO extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_BatchFile";
    }

    @Override
    protected String getMapperId() {

        return "BatchFile";
    }

}
