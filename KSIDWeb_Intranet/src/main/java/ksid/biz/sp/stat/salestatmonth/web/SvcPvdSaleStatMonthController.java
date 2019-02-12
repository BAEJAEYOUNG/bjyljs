/*
 *
 */
package ksid.biz.sp.stat.salestatmonth.web;

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

import ksid.biz.sp.stat.salestatmonth.service.SvcPvdSaleStatMonthService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("sp/stat/salestatmonth")
public class SvcPvdSaleStatMonthController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SvcPvdSaleStatMonthController.class);

    @Autowired
    private SvcPvdSaleStatMonthService svcPvdSaleStatMonthService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdSaleStatMonthController.view param [{}]", param);

        return "sp/stat/salestatmonth";
    }

    @RequestMapping(value= {"No"})
    public String viewNoMoney(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdSaleStatMonthController.viewNoMoney param [{}]", param);

        return "sp/stat/salestatmonthNo";
    }

    @RequestMapping(value= {"custNo"})
    public String viewCustNoMoney(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdSaleStatMonthController.viewCustNoMoney param [{}]", param);

        return "sp/stat/salestatmonthcustNo";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdSaleStatMonthController.dayList param [{}]", param);

        List<Map<String, Object>> dataList = this.svcPvdSaleStatMonthService.selDataList("selSaleStatMonthList", param);

        logger.debug("SaleStatMonthController.dayList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.svcPvdSaleStatMonthService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
