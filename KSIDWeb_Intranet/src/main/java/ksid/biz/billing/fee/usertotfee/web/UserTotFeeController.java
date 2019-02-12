/*
 *
 */
package ksid.biz.billing.fee.usertotfee.web;

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

import ksid.biz.billing.fee.usertotfee.service.UserTotFeeService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/fee/usertotfee")
public class UserTotFeeController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(UserTotFeeController.class);

    @Autowired
    private UserTotFeeService userTotFeeService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserTotFeeController.view param [{}]", param);

        return "billing/fee/usertotfee";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserTotFeeController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.userTotFeeService.selDataList(param);

        logger.debug("UserTotFeeController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.userTotFeeService.excelDownload(request, response, "selUserTotFeeList");
        } catch(Exception e) {

        }
    }

}
