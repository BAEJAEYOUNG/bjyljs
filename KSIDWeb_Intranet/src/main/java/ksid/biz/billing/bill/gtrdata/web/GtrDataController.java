/*
 *
 */
package ksid.biz.billing.bill.gtrdata.web;

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

import ksid.biz.billing.bill.gtrdata.service.GtrDataService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/bill/gtrdata")
public class GtrDataController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(GtrDataController.class);

    @Autowired
    private GtrDataService gtrDataService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("GtrDataController.view param [{}]", param);

        return "billing/bill/gtrdata";
    }

    @RequestMapping(value= {"sp"})
    public String viewSp(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("GtrDataController.viewSp param [{}]", param);

        return "sp/stat/gtrdata";
    }

    @RequestMapping(value= {"cust"})
    public String viewCust(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("GtrDataController.viewCust param [{}]", param);

        return "sp/stat/gtrdatacust";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("GtrDataController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.gtrDataService.selDataList(param);

        logger.debug("GtrDataController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        logger.debug("GtrDataController.excel request [{}]", request);

        try {
            this.gtrDataService.excelDownload(request, response, "selGtrDataList");
        } catch(Exception e) {

        }
    }

}
