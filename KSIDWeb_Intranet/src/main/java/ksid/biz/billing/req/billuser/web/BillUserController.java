/*
 *
 */
package ksid.biz.billing.req.billuser.web;

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

import ksid.biz.billing.req.billuser.service.BillUserService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/req/billuser")
public class BillUserController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BillUserController.class);

    @Autowired
    private BillUserService billUserService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillUserController.view param [{}]", param);

        return "billing/req/billuser";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillUserController.selTaverList param [{}]", param);

        List<Map<String, Object>> resultData = this.billUserService.selDataList(param);

        logger.debug("BillUserController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"listDtl"})
    public String listDtl(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillUserController.listDtl param [{}]", param);

        List<Map<String, Object>> resultData = this.billUserService.selDataList("selBillUserDtlList", param);

        logger.debug("BillUserController.listDtl resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billUserService.excelDownload(request, response, "selBillUserList");
        } catch(Exception e) {

        }
    }


    @RequestMapping(value= {"excel2"})
    public void excel2(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billUserService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
