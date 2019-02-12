/*
 *
 */
package ksid.biz.product.custfixbill.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.product.custfixbill.service.CustFixBillService;
import ksid.biz.registration.cust.service.CustService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("product/custfixbill")
public class CustFixBillController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(CustFixBillController.class);

    @Autowired
    private CustFixBillService custFixBillService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.view param [{}]", param);

        return "product/custfixbill";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.custFixBillService.selDataList(param);

        logger.debug("CustFixBillController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sel"})
    public String sel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.sel param [{}]", param);

        Map<String, Object> resultData = this.custFixBillService.selData(param);

        logger.debug("CustFixBillController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selServId"})
    public String selServId(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.selServId param [{}]", param);

        String resultData = (String)this.custFixBillService.selValue("selServId", param);

        logger.debug("CustFixBillController.selServId resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.ins param [{}]", param);

        int cntExist = this.custFixBillService.insDataMulti(param);

        if( 0 == cntExist ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "insert success !");
        } else {
            model.addAttribute("resultCd", "01");
            model.addAttribute("resultData", "해당 서비스아이디가 이미 존재합니다 !");
        }

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.upd param [{}]", param);

        int cntExist = this.custFixBillService.updDataMulti(param);

        if( 0 == cntExist ) {
            model.addAttribute("resultCd", "01");
            model.addAttribute("resultData", "해당 데이터가 존재하지 않습니다 !");
        } else {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "update success !");
        }

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.del param {}", param);

        int fixDelCnt = this.custFixBillService.delData("delCustFixBill", param);
        logger.debug("CustFixBillController.del fixDelCnt {}", fixDelCnt);

        int caseDelCnt = this.custFixBillService.delData("delCustCaseBill", param);
        logger.debug("CustFixBillController.del caseDelCnt {}", caseDelCnt);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "termination success !");

        return "json";
    }

    @RequestMapping(value= {"listCustCaseBill"})
    public String listCustCaseBill(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.listCustCaseBill param [{}]", param);

        List<Map<String, Object>> resultData = this.custFixBillService.selDataList("selCustCaseBillList", param);

        logger.debug("CustFixBillController.listCustCaseBill resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selSpServPolicy"})
    public String selSpServPolicy(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpServPolicyController.sel param [{}]", param);

        Map<String, Object> resultData = this.custFixBillService.selData("selSpServPolicy", param);

        logger.debug("SpServPolicyController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

}
