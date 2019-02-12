package ksid.biz.ocuuser.usersearch.web;

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
public class UserSearchController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(UserSearchController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value= {"ocuuser/usersearch"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserSearchController.view usersearch param [{}]", param);

        return "usersearch";
    }


    // 원본
    @RequestMapping(value= {"ocuuser/usersearch2"})
    public String view2(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserSearchController.view ocu param [{}]", param);

        return "usersearch2";
    }


    // 난독화 Url
    @RequestMapping(value= {"ocuuser/usersearch2_ug"})
    public String viewUg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserSearchController.view ocu_ug param [{}]", param);

        return "usersearch2_ug";
    }

    @RequestMapping(value= {"ksid/usersearch"})
    public String ksidUsrSchview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserSearchController.view ksid param [{}]", param);

        return "ksid/usersearch";
    }

    @RequestMapping(value= {"sdu/usersearch"})
    public String sduUsrSchview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserSearchController.view sdu param [{}]", param);

        return "fidoapi/sdu/usersearch";
    }

    @RequestMapping(value= {"ocucons/usersearch"})
    public String ocuconsUsrSchView(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserSearchController.ocuconsUsrSchView param [{}]", param);

        return "fidoapi/ocucons/usersearch";
    }
}
