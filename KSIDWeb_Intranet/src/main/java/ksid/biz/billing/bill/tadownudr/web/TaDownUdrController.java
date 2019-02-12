/*
 *
 */
package ksid.biz.billing.bill.tadownudr.web;

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

import ksid.biz.billing.bill.tadownudr.service.TaDownUdrService;
import ksid.biz.billing.bill.tadownudr.web.TaDownUdrController;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/bill/tadownudr")
public class TaDownUdrController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(TaDownUdrController.class);

    @Autowired
    private TaDownUdrService taDownUdrService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaDownUdrController.view param [{}]", param);

        return "billing/bill/tadownudr";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaDownUdrController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.taDownUdrService.selDataList(param);

        logger.debug("TaDownUdrController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.taDownUdrService.excelDownload(request, response, "selTaDownUdrList");
        } catch(Exception e) {

        }
    }

}
