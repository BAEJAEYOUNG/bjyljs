/*
 *
 */
package ksid.biz.registration.custuser.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.custuser.service.CustUserService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/custuser")
public class CustUserController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(CustUserController.class);

    @Autowired
    private CustUserService custUserService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustUserController.view param [{}]", param);

        return "registration/custUser";
    }

    @RequestMapping(value= {"custList"})
    public String custList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustUserController.custList param [{}]", param);

        List<Map<String, Object>> resultData = this.custUserService.selDataList("selCustList", param);

        logger.debug("CustUserController.custList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustUserController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.custUserService.selDataList(param);

        logger.debug("CustUserController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"listDialog"})
    public String listDialog(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustUserController.listDialog param [{}]", param);

        List<Map<String, Object>> resultData = this.custUserService.selDataList("selDialogUserList", param);

        logger.debug("CustUserController.listDialog resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("CustUserController.ins param [{}]", param);

        int resultData = this.custUserService.insDataList(param);

        logger.debug("CustUserController.ins resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("CustUserController.del param [{}]", param);

        int resultData = this.custUserService.delDataList(param);

        logger.debug("CustUserController.del resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "termination success !");

        return "json";
    }
}
