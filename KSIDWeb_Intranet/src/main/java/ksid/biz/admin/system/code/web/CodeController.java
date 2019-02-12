/*
 *
 */
package ksid.biz.admin.system.code.web;

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

import ksid.biz.admin.system.code.service.CodeService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("admin/system/code")
public class CodeController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(CodeController.class);

    @Autowired
    private CodeService codeService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.view param [{}]", param);

        return "admin/system/code";
    }

    @RequestMapping(value= {"selGroupList"})
    public String selGroupList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.selGroupList param [{}]", param);

        List<Map<String, Object>> resultData = this.codeService.selDataList("selCodeGroupList", param);

        logger.debug("CodeController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selGroup"})
    public String selGroup(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.selGroupList param {}", param);

        Map<String, Object> resultData = this.codeService.selData("selCodeGroup", param);

        logger.debug("CodeController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insGroup"})
    public String insGroup(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.insGroup param [{}]", param);

        int cntIns = this.codeService.insData("insCodeGroup", param);

        logger.debug("CodeController.cntIns : {}", cntIns);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"updGroup"})
    public String updGroup(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.updGroup param [{}]", param);

        int cntUpd = this.codeService.updData("updCodeGroup", param);

        logger.debug("CodeController.cntUpd : {}", cntUpd);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"delGroup"})
    public String delGroup(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.delGroup param [{}]", param);

        // 코드그룹 삭제시 하위에 있는 코드도 모두 삭제한다.

        // 1. 코드그룹 삭제
        int cntDelGroup = this.codeService.delData("delCodeGroup", param);

        logger.debug("CodeController.cntDel > cntDelGroup : {}", cntDelGroup);

        // 2. 해당 코드그룹 하위 코드 삭제
        int cntDelCode = this.codeService.delData("delCodeInGroup", param);

        logger.debug("CodeController.cntDel > delCodeInGroup : {}", cntDelCode);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"selCodeList"})
    public String selCodeList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.selCodeList param [{}]", param);

        List<Map<String, Object>> resultData = this.codeService.selDataList(param);

        logger.debug("CodeController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selCode"})
    public String selCode(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.selGroupList param [{}]", param);

        Map<String, Object> resultData = this.codeService.selData("selCode", param);

        logger.debug("CodeController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insCode"})
    public String insCode(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.insCode param [{}]", param);

        int cntIns = this.codeService.insData(param);

        logger.debug("CodeController.cntIns : {}", cntIns);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"updCode"})
    public String updCode(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.updCode param [{}]", param);

        int cntUpd = this.codeService.updData(param);

        logger.debug("CodeController.cntUpd : {}", cntUpd);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"delCode"})
    public String delCode(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.delCode param [{}]", param);

        int cntDel = this.codeService.delData(param);

        logger.debug("CodeController.cntDel : {}", cntDel);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"comboList"})
    public String comboList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.codeService.selDataList("selComboList", param);

        logger.debug("CodeController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"test"})
    public String codeTest(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CodeController.test param [{}]", param);

        String resultData = (String)this.codeService.selValue("selTest", param);

        logger.debug("CodeController.test resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

}
