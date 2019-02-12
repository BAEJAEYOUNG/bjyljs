/*
 *
 */
package ksid.biz.billing.req.billbiz.web;

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

import ksid.biz.billing.req.billbiz.service.BillBizService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/req/billbiz")
public class BillBizController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BillBizController.class);

    @Autowired
    private BillBizService billBizService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillBizController.view param [{}]", param);

        return "billing/req/billbiz";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillBizController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.billBizService.selDataList(param);

        logger.debug("BillBizController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"listDtl"})
    public String listDtl(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillBizController.listDtl param [{}]", param);

        List<Map<String, Object>> resultData = this.billBizService.selDataList("selBillBizDtlList", param);

        logger.debug("BillBizController.listDtl resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billBizService.excelDownload(request, response, "selBillBizList");
        } catch(Exception e) {

        }
    }

    @RequestMapping(value= {"excel2"})
    public void excel2(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billBizService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
