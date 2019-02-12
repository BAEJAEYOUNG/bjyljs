package ksid.biz.teeservice.web;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.user.service.UserService;
import ksid.biz.teeservice.service.TeeSvcService;
import ksid.core.webmvc.base.web.BaseController;

@Controller
public class TeeSvcController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(TeeSvcController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value= {"teesvc"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.view param [{}]", param);

        return "teesvc";
    }

}
