/*
 *
 */
package ksid.biz.stat.statservregday.web;

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

import ksid.biz.stat.statservregday.service.StatServRegDayService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("stat/statservregday")
public class StatServRegDayController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(StatServRegDayController.class);

    @Autowired
    private StatServRegDayService statServRegDayService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatServRegDayController.view param [{}]", param);

        return "stat/statservregday";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatServRegDayController.list param [{}]", param);

        List<Map<String, Object>> dataList = this.statServRegDayService.selDataList(param);

        logger.debug("StatServRegDayController.list dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.statServRegDayService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
