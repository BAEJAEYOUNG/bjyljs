/*
 *
 */
package ksid.biz.billing.work.pgsettledata.web;

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

import ksid.biz.billing.work.pgsettledata.service.PgSettleDataService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/pgsettledata")
public class PgSettleDataController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(PgSettleDataController.class);

    @Autowired
    private PgSettleDataService pgSettleDataService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgSettleDataController.view param [{}]", param);

        return "billing/work/pgsettledata";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgSettleDataController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.pgSettleDataService.selDataList(param);

        logger.debug("PgSettleDataController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.pgSettleDataService.excelDownload(request, response, "selPgSettleGtrDataList");
        } catch(Exception e) {

        }
    }


}
