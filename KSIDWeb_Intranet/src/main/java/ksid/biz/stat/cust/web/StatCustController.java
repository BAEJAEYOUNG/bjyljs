/*
 *
 */
package ksid.biz.stat.cust.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.stat.cust.service.StatCustService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("stat/cust")
public class StatCustController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(StatCustController.class);

    @Autowired
    private StatCustService statCustService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustController.view param [{}]", param);

        return "stat/statCust";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustController.list param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustService.selDataList(param);

        logger.debug("StatCustController.list dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"fixServByCustList"})
    public String fixServByCustList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustController.fixServByCustList param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustService.selDataList("selFixServByCustList", param);

        logger.debug("StatCustController.fixServByCustList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"caseServByCustList"})
    public String caseServByCustList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustController.caseServByCustList param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustService.selDataList("selCaseServByCustList", param);

        logger.debug("StatCustController.caseServByCustList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"basicDiscountByCustList"})
    public String basicDiscountByCustList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustController.basicDiscountByCustList param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustService.selDataList("selBasicDiscountByCustList", param);

        logger.debug("StatCustController.basicDiscountByCustList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"promoDiscountByCustList"})
    public String promoDiscountByCustList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustController.promoDiscountByCustList param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustService.selDataList("selPromoDiscountByCustList", param);

        logger.debug("StatCustController.promoDiscountByCustList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }


}
