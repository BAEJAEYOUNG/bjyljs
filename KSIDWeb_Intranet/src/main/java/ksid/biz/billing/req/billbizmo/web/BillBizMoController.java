/*
 *
 */
package ksid.biz.billing.req.billbizmo.web;

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

import ksid.biz.billing.req.billbizmo.service.BillBizMoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/req/billbizmo")
public class BillBizMoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BillBizMoController.class);

    @Autowired
    private BillBizMoService billBizMoService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillBizMoController.view param [{}]", param);

        return "billing/req/billbizmo";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillBizMoController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.billBizMoService.selDataList(param);

        logger.debug("BillBizMoController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billBizMoService.excelDownload(request, response, "selBillBizMoList");
        } catch(Exception e) {

        }
    }


    @RequestMapping(value= {"excel2"})
    public void excel2(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billBizMoService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }


}
