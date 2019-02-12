package ksid.biz.login.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;

import ksid.core.webmvc.security.AbstractLogoutSuccessHandler;

public class LogoutSuccessHandler extends AbstractLogoutSuccessHandler {

    protected static final Logger logger = LoggerFactory.getLogger(LogoutSuccessHandler.class);

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
            throws IOException, ServletException {

        logger.debug("LogoutSuccessHandler.process Authentication [{}]", authentication);

//        HttpSession session = request.getSession(false);
//        session.invalidate();
    }
}
