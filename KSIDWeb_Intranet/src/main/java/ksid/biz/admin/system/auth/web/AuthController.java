/*
 *
 */
package ksid.biz.admin.system.auth.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.admin.system.auth.service.AuthService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("admin/system/auth")
public class AuthController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private AuthService authService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.view param [{}]", param);

        return "admin/system/auth";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.authService.selDataList(param);

        logger.debug("AuthController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sel"})
    public String sel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.sel param [{}]", param);

        Map<String, Object> resultData = this.authService.selData(param);

        logger.debug("AuthController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.ins param [{}]", param);

        int resultData = this.authService.insData(param);

        logger.debug("AuthController.ins resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.upd param [{}]", param);

        int resultData = this.authService.updData(param);

        logger.debug("AuthController.upd resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.del param {}", param);

        int resultData = this.authService.delData(param);

        logger.debug("AuthController.del resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"selAdminList"})
    public String selAdminList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.selAdminList param [{}]", param);

        List<Map<String, Object>> resultData = this.authService.selDataList("selAdminList", param);

        logger.debug("AuthController.selAdminList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selPopupAdminList"})
    public String selPopupAdminList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.selPopupAdminList param [{}]", param);

        List<Map<String, Object>> resultData = this.authService.selDataList("selPopupAdminList", param);

        logger.debug("AuthController.selPopupAdminList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insAdminList"})
    public String insAdminList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("AuthController.insAdminList param [{}]", param);

        int resultData = this.authService.insDataList("insAdminList", param);

        logger.debug("AuthController.insAdminList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"delAdminList"})
    public String delAdminList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("AuthController.delAdminList param {}", param);

        int resultData = this.authService.delDataList("delAdminList", param);

        logger.debug("AuthController.delAdminList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"selMenuList"})
    public String selMenuList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.selMenuList param [{}]", param);

        List<Map<String, Object>> resultData = this.authService.selDataList("selMenuList", param);

        logger.debug("AuthController.selMenuList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selPopupMenuList"})
    public String selPopupMenuList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("AuthController.selPopupMenuList param [{}]", param);

        List<Map<String, Object>> resultData = this.authService.selDataList("selPopupMenuList", param);

        logger.debug("AuthController.selPopupMenuList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"insMenuList"})
    public String insMenuList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("AuthController.insMenuList param [{}]", param);

        int resultData = this.authService.insDataList("insMenuList", param);

        logger.debug("AuthController.insMenuList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"updMenuList"})
    public String updMenuList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("AuthController.updMenuList param [{}]", param);

        int resultData = this.authService.updDataList("updMenuList", param);

        logger.debug("AuthController.updMenuList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"delMenuList"})
    public String delMenuList(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("AuthController.delMenuList param {}", param);

        int resultData = this.authService.delDataList("delMenuList", param);

        logger.debug("AuthController.delMenuList resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }

    @RequestMapping(value= {"excel3"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.authService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}
