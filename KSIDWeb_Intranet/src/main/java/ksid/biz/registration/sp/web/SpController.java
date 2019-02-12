/*
 *
 */
package ksid.biz.registration.sp.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.sp.service.SpService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/sp")
public class SpController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SpController.class);

    @Autowired
    private SpService spService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpController.view param [{}]", param);

        return "registration/sp";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.spService.selDataList(param);

        logger.debug("SpController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sel"})
    public String sel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpController.sel param [{}]", param);

        Map<String, Object> resultData = this.spService.selData(param);

        logger.debug("SpController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpController.ins param [{}]", param);

        int cntIns = this.spService.insData(param);

        logger.debug("SpController.ins cntIns {}", cntIns);
        if(cntIns == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "insert success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "insert failure !");
        }

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpController.upd param [{}]", param);

        int cntUpd = this.spService.updData(param);

        logger.debug("SpController.upd cntUpd {}", cntUpd);
        if(cntUpd == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "update success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "update failure !");
        }

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SpController.del param {}", param);

        int cntDel = this.spService.delData(param);

        logger.debug("SpController.del cntUpd {}", cntDel);
        if(cntDel == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "delete success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "delete failure !");
        }
        return "json";
    }
}
