/*
 *
 */
package ksid.biz.sp.stat.salestatday.web;

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

import ksid.biz.sp.stat.salestatday.service.SvcPvdSaleStatDayService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("sp/stat/salestatday")
public class SvcPvdSaleStatDayController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SvcPvdSaleStatDayController.class);

    @Autowired
    private SvcPvdSaleStatDayService svcPvdSaleStatDayService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdSaleStatDayController.view param [{}]", param);

        return "sp/stat/salestatday";
    }

    @RequestMapping(value= {"No"})
    public String viewNoMoney(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdSaleStatDayController.viewNoMoney param [{}]", param);

        return "sp/stat/salestatdayNo";
    }

    @RequestMapping(value= {"custNo"})
    public String viewCustNoMoney(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdSaleStatDayController.viewCustNoMoney param [{}]", param);

        return "sp/stat/salestatdaycustNo";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdSaleStatDayController.dayList param [{}]", param);

        List<Map<String, Object>> dataList = this.svcPvdSaleStatDayService.selDataList("selSaleStatDayList", param);

        logger.debug("SaleStatDayController.dayList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.svcPvdSaleStatDayService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
