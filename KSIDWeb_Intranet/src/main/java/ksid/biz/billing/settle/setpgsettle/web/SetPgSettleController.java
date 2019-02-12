/*
 *
 */
package ksid.biz.billing.settle.setpgsettle.web;

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

import ksid.biz.billing.settle.setpgsettle.service.SetPgSettleService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/settle/setpgsettle")
public class SetPgSettleController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SetPgSettleController.class);

    @Autowired
    private SetPgSettleService setPgSettleService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetPgSettleController.view param [{}]", param);

        return "billing/settle/setpgsettle";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SetPgSettleController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.setPgSettleService.selDataList(param);

        logger.debug("SetPgSettleController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

     @RequestMapping(value= {"excel"})
     public void excel(HttpServletRequest request, HttpServletResponse response) {
         try {
             this.setPgSettleService.excelDownloadGrid(request, response);
         } catch(Exception e) {

         }
      }

}
