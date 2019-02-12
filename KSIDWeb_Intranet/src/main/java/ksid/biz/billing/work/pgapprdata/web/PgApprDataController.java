/*
 *
 */
package ksid.biz.billing.work.pgapprdata.web;

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

import ksid.biz.billing.work.pgapprdata.service.PgApprDataService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/pgapprdata")
public class PgApprDataController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(PgApprDataController.class);

    @Autowired
    private PgApprDataService pgApprDataService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgApprDataController.view param [{}]", param);

        return "billing/work/pgapprdata";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgApprDataController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.pgApprDataService.selDataList(param);

        logger.debug("PgApprDataController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.pgApprDataService.excelDownload(request, response, "selPgApprGtrDataList");
        } catch(Exception e) {

        }
    }


}
