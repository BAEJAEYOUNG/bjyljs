/*
 *
 */
package ksid.biz.login.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("login")
public class LoginController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(LoginController.class);

//    @Autowired
//    private LoginService loginService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model,
            HttpServletRequest request) {

        logger.debug("LoginController.view param [{}]", param);

        String ajaxHeader = ((HttpServletRequest)request).getHeader("X-Requested-With");
        boolean isAjaxCall = new Boolean(((HttpServletRequest)request).getHeader("ajax"));

        logger.debug("=====> LoginController.view ajaxHeader [{}]", ajaxHeader);
        logger.debug("=====> LoginController.view isAjaxCall [{}]", isAjaxCall);

        if ("XMLHttpRequest".equals(ajaxHeader)) {
            if (isAjaxCall) {
                model.addAttribute("resultCd", "98");

                return "json";
            } else {
                return "index";
            }
        } else {
            return "login/login";
        }
    }

    @RequestMapping(value= {"success"})
    public String success(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("LoginController.success param [{}]", param);

        return "login/success";
    }

    @RequestMapping(value= {"fail"})
    public String fail(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("LoginController.fail param [{}]", param);

        return "login/fail";
    }
}
