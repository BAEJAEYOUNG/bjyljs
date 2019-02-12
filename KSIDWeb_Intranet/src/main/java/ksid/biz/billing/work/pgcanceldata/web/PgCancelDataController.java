/*
 *
 */
package ksid.biz.billing.work.pgcanceldata.web;

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

import ksid.biz.billing.work.pgcanceldata.service.PgCancelDataService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/pgcanceldata")
public class PgCancelDataController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(PgCancelDataController.class);

    @Autowired
    private PgCancelDataService pgCancelDataService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgCancelDataController.view param [{}]", param);

        return "billing/work/pgcanceldata";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgCancelDataController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.pgCancelDataService.selDataList(param);

        logger.debug("PgCancelDataController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.pgCancelDataService.excelDownload(request, response, "selPgCancelGtrDataList");
        } catch(Exception e) {

        }
    }


}
