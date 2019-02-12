/*
 *
 */
package ksid.biz.salestat.salestatquarter.web;

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

import ksid.biz.salestat.salestatquarter.service.SaleStatQuarterService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("salestat/salestatquarter")
public class SaleStatQuarterController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SaleStatQuarterController.class);

    @Autowired
    private SaleStatQuarterService saleStatQuarterService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SaleStatQuarterController.view param [{}]", param);

        return "salestat/salestatquarter";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SaleStatQuarterController.dayList param [{}]", param);

        List<Map<String, Object>> dataList = this.saleStatQuarterService.selDataList(param);

        logger.debug("SaleStatQuarterController.dayList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {

        logger.debug("SaleStatQuarterController.excel.....");

        try {
            logger.debug("SaleStatQuarterController.excel start.....");

            this.saleStatQuarterService.excelDownloadGrid(request, response);

            logger.debug("SaleStatQuarterController.excel end.....");
        } catch(Exception e) {
            logger.error("SaleStatQuarterController.excel [{}]", e);
            e.printStackTrace();
        }
    }

}
