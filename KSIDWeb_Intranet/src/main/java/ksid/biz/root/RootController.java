/*
 *
 */
package ksid.biz.root;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping(value= {"/"})
public class RootController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(RootController.class);

    @RequestMapping(value= {""})
    public String root(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("RootController.root param [{}]", param);

        return "index";
    }
}
