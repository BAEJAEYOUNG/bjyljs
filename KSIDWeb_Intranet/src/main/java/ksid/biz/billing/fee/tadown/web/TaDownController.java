/*
 *
 */
package ksid.biz.billing.fee.tadown.web;

import java.util.HashMap;
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

import ksid.biz.billing.fee.tadown.service.TaDownService;
import ksid.biz.billing.fee.tadown.web.TaDownController;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/fee/tadown")
public class TaDownController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(TaDownController.class);

    @Autowired
    private TaDownService taDownService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaDownController.view param [{}]", param);

        return "billing/fee/tadown";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaDownController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.taDownService.selDataList(param);

        logger.debug("TaDownController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.taDownService.excelDownload(request, response, "selTaDownList");
        } catch(Exception e) {

        }
    }

}
