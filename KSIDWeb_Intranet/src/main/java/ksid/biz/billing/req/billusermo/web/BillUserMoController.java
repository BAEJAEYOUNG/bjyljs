/*
 *
 */
package ksid.biz.billing.req.billusermo.web;

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

import ksid.biz.billing.req.billusermo.service.BillUserMoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/req/billusermo")
public class BillUserMoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BillUserMoController.class);

    @Autowired
    private BillUserMoService billUserMoService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillUserMoController.view param [{}]", param);

        return "billing/req/billusermo";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillUserMoController.selTaverList param [{}]", param);

        List<Map<String, Object>> resultData = this.billUserMoService.selDataList(param);

        logger.debug("BillUserMoController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billUserMoService.excelDownload(request, response, "selBillUserMoList");
        } catch(Exception e) {

        }
    }

    @RequestMapping(value= {"excel2"})
    public void excel2(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.billUserMoService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
