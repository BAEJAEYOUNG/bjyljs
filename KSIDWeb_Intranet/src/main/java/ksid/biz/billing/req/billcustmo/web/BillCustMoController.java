/*
 *
 */
package ksid.biz.billing.req.billcustmo.web;

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

import ksid.biz.billing.req.billcustmo.service.BillCustMoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/req/billcustmo")
public class BillCustMoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BillCustMoController.class);

    @Autowired
    private BillCustMoService billCustMoService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCustMoController.view param [{}]", param);

        return "billing/req/billcustmo";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillCustMoController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.billCustMoService.selDataList(param);

        logger.debug("BillCustMoController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billCustMoService.excelDownload(request, response, "selBillCustMoList");
        } catch(Exception e) {

        }
    }


    @RequestMapping(value= {"excel2"})
    public void excel2(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billCustMoService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
