/*
 *
 */
package ksid.biz.salestat.settlepgstatday.web;

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

import ksid.biz.salestat.settlepgstatday.service.SettlePgStatDayService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("salestat/settlepgstatday")
public class SettlePgStatDayController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SettlePgStatDayController.class);

    @Autowired
    private SettlePgStatDayService settlePgStatDayService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SettlePgStatDayController.view param [{}]", param);

        return "salestat/settlepgstatday";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SettlePgStatDayController.dayList param [{}]", param);

        List<Map<String, Object>> dataList = this.settlePgStatDayService.selDataList(param);

        logger.debug("SettlePgStatDayController.dayList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.settlePgStatDayService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
