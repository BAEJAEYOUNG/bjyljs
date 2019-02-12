package ksid.biz.devauth.mobileauth.service;

import java.util.Map;

import ksid.core.webmvc.base.service.BaseService;

public interface MobileAuthService extends BaseService<Map<String, Object>> {

    public Map<String, Object> serviceHistWrite(Map<String, Object> param);

}
