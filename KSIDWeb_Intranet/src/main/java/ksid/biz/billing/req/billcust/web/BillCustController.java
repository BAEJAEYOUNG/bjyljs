/*
 *
 */
package ksid.biz.billing.req.billcust.web;

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

import ksid.biz.billing.req.billcust.service.BillCustService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/req/billcust")
public class BillCustController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BillCustController.class);

    @Autowired
    private BillCustService billCustService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCustController.view param [{}]", param);

        return "billing/req/billcust";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCustController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.billCustService.selDataList(param);

        logger.debug("BillCustController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"listDtl"})
    public String listDtl(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCustController.listDtl param [{}]", param);

        List<Map<String, Object>> resultData = this.billCustService.selDataList("selBillCustDtlList", param);

        logger.debug("BillCustController.listDtl resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billCustService.excelDownload(request, response, "selBillCustList");
        } catch(Exception e) {

        }
    }

    @RequestMapping(value= {"excel2"})
    public void excel2(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billCustService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }
}
