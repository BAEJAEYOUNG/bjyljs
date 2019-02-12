package ksid.biz.login.security;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;

import ksid.biz.login.service.LoginService;
import ksid.core.webmvc.security.AbstractLoginSuccessHandler;

public class LoginSuccessHandler extends AbstractLoginSuccessHandler {

    protected static final Logger logger = LoggerFactory.getLogger(LoginSuccessHandler.class);

    @Autowired
    private LoginService loginService;

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
            throws IOException, ServletException {

        logger.debug("LoginSuccessHandler.process Authentication [{}]", authentication);

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("adminId", authentication.getName());

        logger.debug("LoginSuccessHandler.process param [{}]", param);

        request.getSession().setAttribute("sessionUser", this.loginService.selData("selSessionInfo", param));
    }
}