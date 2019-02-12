/*
 *
 */
package ksid.biz.stat.user.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.stat.user.service.StatUserService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("stat/user")
public class StatUserController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(StatUserController.class);

    @Autowired
    private StatUserService statUserService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatUserController.view param [{}]", param);

        return "stat/statUser";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatUserController.list param [{}]", param);

        List<Map<String, Object>> dataList = this.statUserService.selDataList(param);

        logger.debug("StatUserController.list dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"fixServByUserList"})
    public String fixServByUserList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatUserController.fixServByUserList param [{}]", param);

        List<Map<String, Object>> dataList = this.statUserService.selDataList("selFixServByUserList", param);

        logger.debug("StatUserController.fixServByUserList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"fixServHisByUserList"})
    public String fixServHisByUserList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatUserController.fixServHisByUserList param [{}]", param);

        List<Map<String, Object>> dataList = this.statUserService.selDataList("selFixServHisByUserList", param);

        logger.debug("StatUserController.fixServHisByUserList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"pgPayByUserList"})
    public String pgPayByUserList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatUserController.pgPayByUserList param [{}]", param);

        List<Map<String, Object>> dataList = this.statUserService.selDataList("selPgPayByUserList", param);

        logger.debug("StatUserController.pgPayByUserList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"mpNoChgHisByUserList"})
    public String mpNoChgHisByUserList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatUserController.mpNoChgHisByUserList param [{}]", param);

        List<Map<String, Object>> dataList = this.statUserService.selDataList("selMpNoChgHisByUserList", param);

        logger.debug("StatUserController.mpNoChgHisByUserList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }



}
