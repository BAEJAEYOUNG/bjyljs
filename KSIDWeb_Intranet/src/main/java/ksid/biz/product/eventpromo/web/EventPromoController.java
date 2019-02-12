/*
 *
 */
package ksid.biz.product.eventpromo.web;

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

import ksid.biz.product.eventpromo.service.EventPromoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("product/eventpromo")
public class EventPromoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(EventPromoController.class);

    @Autowired
    private EventPromoService eventPromoService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("EventPromoController.view param [{}]", param);

        return "product/eventpromo";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("EventPromoController.list param {}", param);

        List<Map<String, Object>> resultData = this.eventPromoService.selDataList(param);

        logger.debug("EventPromoController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("EventPromoController.insLcls param [{}]", param);

        int cntIns = this.eventPromoService.insData(param);

        logger.debug("EventPromoController.cntIns : {}", cntIns);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("EventPromoController.updLcls param [{}]", param);

        int cntUpd = this.eventPromoService.updData(param);

        logger.debug("EventPromoController.cntUpd : {}", cntUpd);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("EventPromoController.delLcls param [{}]", param);

        int cntDel = this.eventPromoService.delData(param);

        logger.debug("EventPromoController.cntDel : {}", cntDel);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"list2"})
    public String list2(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("EventPromoController.list2 param {}", param);

        List<Map<String, Object>> resultData = this.eventPromoService.selDataList("selCustEventDiscountList", param);

        logger.debug("EventPromoController.list2 resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selCustList"})
    public String selCustList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("EventPromoController.selCustList param {}", param);

        List<Map<String, Object>> resultData = this.eventPromoService.selDataList("selCustList", param);

        logger.debug("EventPromoController.selCustList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insCustList"})
    public String insCustList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("EventPromoController.insCustList param [{}]", param);

        int resultData = this.eventPromoService.insDataList("insCustList", param);

        logger.debug("EventPromoController.insCustList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"updCustList"})
    public String updCustList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("EventPromoController.updCustList param [{}]", param);

        int resultData = this.eventPromoService.updDataList("updCustList", param);

        logger.debug("EventPromoController.updCustList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"delCustList"})
    public String delCustList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("EventPromoController.delCustList param [{}]", param);

        int resultData = this.eventPromoService.delDataList("delCustList", param);

        logger.debug("EventPromoController.delCustList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

}
