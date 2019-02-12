package ksid.biz.login.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;

import ksid.core.webmvc.security.AbstractLoginFailureHandler;

public class LoginFailureHandler extends AbstractLoginFailureHandler {

    protected static final Logger logger = LoggerFactory.getLogger(LoginFailureHandler.class);

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception)
            throws IOException, ServletException {

        logger.debug("LoginFailureHandler.process url [{}] AuthenticationException [{}]",
                request.getRequestURL().toString(), exception);
    }
}
