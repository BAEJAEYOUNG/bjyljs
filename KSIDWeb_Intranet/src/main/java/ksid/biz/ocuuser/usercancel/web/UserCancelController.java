package ksid.biz.ocuuser.usercancel.web;

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
public class UserCancelController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(UserCancelController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value= {"ocuuser/usercancel"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserCancelController.view param [{}]", param);

        return "usercancel";
    }

    @RequestMapping(value= {"ksid/usercancel"})
    public String ksidUserCancelView(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserCancelController.view ksid param [{}]", param);

        return "ksid/usercancel";
    }

    @RequestMapping(value= {"sdu/usercancel"})
    public String sduUserCancelView(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserCancelController.view sdu param [{}]", param);

        return "fidoapi/sdu/usercancel";
    }

    @RequestMapping(value= {"ocucons/usercancel"})
    public String ocuconsUserCancelView(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserCancelController.ocuconsUserCancelView param [{}]", param);

        return "fidoapi/ocucons/usercancel";
    }

}
