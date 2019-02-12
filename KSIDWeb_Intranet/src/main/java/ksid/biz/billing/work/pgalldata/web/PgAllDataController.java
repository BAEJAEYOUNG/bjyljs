/*
 *
 */
package ksid.biz.billing.work.pgalldata.web;

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

import ksid.biz.billing.work.pgalldata.service.PgAllDataService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/pgalldata")
public class PgAllDataController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(PgAllDataController.class);

    @Autowired
    private PgAllDataService pgAllDataService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgAllDataController.view param [{}]", param);

        return "billing/work/pgalldata";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgAllDataController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.pgAllDataService.selDataList(param);

        logger.debug("PgAllDataController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.pgAllDataService.excelDownload(request, response, "selPgAllGtrDataList");
        } catch(Exception e) {

        }
    }


}
