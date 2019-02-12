/*
 *
 */
package ksid.biz.sp.stat.pgalldata.web;

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

import ksid.biz.sp.stat.pgalldata.service.SvcPvdPgAllDataService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("sp/stat/pgalldata")
public class SvcPvdPgAllDataController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SvcPvdPgAllDataController.class);

    @Autowired
    private SvcPvdPgAllDataService svcPvdPgAllDataService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdPgAllDataController.view param [{}]", param);

        return "sp/stat/pgalldata";
    }

    @RequestMapping(value= {"cust"})
    public String viewCust(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdPgAllDataController.viewCust param [{}]", param);

        return "sp/stat/pgalldatacust";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdPgAllDataController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.svcPvdPgAllDataService.selDataList("selPgAllGtrDataList", param );

        logger.debug("SvcPvdPgAllDataController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.svcPvdPgAllDataService.excelDownload(request, response, "selPgAllGtrDataList");
        } catch(Exception e) {

        }
    }


}
