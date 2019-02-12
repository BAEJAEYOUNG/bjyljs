/*
 *
 */
package ksid.biz.ocuuser.userinfo.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.ocuuser.userinfo.service.UserInfoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
//@RequestMapping("ocuuser/userInfo")
public class UserInfoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(UserInfoController.class);

    @Autowired
    private UserInfoService userInfoService;

    @RequestMapping(value= {"ocuuser/userInfo"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.view param [{}]", param);

        model.addAttribute("resultData", param);

        return "ocuuser/userInfo";
    }

    @RequestMapping(value= {"ocuuser/userInfo/list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.userInfoService.selDataList(param);

        logger.debug("UserInfoController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ocuuser/userInfo/sel"})
    public String sel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.sel param [{}]", param);

        Map<String, Object> resultData = this.userInfoService.selData(param);

        logger.debug("UserInfoController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ocuuser/userInfo/listPay"})
    public String listPay(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.listPay param [{}]", param);
        // {custId=C000018, language=kr, spCd=P0003, userId=U000000121}

        List<Map<String, Object>> resultData = this.userInfoService.selDataList("selPayList", param);

        logger.debug("UserInfoController.listPay resultData [{}]", resultData);
        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ksid/userInfo"})
    public String ksidview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.view ksid param [{}]", param);

        model.addAttribute("resultData", param);

        return "ksid/userInfo";
    }

    @RequestMapping(value= {"ksid/userInfo/list"})
    public String ksidlist(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.list ksid param [{}]", param);

        List<Map<String, Object>> resultData = this.userInfoService.selDataList(param);

        logger.debug("UserInfoController.list ksid resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ksid/userInfo/sel"})
    public String ksidsel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.sel ksid param [{}]", param);

        Map<String, Object> resultData = this.userInfoService.selData(param);

        logger.debug("UserInfoController.sel ksid resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ksid/userInfo/listPay"})
    public String ksidlistPay(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.listPay ksid param [{}]", param);
        // {custId=C000018, language=kr, spCd=P0003, userId=U000000121}

        List<Map<String, Object>> resultData = this.userInfoService.selDataList("selPayList", param);

        logger.debug("UserInfoController.listPay ksid resultData [{}]", resultData);
        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sdu/userInfo"})
    public String sduview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.view sdu param [{}]", param);

        model.addAttribute("resultData", param);

        return "fidoapi/sdu/userInfo";
    }

    @RequestMapping(value= {"sdu/userInfo/list"})
    public String sdulist(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.userInfoService.selDataList(param);

        logger.debug("UserInfoController.list sdu resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sdu/userInfo/sel"})
    public String sdusel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.sel param [{}]", param);

        Map<String, Object> resultData = this.userInfoService.selData(param);

        logger.debug("UserInfoController.sel sdu resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sdu/userInfo/listPay"})
    public String sdulistPay(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.listPay param [{}]", param);
        // {custId=C000018, language=kr, spCd=P0003, userId=U000000121}

        List<Map<String, Object>> resultData = this.userInfoService.selDataList("selPayList", param);

        logger.debug("UserInfoController.listPay resultData [{}]", resultData);
        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ocucons/userInfo"})
    public String ocuconsView(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.ocuconsView param [{}]", param);

        model.addAttribute("resultData", param);

        return "fidoapi/ocucons/userInfo";
    }

    @RequestMapping(value= {"ocucons/userInfo/list"})
    public String ocuconsList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.ocuconsList param [{}]", param);

        List<Map<String, Object>> resultData = this.userInfoService.selDataList(param);

        logger.debug("UserInfoController.ocuconsList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ocucons/userInfo/sel"})
    public String ocuconsSel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.ocuconsSel param [{}]", param);

        Map<String, Object> resultData = this.userInfoService.selData(param);

        logger.debug("UserInfoController.ocuconsSels resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ocucons/userInfo/listPay"})
    public String ocuconsListPay(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserInfoController.ocuconsListPay param [{}]", param);

        List<Map<String, Object>> resultData = this.userInfoService.selDataList("selPayList", param);

        logger.debug("UserInfoController.ocuconsListPay resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

}
