/*
 *
 */
package ksid.biz.billing.bill.mstudr.web;

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

import ksid.biz.billing.bill.mstudr.service.MstUdrService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/bill/mstudr")
public class MstUdrController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(MstUdrController.class);

    @Autowired
    private MstUdrService mstUdrService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MstUdrController.view param [{}]", param);

        return "billing/bill/mstudr";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MstUdrController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.mstUdrService.selDataList(param);

        logger.debug("MstUdrController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.mstUdrService.excelDownload(request, response, "selMstUdrList");
        } catch(Exception e) {

        }
    }

}
