package ksid.biz.login.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import ksid.biz.login.service.LoginService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("loginService")
public class LoginServiceImpl extends BaseServiceImpl<Map<String, Object>> implements LoginService {

    protected static final Logger logger = LoggerFactory.getLogger(LoginServiceImpl.class);

//    @Autowired
//    private RedisTemplate<String, String> redisTemplate;

//    @Resource(name="redisTemplate")
//    private ValueOperations<String, String> valueOps;

    @Autowired
    private LoginDao loginDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.loginDao;
    }

    @Override
    public UserDetails loadUserByUsername(String adminId) throws UsernameNotFoundException {

        logger.debug("LoginServiceImpl.loadUserByUsername adminId [{}]", adminId);

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("adminId", adminId);

        Map<String, Object> data = this.loginDao.selData(param);

        logger.debug("LoginServiceImpl.loadUserByUsername data [{}]", data);

        if (ObjectUtils.isEmpty(data)) {
            return User.withUsername(adminId)
                       .password("")
                       .authorities(new ArrayList<GrantedAuthority>())
                       .disabled(true)
                       .build();
        }

        String adminPw = String.valueOf(data.get("adminPw"));

        List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();

        String[] roles = String.valueOf(data.get("authGroupCd")).split(",");
//        String[] roles = new String[]{"ROLE_agc000", "ROLE_USER", "ROLE_ADMIN"};
        for (String role : roles) {
            authorities.add(new SimpleGrantedAuthority(String.format("ROLE_%s", role)));
        }

        logger.debug("LoginServiceImpl.loadUserByUsername authorities [{}]", authorities);

        UserDetails user = new User(adminId, adminPw, authorities);

        logger.debug("LoginServiceImpl.loadUserByUsername user [{}]", user);

//        valueOps.set("adminId", adminId);

        return user;
    }
}
