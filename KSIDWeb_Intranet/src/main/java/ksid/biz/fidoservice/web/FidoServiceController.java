package ksid.biz.fidoservice.web;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.user.service.UserService;
import ksid.core.webmvc.base.web.BaseController;

@Controller
public class FidoServiceController extends BaseController {
    protected static final Logger logger = LoggerFactory.getLogger(FidoServiceController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value= {"fidoservice/webpushreg"})
    public String viewPhonePush(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view webpushreg param [{}]", param);

        return "fidoservice/webpushreg";
    }


    @RequestMapping(value= {"fidoservice/webpushchg"})
    public String viewPhonePushChange(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view webpushchg param [{}]", param);

        return "fidoservice/webpushchg";
    }


    @RequestMapping(value= {"fidoservice/webfidoreg"})
    public String viewWebFidoReg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view webfidoreg param [{}]", param);

        return "fidoservice/webfidoreg";
    }


    @RequestMapping(value= {"fidoservice/webfidodereg"})
    public String viewWebFidodereg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view webfidodereg param [{}]", param);

        return "fidoservice/webfidodereg";
    }


    @RequestMapping(value= {"fidoservice/webfidoauth"})
    public String viewWebFidoAuth(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view webfidoauth param [{}]", param);

        return "fidoservice/webfidoauth";
    }

    @RequestMapping(value= {"ksid/fidoservice/webpushreg"})
    public String ksidviewPhonePush(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ksid webpushreg param [{}]", param);

        return "ksid/fidoservice/webpushreg";
    }


    @RequestMapping(value= {"ksid/fidoservice/webpushchg"})
    public String ksidviewPhonePushChange(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ksid webpushchg param [{}]", param);

        return "ksid/fidoservice/webpushchg";
    }


    @RequestMapping(value= {"ksid/fidoservice/webfidoreg"})
    public String ksidviewWebFidoReg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ksid webfidoreg param [{}]", param);

        return "ksid/fidoservice/webfidoreg";
    }


    @RequestMapping(value= {"ksid/fidoservice/webfidodereg"})
    public String ksidviewWebFidodereg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ksid webfidodereg param [{}]", param);

        return "ksid/fidoservice/webfidodereg";
    }

    @RequestMapping(value= {"sdu/fidoservice/webpushreg"})
    public String sduviewPhonePush(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view sdu webpushreg param [{}]", param);

        return "fidoapi/sdu/fidoservice/webpushreg";
    }


    @RequestMapping(value= {"sdu/fidoservice/webpushchg"})
    public String sduviewPhonePushChange(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view sdu webpushchg param [{}]", param);

        return "fidoapi/sdu/fidoservice/webpushchg";
    }


    @RequestMapping(value= {"sdu/fidoservice/webfidoreg"})
    public String sduviewWebFidoReg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view sdu webfidoreg param [{}]", param);

        return "fidoapi/sdu/fidoservice/webfidoreg";
    }


    @RequestMapping(value= {"sdu/fidoservice/webfidodereg"})
    public String sduviewWebFidodereg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view sdu webfidodereg param [{}]", param);

        return "fidoapi/sdu/fidoservice/webfidodereg";
    }

    @RequestMapping(value= {"ocucons/fidoservice/webpushreg"})
    public String ocuconsviewPhonePush(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ocucons webpushreg param [{}]", param);

        return "fidoapi/ocucons/fidoservice/webpushreg";
    }


    @RequestMapping(value= {"ocucons/fidoservice/webpushchg"})
    public String ocuconsviewPhonePushChange(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ocucons webpushchg param [{}]", param);

        return "fidoapi/ocucons/fidoservice/webpushchg";
    }


    @RequestMapping(value= {"ocucons/fidoservice/webfidoreg"})
    public String ocuconsviewWebFidoReg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ocucons webfidoreg param [{}]", param);

        return "fidoapi/ocucons/fidoservice/webfidoreg";
    }


    @RequestMapping(value= {"ocucons/fidoservice/webfidodereg"})
    public String ocuconsviewWebFidodereg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ocucons webfidodereg param [{}]", param);

        return "fidoapi/ocucons/fidoservice/webfidodereg";
    }

    @RequestMapping(value= {"ocucons/fidoservice/mobileKeySample"})
    public String ocuconsMobileKeySample(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ocucons mobileKeySample param [{}]", param);

        return "fidoapi/ocucons/fidoservice/mobileKeySample";
    }
    @RequestMapping(value= {"sdu/fidoservice/mobileKeySample"})
    public String sduMobileKeySample(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FidoServiceController.view ocucons mobileKeySample param [{}]", param);

        return "fidoapi/sdu/fidoservice/mobileKeySample";
    }
}
