/*
 *
 */
package ksid.biz.billing.work.dltaskhis.web;

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

import ksid.biz.billing.work.dltaskhis.service.DlTaskHisService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/dltaskhis")
public class DlTaskHisController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(DlTaskHisController.class);

    @Autowired
    private DlTaskHisService dlTaskHisService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("DlTaskHisController.view param [{}]", param);

        return "billing/work/dltaskhis";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("DlTaskHisController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.dlTaskHisService.selDataList(param);

        logger.debug("DlTaskHisController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.dlTaskHisService.excelDownload(request, response, "selDlTaskHisList");
        } catch(Exception e) {

        }
    }

    @RequestMapping(value= {"setdlflagon"})
    public String setdlflagon(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("DlTaskHisController.setdlflagon param [{}]", param);

        param.put("dlFlag", "1");
        int updCnt = this.dlTaskHisService.updData("updSetDlFlag", param);

        logger.debug("DlTaskHisController.upd updCnt {}", updCnt);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "set dlFlag On success !");

        return "json";
    }

    @RequestMapping(value= {"setdlflagoff"})
    public String setdlflagoff(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("DlTaskHisController.setdlflagoff param [{}]", param);

        param.put("dlFlag", "0");
        int updCnt = this.dlTaskHisService.updData("updSetDlFlag", param);

        logger.debug("DlTaskHisController.upd updCnt {}", updCnt);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "set dlFlag Off success !");

        return "json";
    }

    @RequestMapping(value= {"codeComboList"})
    public String comboList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("DlTaskHisController.codeComboList param [{}]", param);

        List<Map<String, Object>> resultData = this.dlTaskHisService.selDataList("codeComboList", param);

        logger.debug("DlTaskHisController.codeComboList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


}
