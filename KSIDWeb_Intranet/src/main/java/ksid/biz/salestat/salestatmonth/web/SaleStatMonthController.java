/*
 *
 */
package ksid.biz.salestat.salestatmonth.web;

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

import ksid.biz.salestat.salestatmonth.service.SaleStatMonthService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("salestat/salestatmonth")
public class SaleStatMonthController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SaleStatMonthController.class);

    @Autowired
    private SaleStatMonthService saleStatMonthService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SaleStatMonthController.view param [{}]", param);

        return "salestat/salestatmonth";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SaleStatMonthController.dayList param [{}]", param);

        List<Map<String, Object>> dataList = this.saleStatMonthService.selDataList(param);

        logger.debug("SaleStatMonthController.dayList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.saleStatMonthService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
