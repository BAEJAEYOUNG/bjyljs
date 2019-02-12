/*
 *
 */
package ksid.biz.registration.billcalcitem.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.billcalcitem.service.BillCalcItemService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/billcalcitem")
public class BillCalcItemController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BillCalcItemController.class);

    @Autowired
    private BillCalcItemService billCalcItemService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCalcItemController.view param [{}]", param);

        return "registration/billcalcitem";
    }

    @RequestMapping(value= {"selBillCalcItemList"})
    public String selBillCalcItemList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCalcItemController.selBillCalcItemList param [{}]", param);

        List<Map<String, Object>> resultData = this.billCalcItemService.selDataList("selBillCalcItemList", param);

        logger.debug("BillCalcItemController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selBillCalcItem"})
    public String selBillCalcItem(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCalcItemController.selBillCalcItem param {}", param);

        Map<String, Object> resultData = this.billCalcItemService.selData("selBillCalcItem", param);

        logger.debug("BillCalcItemController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insBillCalcItem"})
    public String insBillCalcItem(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCalcItemController.insBillCalcItem param [{}]", param);

        int cntIns = this.billCalcItemService.insData("insBillCalcItem", param);

        logger.debug("BillCalcItemController.cntIns : {}", cntIns);
        if(cntIns == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "insert success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "insert failure !");
        }

        return "json";
    }

    @RequestMapping(value= {"updBillCalcItem"})
    public String updBillCalcItem(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCalcItemController.updBillCalcItem param [{}]", param);

        int cntUpd = this.billCalcItemService.updData("updBillCalcItem", param);

        logger.debug("BillCalcItemController.cntUpd : {}", cntUpd);
        if(cntUpd == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "update success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "update failure !");
        }
        return "json";
    }

    @RequestMapping(value= {"delBillCalcItem"})
    public String delBillCalcItem(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCalcItemController.delBillCalcItem param [{}]", param);

        int cntDel = this.billCalcItemService.delData("delBillCalcItem", param);

        logger.debug("BillCalcItemController.cntDel : {}", cntDel);
        if(cntDel == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "delete success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "delete failure !");
        }

        return "json";
    }

}
