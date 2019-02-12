/*
 *
 */
package ksid.biz.billing.settle.setpgtradehis.web;

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

import ksid.biz.billing.settle.setpgtradehis.service.SetPgTradeHisService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/settle/setpgtradehis")
public class SetPgTradeHisController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SetPgTradeHisController.class);

    @Autowired
    private SetPgTradeHisService setPgTradeHisService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetPgTradeHisController.view param [{}]", param);

        return "billing/settle/setpgtradehis";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetPgTradeHisController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.setPgTradeHisService.selDataList(param);

        logger.debug("SetPgTradeHisController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.setPgTradeHisService.excelDownload(request, response, "selSetPgTradeHisList");
        } catch(Exception e) {

        }
    }


}