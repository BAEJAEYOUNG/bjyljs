package ksid.biz.ocuuser.userpayfinal.web;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.ocuuser.userpayfinal.service.UserPayFinalService;
import ksid.biz.ocuuser.userpayfinal.service.impl.UserPayFinalDao;
import ksid.core.webmvc.base.web.BaseController;

@Controller
//@RequestMapping("ocuuser")
public class UserPayFinalController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(UserPayFinalController.class);

    @Autowired
    private UserPayFinalService userPayFinalService;

    @Autowired
    private UserPayFinalDao userPayFinalDao;


    @RequestMapping(value= {"ocuuser/userPayFinal"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayFinalController.view ocu param [{}]", param);
        Map<String, Object> resultParam = new HashMap<String, Object>();

        resultParam = userPayFinalDao.selectCustUserNoAndUserId(param);
        resultParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
        resultParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        resultParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );

        model.addAttribute("resultData", resultParam);

        return "ocuuser/userPayFinal";
    }

    @RequestMapping(value= {"ksid/userPayFinal"})
    public String ksidview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayFinalController.ksidview ksid param [{}]", param);
        Map<String, Object> resultParam = new HashMap<String, Object>();

        resultParam = userPayFinalDao.selectCustUserNoAndUserId(param);
        resultParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
        resultParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        resultParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );

        model.addAttribute("resultData", resultParam);

        return "ksid/userPayFinal";
    }

    @RequestMapping(value= {"sdu/userPayFinal"})
    public String sduview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayFinalController.sduview sdu param [{}]", param);
        Map<String, Object> resultParam = new HashMap<String, Object>();

        resultParam = userPayFinalDao.selectCustUserNoAndUserId(param);
        resultParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
        resultParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        resultParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );

        model.addAttribute("resultData", resultParam);

        return "fidoapi/sdu/userPayFinal";
    }

    @RequestMapping(value= {"ocucons/userPayFinal"})
    public String ocuconsview(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserPayFinalController.ocuconsview param [{}]", param);
        Map<String, Object> resultParam = new HashMap<String, Object>();

        resultParam = userPayFinalDao.selectCustUserNoAndUserId(param);
        resultParam.put( "spCd", StringUtils.defaultString((String)param.get("spCd")) );
        resultParam.put( "custId", StringUtils.defaultString((String)param.get("custId")) );
        resultParam.put( "servId", StringUtils.defaultString((String)param.get("servId")) );

        model.addAttribute("resultData", resultParam);

        return "fidoapi/ocucons/userPayFinal";
    }

}
