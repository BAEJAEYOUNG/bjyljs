/*
 *
 */
package ksid.biz.billing.comm.web;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.billing.comm.service.BillingCommService;
import ksid.core.webmvc.base.web.BaseController;
import ksid.core.webmvc.util.OsUtilLib;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/comm")
public class BillingCommController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BillingCommController.class);

    @Autowired
    private BillingCommService billingCommService;

    @RequestMapping(value= {"comboList"})
    public String comboList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillingCommController.comboList param [{}]", param);

        List<Map<String, Object>> resultData = this.billingCommService.selDataList("selComboList", param);

        logger.debug("BillingCommController.comboList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"servIdList"})
    public String servIdList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillingCommController.servIdList param [{}]", param);

        List<Map<String, Object>> resultData = this.billingCommService.selDataList("selServIdList", param);

        logger.debug("BillingCommController.servIdList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"prodChoiceCdList"})
    public String prodChoiceCdList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillingCommController.prodChoiceCdList param [{}]", param);

        List<Map<String, Object>> resultData = this.billingCommService.selDataList("selProdChoicdCdList", param);

        logger.debug("BillingCommController.prodChoiceCdList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"getSysUrl"})
    public String getSysUrl(@RequestParam Map<String, Object> param, Model model) {

        param.put("codeGroupCd", "SYS_URL");
        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                param.put("codeCd", "PC");
                break;
            case LINUX:
            default :
                param.put("codeCd", "SERVER");
                logger.info("=====> getOS LINUX");
                break;
        }

        List<Map<String, Object>> resultData = this.billingCommService.selDataList("getSysUrl", param);
        logger.debug("BillingCommController.getSysUrl resultData [{}]", resultData);

        if ( resultData != null ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }

        return "json";
    }


    @RequestMapping(value= {"fileDirList"})
    public String fileDirList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillingCommController.fileDirList param [{}]", param);

        param.put("codeGroupCd", "BATCH_DIR");

        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                param.put("codeCd", "PC");
                break;
            case LINUX:
            default :
                param.put("codeCd", "SERVER");
                logger.info("=====> getOS LINUX");
                break;
        }

        List<Map<String, Object>> resultData = this.billingCommService.selDataList("fileDirList", param);

        logger.debug("BillingCommController.fileDirList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"fileList"})
    public String fileList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillingCommController.fileList param [{}]", param);

        String fileDir = StringUtils.defaultString((String)param.get("fileDir"));
        fileDir = fileDir.trim().replace('：', ':');

        File directory = new File(fileDir);
        File[] fList = directory.listFiles();

        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();

        int count=0;
        try {
            for (File file : fList){
                if ( file.isFile() ) {
                    count ++;
                    Map<String, Object> oneData = new HashMap<String, Object>();
                    oneData.put("codeCd", count);
                    oneData.put("codeNm", file.getName());
                    resultData.add(oneData);
                }
            }
        } catch(Exception e) {
            ;
        }
        logger.debug("BillingCommController.fileList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"comboPayMidList"})
    public String comboPayMidList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BillingCommController.comboPayMidList param [{}]", param);

        List<Map<String, Object>> resultData = this.billingCommService.selDataList("selComboPayMidList", param);

        logger.debug("BillingCommController.comboPayMidList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


}
