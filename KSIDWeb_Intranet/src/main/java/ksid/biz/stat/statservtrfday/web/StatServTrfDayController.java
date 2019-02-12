/*
 *
 */
package ksid.biz.stat.statservtrfday.web;

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

import ksid.biz.stat.statservtrfday.service.StatServTrfDayService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("stat/statservtrfday")
public class StatServTrfDayController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(StatServTrfDayController.class);

    @Autowired
    private StatServTrfDayService statServTrfDayService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatServTrfDayController.view param [{}]", param);

        return "stat/statservtrfday";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatServTrfDayController.list param [{}]", param);

        List<Map<String, Object>> dataList = this.statServTrfDayService.selDataList(param);

        logger.debug("StatServTrfDayController.list dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.statServTrfDayService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
