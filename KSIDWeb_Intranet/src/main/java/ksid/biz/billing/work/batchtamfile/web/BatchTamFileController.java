/*
 *
 */
package ksid.biz.billing.work.batchtamfile.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

import ksid.biz.billing.work.batchtamfile.service.BatchTamFileService;
import ksid.core.webmvc.base.web.BaseController;
import ksid.core.webmvc.util.OsUtilLib;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/batchtamfile")
public class BatchTamFileController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BatchTamFileController.class);

    @Autowired
    BatchTamFileService batchTamFileService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BatchTamFileController.view param [{}]", param);

        return "billing/work/batchtamfile";
    }


    @RequestMapping(value= {"fileList"})
    public String fileList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BatchTamFileController.fileList param [{}]", param);

        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
        String fileDir = StringUtils.defaultString((String)param.get("fileDir"));
        fileDir = fileDir.trim().replace('：', ':');

        String fileName = "";
        File directory = new File(fileDir);
        File[] fList = directory.listFiles();

        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();

        try {
            for (File file : fList){
                if ( file.isFile() ) {
                    fileName = file.getName();
                    Map<String, Object> oneData = new HashMap<String, Object>();
                    oneData.put("fileNm" , fileName);          //파일명
                    oneData.put("fileSz" , file.length());     //파일크기
                    oneData.put("fileDtm", sf.format(file.lastModified()));  //파일일시
                    oneData.put("language", param.get("language"));

                    Map<String, Object> hisData = this.batchTamFileService.getTamFileHis(oneData);
                    if( hisData == null ) {
                        oneData.put("batchFg"   , "N");         //대사작업 여부
                        oneData.put("batchFgNm" , "미작업");
                        oneData.put("billMonth" , "");          //정산월
                        oneData.put("gtrDtm"    , "");          //파일수집일시
                        oneData.put("fileChk"   , "");          //파일유효성
                        oneData.put("fileChkNm" , "" );
                        oneData.put("gtrDtm"    , "");
                    } else {
                        oneData.put("batchFg"   , "Y");                         //대사작업 여부
                        oneData.put("batchFgNm" , "작업완료");
                        oneData.put("billMonth" , hisData.get("billMonth") );   //정산월
                        oneData.put("fileChk"   , hisData.get("fileChk") );
                        oneData.put("fileChkNm" , hisData.get("fileChkNm") );   //파일수집일시
                        oneData.put("gtrDtm"    , hisData.get("gtrDtm") );      //파일유효성
                    }
                    resultData.add(oneData);
                }
            }
        } catch(Exception e) {
            logger.error(e.toString());
        }

        MiniComparator comp = new MiniComparator();
        Collections.sort(resultData, comp);

        logger.debug("BatchTamFileController.fileList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


    @RequestMapping(value= {"tamFileDirList"})
    public String tamFileDirList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BatchTamFileController.tamFileDirList param [{}]", param);

        param.put("codeGroupCd", "BATCH_DIR");

        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                param.put("codeCd", "PC_TAM_DIR");
                break;
            case LINUX:
                logger.info("=====> getOS LINUX");
                param.put("codeCd", "SERVER_TAM_DIR");
            default :
                break;
        }

        List<Map<String, Object>> resultData = this.batchTamFileService.selDataList("tamFileDirList", param);

        logger.debug("BatchTamFileController.tamFileDirList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.batchTamFileService.excelDownloadGrid(request, response);
        } catch(Exception e) {

        }
    }

}

class MiniComparator implements Comparator<Map<String, Object>> {

    @Override
    public int compare(Map<String, Object> first, Map<String, Object> second) {

        String firstValue = (String)first.get("fileNm");
        String secondValue = (String)second.get("fileNm");
        int diffValue = firstValue.compareTo(secondValue);

        if ( diffValue > 0 ) {
            return -1;
        } else if ( diffValue > 0 ) {
            return 1;
        }
        return 0;
    }

}



