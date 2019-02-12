/*
 *
 */
package ksid.biz.product.spservpolicy.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.product.spservpolicy.service.SpServPolicyService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("product/spservpolicy")
public class SpServPolicyController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SpServPolicyController.class);

    @Autowired
    private SpServPolicyService spServPolicyService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpServPolicyController.view param [{}]", param);

        return "product/spservpolicy";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpServPolicyController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.spServPolicyService.selDataList(param);

        logger.debug("SpServPolicyController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sel"})
    public String sel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpServPolicyController.sel param [{}]", param);

        Map<String, Object> resultData = this.spServPolicyService.selData(param);

        logger.debug("SpServPolicyController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selServPolicyId"})
    public String selServPolicyId(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpServPolicyController.selServPolicyId param [{}]", param);

        String resultData = (String)this.spServPolicyService.selValue("selServPoliceId", param);

        logger.debug("SpServPolicyController.selServPolicyId resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpServPolicyController.ins param [{}]", param);

        int cntExist = this.spServPolicyService.insDataMulti(param);

        if( 0 == cntExist ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "insert success !");
        } else {
            model.addAttribute("resultCd", "01");
            model.addAttribute("resultData", "해당 정책이 이미 존재합니다 !");
        }

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpServPolicyController.upd param [{}]", param);

        int cntExist = this.spServPolicyService.updDataMulti(param);

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

        logger.debug("SpServPolicyController.del param {}", param);

        int resultFixData = this.spServPolicyService.delData(param);
        int resultCaseData = this.spServPolicyService.delData("delSpServCasePolicy", param);

        logger.debug("SpServPolicyController.del resultFixData {}", resultFixData);
        logger.debug("SpServPolicyController.del resultCaseData {}", resultCaseData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "termination success !");

        return "json";
    }

    @RequestMapping(value= {"selSpServCasePolicyList"})
    public String selSpServCasePolicyList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpServPolicyController.listSpServCasePolicy param [{}]", param);

        List<Map<String, Object>> resultData = this.spServPolicyService.selDataList("selSpServCasePolicyList", param);

        logger.debug("SpServPolicyController.listSpServCasePolicy resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selComboPolicyList"})
    public String selComboPolicyList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillingCommController.selComboPolicyList param [{}]", param);

        List<Map<String, Object>> resultData = this.spServPolicyService.selDataList("selComboPolicyList", param);

        logger.debug("BillingCommController.selComboPolicyList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

}
