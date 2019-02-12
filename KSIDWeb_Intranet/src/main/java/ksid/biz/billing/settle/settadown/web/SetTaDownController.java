/*
 *
 */
package ksid.biz.billing.settle.settadown.web;

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

import ksid.biz.billing.settle.settadown.service.SetTaDownService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/settle/settadown")
public class SetTaDownController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SetTaDownController.class);

    @Autowired
    private SetTaDownService setTaDownService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetTaDownController.view param [{}]", param);

        return "billing/settle/settadown";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetTaDownController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.setTaDownService.selDataList(param);

        logger.debug("SetTaDownController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.setTaDownService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
