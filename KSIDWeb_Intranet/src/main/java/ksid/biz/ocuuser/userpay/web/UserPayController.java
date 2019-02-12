package ksid.biz.ocuuser.userpay.web;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.user.service.UserService;
import ksid.core.webmvc.base.web.BaseController;

@Controller
public class UserPayController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(UserPayController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value= {"ocuuser/userpay"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayController.view param [{}]", param);

        return "userpay";
    }

    @RequestMapping(value= {"ocuuser/userpay2"})
    public String view2(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayController.view ocu param [{}]", param);

        return "userpay2";
    }

    @RequestMapping(value= {"ksid/userpay"})
    public String ksidPayView(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayController.view ksid param [{}]", param);

        return "ksid/userpay";
    }

    @RequestMapping(value= {"sdu/userpay"})
    public String sduPayView(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayController.sduPayView param [{}]", param);

        return "fidoapi/sdu/userpay";
    }

    @RequestMapping(value= {"ocucons/userpay"})
    public String ocuconsPayView(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayController.ocuconsPayView param [{}]", param);

        return "fidoapi/ocucons/userpay";
    }

}
