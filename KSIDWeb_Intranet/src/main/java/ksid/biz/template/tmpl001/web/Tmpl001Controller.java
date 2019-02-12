/*
 *
 */
package ksid.biz.template.tmpl001.web;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.template.tmpl001.service.Tmpl001Service;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("template/tmpl001")
public class Tmpl001Controller extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(Tmpl001Controller.class);

    @Autowired
    private Tmpl001Service tmpl001Service;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("Tmpl001Controller.view param [{}]", param);

        return "template/tmpl001";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("Tmpl001Controller.list param [{}]", param);

        model.addAttribute("dataList", this.tmpl001Service.selData("selTmpl001TempList", param));

        return "json";
    }

    @RequestMapping(value= {"post"}, method = RequestMethod.POST)
    public String post(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("Tmpl001Controller.list param [{}]", param);

        model.addAttribute("dataList", this.tmpl001Service.selData("selTmpl001TempList", param));

        return "json";
    }
}
