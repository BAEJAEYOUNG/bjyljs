/*
 *
 */
package ksid.biz.billing.settle.setpgsettlehis.web;

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

import ksid.biz.billing.settle.setpgsettlehis.service.SetPgSettleHisService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/settle/setpgsettlehis")
public class SetPgSettleHisController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SetPgSettleHisController.class);

    @Autowired
    private SetPgSettleHisService setPgSettleHisService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetPgSettleHisController.view param [{}]", param);

        return "billing/settle/setpgsettlehis";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetPgSettleHisController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.setPgSettleHisService.selDataList(param);

        logger.debug("SetPgSettleHisController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.setPgSettleHisService.excelDownload(request, response, "selSetPgSettleHisList");
        } catch(Exception e) {

        }
    }


}