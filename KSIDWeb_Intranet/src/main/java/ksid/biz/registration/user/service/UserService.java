/*
 *
 */
package ksid.biz.registration.user.service;

import java.util.Map;

import ksid.core.webmvc.base.service.BaseService;

/**
 *
 * @author Administrator
 */
public interface UserService extends BaseService<Map<String, Object>> {

    String callProc( String statementId, Map<String,Object> param );

    Map<String, Object> selectCustFixBill( Map<String, Object> param );

}
