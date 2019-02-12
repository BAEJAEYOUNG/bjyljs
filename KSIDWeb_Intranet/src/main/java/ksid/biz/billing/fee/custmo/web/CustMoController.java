/*
 *
 */
package ksid.biz.billing.fee.custmo.web;

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

import ksid.biz.billing.fee.custmo.service.CustMoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/fee/custmo")
public class CustMoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(CustMoController.class);

    @Autowired
    private CustMoService custMoService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserWtController.view param [{}]", param);

        return "billing/fee/custmo";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustMoController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.custMoService.selDataList(param);

        logger.debug("UserWtController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.custMoService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}