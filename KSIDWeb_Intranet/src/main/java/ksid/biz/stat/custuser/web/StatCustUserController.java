/*
 *
 */
package ksid.biz.stat.custuser.web;

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

import ksid.biz.stat.custuser.service.StatCustUserService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("stat/custuser")
public class StatCustUserController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(StatCustUserController.class);

    @Autowired
    private StatCustUserService statCustUserService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustUserController.view param [{}]", param);

        return "stat/statCustUser";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustUserController.list param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustUserService.selDataList("selStatCustList", param);

        logger.debug("StatCustUserController.list dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"userByCustList"})
    public String userByCustList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatCustUserController.userByCustList param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustUserService.selDataList("selUserByCustList", param);

        logger.debug("StatCustUserController.userByCustList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }


    @RequestMapping(value= {"servHisByUserList"})
    public String fixServHisByUserList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatUserController.servHisByUserList param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustUserService.selDataList("selServHisByUserList", param);

        logger.debug("StatUserController.servHisByUserList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }

    @RequestMapping(value= {"pgHisByUserList"})
    public String pgHisByUserList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("StatUserController.pgHisByUserList param [{}]", param);

        List<Map<String, Object>> dataList = this.statCustUserService.selDataList("selPgHisByUserList", param);

        logger.debug("StatUserController.pgHisByUserList dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }


    @RequestMapping(value= {"excelCust"})
    public void excelCust(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.statCustUserService.excelDownload(request, response, "selStatCustList");
        } catch(Exception e) {

        }
    }


    @RequestMapping(value= {"excelUser"})
    public void excelUser(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.statCustUserService.excelDownload(request, response, "selUserByCustList");
        } catch(Exception e) {

        }
    }


}
