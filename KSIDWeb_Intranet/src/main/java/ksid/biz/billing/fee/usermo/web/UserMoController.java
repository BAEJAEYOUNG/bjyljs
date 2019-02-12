/*
 *
 */
package ksid.biz.billing.fee.usermo.web;

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

import ksid.biz.billing.fee.usermo.service.UserMoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/fee/usermo")
public class UserMoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(UserMoController.class);

    @Autowired
    private UserMoService userMoService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserMoController.view param [{}]", param);

        return "billing/fee/usermo";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserMoController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.userMoService.selDataList(param);

        logger.debug("UserMoController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.userMoService.excelDownload(request, response, "selUserMoList");
        } catch(Exception e) {

        }
    }


}
