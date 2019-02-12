/*
 *
 */
package ksid.biz.billing.work.pgtradedata.web;

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

import ksid.biz.billing.work.pgtradedata.service.PgTradeDataService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/pgtradedata")
public class PgTradeDataController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(PgTradeDataController.class);

    @Autowired
    private PgTradeDataService pgTradeDataService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgTradeDataController.view param [{}]", param);

        return "billing/work/pgtradedata";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgTradeDataController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.pgTradeDataService.selDataList(param);

        logger.debug("PgTradeDataController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.pgTradeDataService.excelDownload(request, response, "selPgTradeGtrDataList");
        } catch(Exception e) {

        }
    }


}
