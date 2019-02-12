/*
 *
 */
package ksid.biz.product.custproduserbill.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.product.custproduserbill.service.CustProdUserBillService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("product/custproduserbill")
public class CustProdUserBillController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(CustProdUserBillController.class);

    @Autowired
    private CustProdUserBillService custProdUserBillService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ProdController.view param [{}]", param);

        return "product/custproduserbill";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustProdUserBillController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.custProdUserBillService.selDataList(param);

        logger.debug("CustProdUserBillController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

}
