/*
 *
 */
package ksid.biz.admin.system.menu.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.admin.system.menu.service.MenuService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("admin/system/menu")
public class MenuController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(MenuController.class);

    @Autowired
    private MenuService menuService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MenuController.view param [{}]", param);

        return "admin/system/menu";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MenuController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.menuService.selDataList(param);

        logger.debug("MenuController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sel"})
    public String sel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MenuController.sel param [{}]", param);

        Map<String, Object> resultData = this.menuService.selData(param);

        logger.debug("MenuController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MenuController.ins param [{}]", param);

        int resultData = this.menuService.insData(param);

        logger.debug("MenuController.ins resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MenuController.upd param [{}]", param);

        int resultData = this.menuService.updData(param);

        logger.debug("MenuController.upd resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("MenuController.del param {}", param);

        int resultData = this.menuService.delData(param);

        logger.debug("MenuController.del resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "delete success !");

        return "json";
    }
}
