/*
 *
 */
package ksid.biz.registration.chgmpno.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.registration.chgmpno.service.ChgMpNoService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/chgmpno")
public class ChgMpNoController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(ChgMpNoController.class);

    @Autowired
    private ChgMpNoService chgMpNoService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ChgMpNoController.view param [{}]", param);

        return "registration/chgmpno";
    }

    @RequestMapping(value= {"selChgMpNoHisList"})
    public String selChgMpNoHisList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ChgMpNoController.selChgMpNoHisList param [{}]", param);

        List<Map<String, Object>> resultData = this.chgMpNoService.selDataList("selChgMpNoHisList", param);

        logger.debug("ChgMpNoController.selChgMpNoHisList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"selUserTelnoList"})
    public String selUserTelnoList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ChgMpNoController.selUserTelnoList param [{}]", param);

        List<Map<String, Object>> resultData = this.chgMpNoService.selDataList("selUserTelnoList", param);

        logger.debug("ChgMpNoController.selUserTelnoList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"chgMpNoReq"})
    public String chgMpNoReq(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("ChgMpNoController.chgMpNoReq param [{}]", param);

        String oldMpNo = StringUtils.defaultString((String)param.get("oldMpNo"));
        String newMpNo = StringUtils.defaultString((String)param.get("newMpNo"));
        if(oldMpNo.length() < 10) {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "change fail mpno failure[변경전 핸드폰번호]!");
        }
        if(newMpNo.length() < 10) {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "change mpno failure![변경후 핸드폰번호]");
        }

        String strResult = this.chgMpNoService.callProc("chgMpNoReq", param);

        logger.debug("UserController.chgMpNoReq chgMpNoReq strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "change mpno success !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }
        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.chgMpNoService.excelDownload(request, response, "selChgMpNoHisList");
        } catch(Exception e) {

        }
    }

}
