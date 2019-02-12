/*
 *
 */
package ksid.biz.login.service;

import java.util.Map;

import org.springframework.security.core.userdetails.UserDetailsService;

import ksid.core.webmvc.base.service.BaseService;

/**
 *
 * @author Administrator
 */
public interface LoginService extends BaseService<Map<String, Object>>, UserDetailsService {

}
