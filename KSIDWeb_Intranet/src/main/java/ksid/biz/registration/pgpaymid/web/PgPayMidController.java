/*
 *
 */
package ksid.biz.registration.pgpaymid.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.pgpaymid.service.PgPayMidService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/pgpaymid")
public class PgPayMidController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(PgPayMidController.class);

    @Autowired
    private PgPayMidService pgPayMidService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgPayMidController.view param [{}]", param);

        return "registration/pgpaymid";
    }

    @RequestMapping(value= {"selPgPayMidList"})
    public String selPgPayMidList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgPayMidController.selPgPayMidList param [{}]", param);

        List<Map<String, Object>> resultData = this.pgPayMidService.selDataList("selPgPayMidList", param);

        logger.debug("PgPayMidController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selPgPayMid"})
    public String selPgPayMid(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgPayMidController.selPgPayMid param {}", param);

        Map<String, Object> resultData = this.pgPayMidService.selData("selPgPayMid", param);

        logger.debug("PgPayMidController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insPgPayMid"})
    public String insPgPayMid(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgPayMidController.insPgPayMid param [{}]", param);

        int cntIns = this.pgPayMidService.insData("insPgPayMid", param);

        logger.debug("PgPayMidController.cntIns : {}", cntIns);
        if(cntIns == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "insert success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "insert failure !");
        }

        return "json";
    }

    @RequestMapping(value= {"updPgPayMid"})
    public String updPgPayMid(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgPayMidController.updPgPayMid param [{}]", param);

        int cntUpd = this.pgPayMidService.updData("updPgPayMid", param);

        logger.debug("PgPayMidController.cntUpd : {}", cntUpd);
        if(cntUpd == 1) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "update success !");
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "update failure !");
        }

        return "json";
    }

    @RequestMapping(value= {"delPgPayMid"})
    public String delPgPayMid(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgPayMidController.delPgPayMid param [{}]", param);

        int cntDel = this.pgPayMidService.delData("delPgPayMid", param);

        logger.debug("PgPayMidController.cntDel : {}", cntDel);

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
