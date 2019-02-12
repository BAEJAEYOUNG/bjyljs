/*
 *
 */
package ksid.biz.registration.cust.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.cust.service.CustService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/cust")
public class CustController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(CustController.class);

    @Autowired
    private CustService custService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustController.view param [{}]", param);

        return "registration/cust";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.custService.selDataList(param);

        logger.debug("CustController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sel"})
    public String sel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustController.sel param [{}]", param);

        Map<String, Object> resultData = this.custService.selData(param);

        logger.debug("CustController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustController.ins param [{}]", param);

        int resultData = this.custService.insData(param);

        logger.debug("CustController.ins resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustController.upd param [{}]", param);

        int resultData = this.custService.updData(param);

        logger.debug("CustController.upd resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustController.del param {}", param);

        int resultData = this.custService.delData(param);

        logger.debug("CustController.del resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "termination success !");

        return "json";
    }

}
