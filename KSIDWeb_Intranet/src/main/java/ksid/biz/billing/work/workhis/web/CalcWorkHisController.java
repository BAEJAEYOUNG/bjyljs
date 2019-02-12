/*
 *
 */
package ksid.biz.billing.work.workhis.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.billing.work.workhis.service.CalcWorkHisService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/workhis")
public class CalcWorkHisController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(CalcWorkHisController.class);

    @Autowired
    private CalcWorkHisService calcWorkHisService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CalcWorkHisController.view param [{}]", param);

        return "billing/work/workhis";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CalcWorkHisController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.calcWorkHisService.selDataList(param);

        logger.debug("CalcWorkHisController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.calcWorkHisService.excelDownload(request, response, "selCalcWorkHisList");
        } catch(Exception e) {

        }
    }

    @RequestMapping(value= {"codeComboList"})
    public String comboList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CalcWorkHisController.codeComboList param [{}]", param);

        List<Map<String, Object>> resultData = this.calcWorkHisService.selDataList("codeComboList", param);

        logger.debug("CalcWorkHisController.codeComboList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


}
