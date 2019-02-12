/*
 *
 */
package ksid.biz.registration.taver.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.taver.service.TaverService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/taver")
public class TaverController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(TaverController.class);

    @Autowired
    private TaverService taverService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaverController.view param [{}]", param);

        return "registration/taver";
    }

    @RequestMapping(value= {"selTaverList"})
    public String selTaverList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaverController.selTaverList param [{}]", param);

        List<Map<String, Object>> resultData = this.taverService.selDataList("selTaverList", param);

        logger.debug("TaverController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selTaver"})
    public String selTaver(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaverController.selTaver param {}", param);

        Map<String, Object> resultData = this.taverService.selData("selTaver", param);

        logger.debug("TaverController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insTaver"})
    public String insTaver(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaverController.insTaver param [{}]", param);

        int cntIns = this.taverService.insData("insTaver", param);

        logger.debug("TaverController.cntIns : {}", cntIns);
        if(cntIns == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "insert success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "insert failure !");
        }

        return "json";
    }

    @RequestMapping(value= {"updTaver"})
    public String updTaver(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaverController.updTaver param [{}]", param);

        int cntUpd = this.taverService.updData("updTaver", param);

        logger.debug("TaverController.cntUpd : {}", cntUpd);
        if(cntUpd == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "update success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "update failure !");
        }
        return "json";
    }

    @RequestMapping(value= {"delTaver"})
    public String delTaver(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("TaverController.delTaver param [{}]", param);

        int cntDel = this.taverService.delData("delTaver", param);

        logger.debug("TaverController.cntDel : {}", cntDel);
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
