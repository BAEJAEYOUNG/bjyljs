/*
 *
 */
package ksid.biz.registration.userservicecancel.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.devauth.mobileauth.service.impl.MobileAuthDao;
import ksid.biz.registration.userservicecancel.service.UserServiceCancelService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/userservicecancel")
public class UserServiceCancelController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(UserServiceCancelController.class);

    @Autowired
    private UserServiceCancelService userServiceCancelService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserServiceCancelController.view param [{}]", param);

        return "registration/userservicecancel";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserServiceCancelController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.userServiceCancelService.selDataList(param);

        logger.debug("UserController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"list2"})
    public String list2(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserServiceCancelController.list2 param [{}]", param);

        List<Map<String, Object>> resultData = this.userServiceCancelService.selDataList("selServHisByUserList", param);

        logger.debug("UserController.list2 resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"list3"})
    public String list3(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserServiceCancelController.list3 param [{}]", param);

        List<Map<String, Object>> resultData = this.userServiceCancelService.selDataList("selPayList", param);

        logger.debug("UserController.list3 resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

}
