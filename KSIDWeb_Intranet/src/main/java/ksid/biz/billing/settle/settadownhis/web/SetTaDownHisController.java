/*
 *
 */
package ksid.biz.billing.settle.settadownhis.web;

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

import ksid.biz.billing.settle.settadownhis.service.SetTaDownHisService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/settle/settadownhis")
public class SetTaDownHisController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SetTaDownHisController.class);

    @Autowired
    private SetTaDownHisService setTaDownHisService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetTaDownHisController.view param [{}]", param);

        return "billing/settle/settadownhis";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetTaDownHisController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.setTaDownHisService.selDataList(param);

        logger.debug("SetTaDownHisController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.setTaDownHisService.excelDownload(request, response, "selSetTaDownHisList");
        } catch(Exception e) {

        }
    }


}