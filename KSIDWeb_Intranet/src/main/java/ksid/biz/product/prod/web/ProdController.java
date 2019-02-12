/*
 *
 */
package ksid.biz.product.prod.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.product.prod.service.ProdService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("product/prod")
public class ProdController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(ProdController.class);

    @Autowired
    private ProdService prodService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ProdController.view param [{}]", param);

        return "product/prod";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserWtController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.prodService.selDataList(param);

        logger.debug("UserWtController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

}
