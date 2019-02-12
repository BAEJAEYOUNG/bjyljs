/*
 *
 */
package ksid.biz.userreg.web;

import java.util.List;
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

/**
 *
 * @author Administrator
 */
@Controller
public class UserRegController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(UserRegController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value= {"userreg"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserRegController.view ocu userreg param [{}]", param);

//        model.addAttribute("custUserNo", param.get("custUserNo"));
        return "userreg";
    }

    @RequestMapping(value= {"ksid/userreg"})
    public String ksidRegview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserRegController.view ksid userreg param [{}]", param);

//        model.addAttribute("custUserNo", param.get("custUserNo"));
        return "ksid/userreg";
    }

    @RequestMapping(value= {"userregmb"})
    public String viewMb(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserRegController.view userregmb param [{}]", param);

//        model.addAttribute("custUserNo", param.get("custUserNo"));
        return "userregmb";
    }


    @RequestMapping(value= {"userreg/reg"})
    public String reg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserRegController.reg param [{}]", param);

        String strResult = this.userService.callProc("joinUser", param);

        logger.debug("UserRegController.reg strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
//            model.addAttribute("resultData", "정상처리 되었습니다 !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }

    @RequestMapping(value= {"userreg2"})
    public String view2(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserRegController.view param [{}]", param);

        return "userreg2";
    }

    @RequestMapping(value= {"sdu/userreg"})
    public String sduRegview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserRegController.sduRegview param [{}]", param);

//        model.addAttribute("custUserNo", param.get("custUserNo"));
        return "fidoapi/sdu/userreg";
    }

    @RequestMapping(value= {"ocucons/userreg"})
    public String ocuconsRegview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserRegController.ocuconsRegview userreg param [{}]", param);

//        model.addAttribute("custUserNo", param.get("custUserNo"));
        return "fidoapi/ocucons/userreg";
    }

}
