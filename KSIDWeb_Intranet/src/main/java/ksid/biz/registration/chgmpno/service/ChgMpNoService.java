/*
 *
 */
package ksid.biz.registration.chgmpno.service;

import java.util.Map;

import ksid.core.webmvc.base.service.BaseService;

/**
 *
 * @author Administrator
 */
public interface ChgMpNoService extends BaseService<Map<String, Object>> {

    String callProc( String statementId, Map<String,Object> param );

}
