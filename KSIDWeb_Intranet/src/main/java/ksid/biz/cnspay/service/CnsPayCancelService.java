package ksid.biz.cnspay.service;

import java.util.Map;

import ksid.core.webmvc.base.service.BaseService;

public interface CnsPayCancelService extends BaseService<Map<String, Object>> {
    String callProc( String statementId, Map<String,Object> param );
}
