/*
 *
 */
package ksid.biz.sp.stat.statservregday.web;

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

import ksid.biz.sp.stat.statservregday.service.SvcPvdStatServRegDayService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("sp/stat/statservregday")
public class SvcPvdStatServRegDayController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SvcPvdStatServRegDayController.class);

    @Autowired
    private SvcPvdStatServRegDayService svcPvdStatServRegDayService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdStatServRegDayController.view param [{}]", param);

        return "sp/stat/statservregday";
    }

    @RequestMapping(value= {"cust"})
    public String viewCust(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdStatServRegDayController.viewCust param [{}]", param);

        return "sp/stat/statservregdaycust";
    }

    @RequestMapping(value= {"list"})
    public String dayList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SvcPvdStatServRegDayController.list param [{}]", param);

        List<Map<String, Object>> dataList = this.svcPvdStatServRegDayService.selDataList("selStatServRegDayList", param);

        logger.debug("SvcPvdStatServRegDayController.list dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.svcPvdStatServRegDayService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
