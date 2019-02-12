/*
 *
 */
package ksid.biz.product.cls.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.product.cls.service.ClsService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("product/cls")
public class ClsController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(ClsController.class);

    @Autowired
    private ClsService clsService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.view param [{}]", param);

        return "product/cls";
    }

    @RequestMapping(value= {"selLclsList"})
    public String selLclsList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.selLclsList param [{}]", param);

        // List<Map<String, Object>> resultData = this.clsService.selDataList("selLclsList", param);
        List<Map<String, Object>> resultData = this.clsService.selDataList("selLclsList", param);

        logger.debug("ClsController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selLcls"})
    public String selLcls(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.selLclsList param {}", param);

        Map<String, Object> resultData = this.clsService.selData("selLcls", param);

        logger.debug("ClsController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insLcls"})
    public String insLcls(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.insLcls param [{}]", param);

        int cntIns = this.clsService.insData("insLcls", param);

        logger.debug("ClsController.cntIns : {}", cntIns);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"updLcls"})
    public String updLcls(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.updLcls param [{}]", param);

        int cntUpd = this.clsService.updData("updLcls", param);

        logger.debug("ClsController.cntUpd : {}", cntUpd);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"delLcls"})
    public String delLcls(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.delLcls param [{}]", param);

        int cntDel = this.clsService.delData("delLcls", param);

        logger.debug("ClsController.cntDel : {}", cntDel);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"selMclsList"})
    public String selMclsList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.selMclsList param [{}]", param);

        List<Map<String, Object>> resultData = this.clsService.selDataList("selMclsList", param);

        logger.debug("ClsController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selMcls"})
    public String selMcls(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.selMclsList param [{}]", param);

        Map<String, Object> resultData = this.clsService.selData("selMcls", param);

        logger.debug("ClsController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insMcls"})
    public String insMcls(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.insMcls param [{}]", param);

        int cntIns = this.clsService.insData("insMcls", param);

        logger.debug("ClsController.cntIns : {}", cntIns);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"updMcls"})
    public String updMcls(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.updMcls param [{}]", param);

        int cntUpd = this.clsService.updData("updMcls", param);

        logger.debug("ClsController.cntUpd : {}", cntUpd);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"delMcls"})
    public String delMcls(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.delMcls param [{}]", param);

        int cntDel = this.clsService.delData("delMcls", param);

        logger.debug("ClsController.cntDel : {}", cntDel);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"comboList"})
    public String comboList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ClsController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.clsService.selDataList("selComboList", param);

        logger.debug("ClsController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

}
