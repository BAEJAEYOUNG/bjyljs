/*
 *
 */
package ksid.biz.registration.pg.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.pg.service.PgService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/pg")
public class PgController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(PgController.class);

    @Autowired
    private PgService pgService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgController.view param [{}]", param);

        return "registration/pg";
    }

    @RequestMapping(value= {"selPgList"})
    public String selPgList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgController.selPgList param [{}]", param);

        List<Map<String, Object>> resultData = this.pgService.selDataList("selPgList", param);

        logger.debug("PgController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selPgCd"})
    public String selPgCd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgController.selPgCd param {}", param);

        Map<String, Object> resultData = this.pgService.selData("selPgCd", param);

        logger.debug("PgController.list resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insPg"})
    public String insPg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgController.insPg param [{}]", param);

        int cntIns = this.pgService.insData("insPg", param);

        logger.debug("PgController.cntIns : {}", cntIns);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"updPg"})
    public String updPg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgController.updPg param [{}]", param);

        int cntUpd = this.pgService.updData("updPg", param);

        logger.debug("PgController.cntUpd : {}", cntUpd);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"delPg"})
    public String delPg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("PgController.delPg param [{}]", param);

        int cntDel = this.pgService.delData("delPg", param);

        logger.debug("PgController.cntDel : {}", cntDel);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

}
