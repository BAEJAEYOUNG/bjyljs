/*
 *
 */
package ksid.biz.product.basicpromo.web;

import java.util.HashMap;
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

import ksid.biz.product.basicpromo.service.BasicPromoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("product/basicpromo")
public class BasicPromoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BasicPromoController.class);

    @Autowired
    private BasicPromoService basicPromoService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BasicPromoController.view param [{}]", param);

        return "product/basicpromo";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BasicPromoController.list param {}", param);

        List<Map<String, Object>> resultData = this.basicPromoService.selDataList(param);

        logger.debug("BasicPromoController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BasicPromoController.insLcls param [{}]", param);

        int cntIns = this.basicPromoService.insData(param);

        logger.debug("BasicPromoController.cntIns : {}", cntIns);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BasicPromoController.updLcls param [{}]", param);

        int cntUpd = this.basicPromoService.updData(param);

        logger.debug("BasicPromoController.cntUpd : {}", cntUpd);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BasicPromoController.delLcls param [{}]", param);

        int cntDel = this.basicPromoService.delData(param);

        logger.debug("BasicPromoController.cntDel : {}", cntDel);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"list2"})
    public String list2(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BasicPromoController.list2 param {}", param);

        List<Map<String, Object>> resultData = this.basicPromoService.selDataList("selCustBasicDiscountList", param);

        logger.debug("BasicPromoController.list2 resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selCustList"})
    public String selCustList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BasicPromoController.selCustList param {}", param);

        List<Map<String, Object>> resultData = this.basicPromoService.selDataList("selCustList", param);

        logger.debug("BasicPromoController.selCustList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insCustList"})
    public String insCustList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("BasicPromoController.insCustList param [{}]", param);

        int resultData = this.basicPromoService.insDataList("insCustList", param);

        logger.debug("BasicPromoController.insCustList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"updCustList"})
    public String updCustList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("BasicPromoController.updCustList param [{}]", param);

        int resultData = this.basicPromoService.updDataList("updCustList", param);

        logger.debug("BasicPromoController.updCustList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"delCustList"})
    public String delCustList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("BasicPromoController.delCustList param [{}]", param);

        int resultData = this.basicPromoService.delDataList("delCustList", param);

        logger.debug("BasicPromoController.delCustList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

}
