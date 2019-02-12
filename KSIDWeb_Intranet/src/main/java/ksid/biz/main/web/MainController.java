/*
 *
 */
package ksid.biz.main.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.main.service.MainService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping(value= {"/main"})
public class MainController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(MainController.class);

    @Autowired
    private HttpSession session;

    @Autowired
    private MainService mainService;

//    @Autowired
//    private MessageSource messageSource;

    @RequestMapping(value= {""})
    public String root(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MainController.root param [{}]", param);

//        logger.debug("MainController.root message [{}]", this.messageSource.getMessage("TEST", null, Locale.getDefault()));

//        return "index";
        return "main/main";
    }

    @RequestMapping(value= {"main"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MainController.main param [{}]", param);

//        logger.debug("MainController.main message [{}]", this.messageSource.getMessage("TEST", null, Locale.getDefault()));

        return "main/main";
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value= {"mainMenuList"})
    public String mainMenuList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MainController.mainMenuList param [{}]", param);

        Map<String, Object> sessionUser = (Map<String, Object>)this.session.getAttribute("sessionUser");

        param.put("adminId", sessionUser.get("adminId"));

        List<Map<String, Object>> resultData = this.mainService.selDataList("selMainMenuList", param);

        logger.debug("MainController.mainMenuList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }
}
