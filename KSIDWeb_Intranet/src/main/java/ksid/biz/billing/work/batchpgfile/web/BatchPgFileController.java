/*
 *
 */
package ksid.biz.billing.work.batchpgfile.web;

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

import ksid.biz.billing.work.batchpgfile.service.BatchPgFileService;
import ksid.core.webmvc.base.web.BaseController;
import ksid.core.webmvc.util.OsUtilLib;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/batchpgfile")
public class BatchPgFileController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BatchPgFileController.class);

    @Autowired
    BatchPgFileService batchPgFileService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BatchPgFileController.view param [{}]", param);

        return "billing/work/batchpgfile";
    }


    @RequestMapping(value= {"fileList"})
    public String fileList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BatchPgFileController.fileList param [{}]", param);

        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
        String fileDir = StringUtils.defaultString((String)param.get("fileDir"));
        fileDir = fileDir.trim().replace('：', ':');

        String fileName = "";
        int index = 0;
        String payDate = "";

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

                    String regExpr1 = "[T-T][0-9]{8}+.(?i)(xls|csv)$";
                    String regExpr2 = "[S-S][0-9]{8}+.(?i)(xls|csv)$";
                    Pattern pattern1 = Pattern.compile(regExpr1);
                    Pattern pattern2 = Pattern.compile(regExpr2);

                    Map<String, Object> hisData = this.batchPgFileService.getPgFileHis(oneData);
                    if( hisData == null ) {
                        oneData.put("batchFg"   , "N");         //대사작업 여부
                        oneData.put("batchFgNm" , "미작업");
                        oneData.put("payTp"     , "N");
                        oneData.put("payTpNm"   , "미구분");     //대사구분(T:거래,S:정산)
                        oneData.put("payDate"   , "");          //대사일자
                        oneData.put("fileChk"   , "");          //파일유효성
                        oneData.put("fileChkNm" , "" );
                        oneData.put("gtrDtm"    , "");          //파일수집일시

                        Matcher matcher1 = pattern1.matcher(fileName);
                        Matcher matcher2 = pattern2.matcher(fileName);

                        if(matcher1.find()) { //거래대사
                            oneData.put("payTp"   , "T");
                            oneData.put("payTpNm" , "거래대사");    //대사구분(T:거래,S:정산)
                            //logger.debug("!!! start pos[{}]", matcher1.start() );
                            index = matcher1.start();
                            payDate = fileName.substring(index+1);
                            oneData.put("payDate"   , payDate.substring(0, 8));          //대사일자
                            //logger.debug("!!! start pos[{}] data[{}]", matcher1.start(), payDate.substring(0, 8) );
                        }
                        if(matcher2.find()) { //정산대사
                            oneData.put("payTp"   , "S");
                            oneData.put("payTpNm" , "정산대사");    //대사구분(T:거래,S:정산)
                            index = matcher2.start();
                            payDate = fileName.substring(index+1);
                            oneData.put("payDate"   , payDate.substring(0, 8));          //대사일자
                            //logger.debug("!!! start pos[{}] data[{}]", matcher1.start(), payDate.substring(0, 8) );
                        }
                    } else {
                        oneData.put("batchFg"   , "Y");                         //대사작업 여부
                        oneData.put("batchFgNm" , "작업완료");
                        oneData.put("payTp"     , hisData.get("payTp") );       //대사구분(T:거래,S:정산)
                        oneData.put("payTpNm"   , hisData.get("payTpNm") );
                        oneData.put("payDate"   , hisData.get("payDate") );     //대사일자
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

        logger.debug("BatchPgFileController.fileList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


    @RequestMapping(value= {"pgFileDirList"})
    public String pgFileDirList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BatchPgFileController.pgFileDirList param [{}]", param);

        param.put("codeGroupCd", "BATCH_DIR");

        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                param.put("codeCd", "PC_PG_DIR");
                break;
            case LINUX:
                logger.info("=====> getOS LINUX");
                param.put("codeCd", "SERVER_PG_DIR");
            default :
                break;
        }

        List<Map<String, Object>> resultData = this.batchPgFileService.selDataList("pgFileDirList", param);

        logger.debug("BatchPgFileController.pgFileDirList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.batchPgFileService.excelDownloadGrid(request, response);
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



