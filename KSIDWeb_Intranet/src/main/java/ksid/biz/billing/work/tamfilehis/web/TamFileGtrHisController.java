/*
 *
 */
package ksid.biz.billing.work.tamfilehis.web;

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

import ksid.biz.billing.work.tamfilehis.service.TamFileGtrHisService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/tamfilehis")
public class TamFileGtrHisController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(TamFileGtrHisController.class);

    @Autowired
    private TamFileGtrHisService tamFileGtrHisService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TamFileGtrHisController.view param [{}]", param);

        return "billing/work/tamfilehis";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TamFileGtrHisController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.tamFileGtrHisService.selDataList(param);

        logger.debug("TamFileGtrHisController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.tamFileGtrHisService.excelDownload(request, response, "selTamFileGtrHisList");
        } catch(Exception e) {

        }
    }


}
