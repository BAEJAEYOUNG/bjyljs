/*
 *
 */
package ksid.biz.billing.work.pgfilehis.web;

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

import ksid.biz.billing.work.pgfilehis.service.PgFileGtrHisService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/pgfilehis")
public class PgFileGtrHisController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(PgFileGtrHisController.class);

    @Autowired
    private PgFileGtrHisService pgFileGtrHisService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgFileGtrHisController.view param [{}]", param);

        return "billing/work/pgfilehis";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgFileGtrHisController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.pgFileGtrHisService.selDataList(param);

        logger.debug("PgFileGtrHisController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.pgFileGtrHisService.excelDownload(request, response, "selPgFileGtrHisList");
        } catch(Exception e) {

        }
    }


}
