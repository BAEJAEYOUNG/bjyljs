/*
 *
 */
package ksid.biz.salestat.salestatday.web;

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

import ksid.biz.salestat.salestatday.service.SaleStatDayService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("salestat/salestatday")
public class SaleStatDayController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SaleStatDayController.class);

    @Autowired
    private SaleStatDayService saleStatDayService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SaleStatDayController.view param [{}]", param);

        return "salestat/salestatday";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SaleStatDayController.dayList param [{}]", param);

        List<Map<String, Object>> dataList = this.saleStatDayService.selDataList(param);

        logger.debug("SaleStatDayController.dayList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.saleStatDayService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
