/*
 *
 */
package ksid.biz.billing.bill.totaludr.web;

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

import ksid.biz.billing.bill.totaludr.service.TotalUdrService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/bill/totaludr")
public class TotalUdrController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(TotalUdrController.class);

    @Autowired
    private TotalUdrService totalUdrService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TotalUdrController.view param [{}]", param);

        return "billing/bill/totaludr";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TotalUdrController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.totalUdrService.selDataList(param);

        logger.debug("TotalUdrController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.totalUdrService.excelDownload(request, response, "selTotalUdrList");
        } catch(Exception e) {

        }
    }

}
