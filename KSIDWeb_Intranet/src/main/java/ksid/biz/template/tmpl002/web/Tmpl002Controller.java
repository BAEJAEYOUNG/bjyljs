/*
 *
 */
package ksid.biz.template.tmpl002.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.template.tmpl002.service.Tmpl002Service;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("template/tmpl002")
public class Tmpl002Controller extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(Tmpl002Controller.class);

    @Autowired
    private Tmpl002Service tmpl002Service;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("Tmpl002Controller.view param [{}]", param);

        return "template/tmpl002";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("Tmpl002Controller.list param [{}]", param);

        List<Map<String, Object>> dataList = this.tmpl002Service.selDataList(param);

        logger.debug("Tmpl002Controller.list dataList [{}]", dataList);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", dataList);

        return "json";
    }
}
