/*
 *
 */
package ksid.biz.billing.work.sftp.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jcraft.jsch.ChannelSftp;

import ksid.biz.billing.work.sftp.service.SftpServService;
import ksid.biz.billing.work.sftp.service.impl.SFTPUtil;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("billing/work/sftp")
public class SftpServController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(SftpServController.class);

    @Autowired
    private SftpServService sftpServService;


    @RequestMapping(value= {"tamsftp"})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SftpServController.view param [{}]", param);

        return "billing/work/tamsftp";
    }


    //SFTP 연동 정보 리스트
    @RequestMapping(value= {"serverFtpList"})
    public String serverFtpList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SftpServController.serverFtpList param [{}]", param);

        param.put("codeGroupCd", "SFTP_INFO");

        List<Map<String, Object>> resultData = this.sftpServService.selDataList("serverFtpList", param);

        logger.debug("SftpServController.serverInfoList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


    //TAM 디렉토리 정보
    @RequestMapping(value= {"tamFileDirList"})
    public String tamFileDirList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SftpServController.tamFileDirList param [{}]", param);

        param.put("codeGroupCd", "BATCH_DIR");
        param.put("codeCd", "TAM_DIR");

        List<Map<String, Object>> resultData = this.sftpServService.selDataList("tamFileDirList", param);

        logger.debug("SftpServController.tamFileDirList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


    //PC 디렉토리 정보
    @RequestMapping(value= {"pgFileDirList"})
    public String pgFileDirList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SftpServController.pgFileDirList param [{}]", param);

        param.put("codeGroupCd", "BATCH_DIR");
        param.put("codeCd", "PG_DIR");

        List<Map<String, Object>> resultData = this.sftpServService.selDataList("tamFileDirList", param);

        logger.debug("SftpServController.pgFileDirList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }


    //Local PC 디렉토리 파일 리스트
    @RequestMapping(value= {"fileList"})
    public String fileList(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("SftpServController.fileList param [{}]", param);

        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
        String fileDir = StringUtils.defaultString((String)param.get("dir"));
        fileDir = fileDir.trim().replace('：', ':');
        logger.debug("fileDir [{}]", fileDir);

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
                    resultData.add(oneData);
                }
            }
        } catch(Exception e) {
            logger.error(e.toString());
        }

        FileComparator comp = new FileComparator();
        Collections.sort(resultData, comp);

        logger.debug("SftpServController.fileList resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    class FileComparator implements Comparator<Map<String, Object>> {

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

    //Remote 서버의 디렉토리 파일 리스트
    @RequestMapping(value= {"getFileList"})
    public String getFileList(@RequestParam Map<String, Object> param, Model model) {

        String dir = null; //접근할 폴더가 위치할 경로
        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();

        logger.debug("SftpServController.getFileList param [{}]", param);
        dir = StringUtils.defaultString((String)param.get("dir"));
        if(dir.length() == 0) {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        } else {
            if( "/".equals(dir.substring(dir.length()-1)) == false ) {
                dir = dir + "/";
            }
        }
        logger.debug("getFileList dir[{}]", dir);

        SFTPUtil sftpUtil = this.sftpServService.init(param);
        if(sftpUtil == null) {

            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
            return "json";

        } else {

            String fileNm   = null;  //파일명
            String longNm   = null;
            Vector<ChannelSftp.LsEntry> list = sftpUtil.getFileList(dir);
            if (list == null) {

                model.addAttribute("resultCd", "99");
                model.addAttribute("resultData", resultData);

            } else  {

                for (ChannelSftp.LsEntry oListItem : list) {

                    if (!oListItem.getAttrs().isDir()) {
                        fileNm = oListItem.getFilename();
                        longNm = oListItem.getLongname();

                        longNm = longNm.replaceAll(fileNm, " ");

                        logger.debug("fileNm [{}]", fileNm);
                        logger.debug("longNm [{}]", longNm);

                        Map<String, Object> oneData = new HashMap<String, Object>();
                        oneData.put("fileNm"   , fileNm);
                        oneData.put("longNm"   , longNm);
                        resultData.add(oneData);
                    }
                }

                FileComparator comp = new FileComparator();
                Collections.sort(resultData, comp);

                model.addAttribute("resultCd", "00");
                model.addAttribute("resultData", resultData);
            }
        }

        return "json";
    }


    //Local에서 Remote로 파일 전송
    @RequestMapping(value= {"upload"})
    public String upload(@RequestParam Map<String, Object> param, Model model) {

        boolean result = true;
        String dir     = null; //접근할 폴더가 위치할 경로
        String upFile  = null;

        logger.debug("SftpServController.upload param [{}]", param);

        dir = StringUtils.defaultString((String)param.get("dir"));
        if(dir.length() == 0) {
            result = false;
        } else {
            if( File.separator.equals(dir.substring(dir.length()-1)) == false ) {
                if( "/".equals(dir.substring(dir.length()-1)) == false ) {
                    dir = dir + "/";
                }
            }
        }
        upFile = StringUtils.defaultString((String)param.get("upFile"));
        if(upFile.length() == 0) {
            result = false;
        }

        if (result) {

            logger.debug("upload dir[{}]", dir);
            logger.debug("upload upFile[{}]", upFile);

            SFTPUtil sftpUtil = this.sftpServService.init(param);
            if(sftpUtil == null) {

                result = false;

            } else {

                try {
                    result = sftpUtil.upload(dir, upFile);
                } catch (Exception e) {
                    e.printStackTrace();
                    result = false;
                }

                sftpUtil.disconnection();

            }
        }

        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();

        if(result) {
            model.addAttribute("resultCd", "00");
            Map<String, Object> oneData = new HashMap<String, Object>();
            oneData.put("dir" , dir);
            oneData.put("file", upFile);
            resultData.add(oneData);
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }
        return "json";
    }


    //Local에서 Remote로 디렉토리의 파일 모두 전송
    @RequestMapping(value= {"uploadFolder"})
    public String uploadFolder(@RequestParam Map<String, Object> param, Model model) {

        boolean result = true;
        String localDir  = null;
        String remoteDir = null;

        logger.debug("SftpServController.uploadFolder param [{}]", param);

        localDir = StringUtils.defaultString((String)param.get("localDir"));
        if(localDir.length() == 0) {
            result = false;
        } else {
            if( File.separator.equals(localDir.substring(localDir.length()-1)) == false ) {
                if( "/".equals(localDir.substring(localDir.length()-1)) == false ) {
                    localDir = localDir + "/";
                }
            }
        }
        remoteDir = StringUtils.defaultString((String)param.get("remoteDir"));
        if(remoteDir.length() == 0) {
            result = false;
        } else {
            if( "/".equals(remoteDir.substring(remoteDir.length()-1)) == false ) {
                remoteDir = remoteDir + "/";
            }
        }

        if (result) {

            logger.debug("uploadFolder localDir[{}]", localDir);
            logger.debug("uploadFolder remoteDir[{}]", remoteDir);

            SFTPUtil sftpUtil = this.sftpServService.init(param);
            if(sftpUtil == null) {

                result = false;

            } else {

                try {
                    result = sftpUtil.uploadFolder(remoteDir, localDir);
                } catch (Exception e) {
                    e.printStackTrace();
                    result = false;
                }

                sftpUtil.disconnection();

            }
        }

        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();

        if(result) {
            model.addAttribute("resultCd", "00");
            Map<String, Object> oneData = new HashMap<String, Object>();
            oneData.put("localDir"  , localDir);
            oneData.put("remoteDir" , remoteDir);
            resultData.add(oneData);
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }
        return "json";
    }


    //Remote에서 Local로 파일 수신
    @RequestMapping(value= {"download"})
    public String download(@RequestParam Map<String, Object> param, Model model) {

        boolean result = true;
        String dir     = null;   //접근할 폴더가 위치할 경로
        String fileName= null;   //ex. "test.txt"
        String saveDir = null;   //ex. "f:\\test3.txt"

        logger.debug("SftpServController.download param [{}]", param);

        dir = StringUtils.defaultString((String)param.get("dir"));
        if(dir.length() == 0) {
            result = false;
        } else {
            if( "/".equals(dir.substring(dir.length()-1)) == false ) {
                dir = dir + "/";
            }
        }
        fileName = StringUtils.defaultString((String)param.get("fileName"));
        if(fileName.length() == 0) {
            result = false;
        }
        saveDir = StringUtils.defaultString((String)param.get("saveDir"));
        if(saveDir.length() == 0) {
            result = false;
        }

        if(result) {
            logger.debug("download dir[{}]", dir);
            logger.debug("download fileName[{}]", fileName);
            logger.debug("download saveDir[{}]", saveDir);

            SFTPUtil sftpUtil = this.sftpServService.init(param);
            if(sftpUtil == null) {

                result = false;

            } else {

                result = sftpUtil.download(dir, fileName, saveDir);
                sftpUtil.disconnection();

            }
        }

        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();
        if(result) {
            model.addAttribute("resultCd", "00");
            Map<String, Object> oneData = new HashMap<String, Object>();
            oneData.put("dir" , dir);
            oneData.put("file", fileName);
            oneData.put("saveDir", saveDir);
            resultData.add(oneData);
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }

        return "json";
    }


    //Remote에서 Local로 디렉토리의 파일 모두 전송
    @RequestMapping(value= {"downloadFolder"})
    public String downloadFolder(@RequestParam Map<String, Object> param, Model model) {

        boolean result = true;
        int    downCnt = 0;
        String localDir  = null;
        String remoteDir = null;

        logger.debug("SftpServController.downloadFolder param [{}]", param);

        localDir = StringUtils.defaultString((String)param.get("localDir"));
        if(localDir.length() == 0) {
            result = false;
        } else {
            if( File.separator.equals(localDir.substring(localDir.length()-1)) == false ) {
                if( "/".equals(localDir.substring(localDir.length()-1)) == false ) {
                    localDir = localDir + "/";
                }
            }
        }
        remoteDir = StringUtils.defaultString((String)param.get("remoteDir"));
        if(remoteDir.length() == 0) {
            result = false;
        } else {
            if( "/".equals(remoteDir.substring(remoteDir.length()-1)) == false ) {
                remoteDir = remoteDir + "/";
            }
        }

        if (result) {

            logger.debug("downloadFolder localDir[{}]", localDir);
            logger.debug("downloadFolder remoteDir[{}]", remoteDir);

            SFTPUtil sftpUtil = this.sftpServService.init(param);
            if(sftpUtil == null) {

                result = false;

            } else {

                try {
                    downCnt = sftpUtil.downloadFolder(remoteDir, localDir);
                    if(downCnt == 0) result = false;
                    logger.debug("downloadFolder downCnt[{}]", downCnt);
                } catch (Exception e) {
                    e.printStackTrace();
                    result = false;
                }

                sftpUtil.disconnection();

            }
        }

        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();

        if(result) {
            model.addAttribute("resultCd", "00");
            Map<String, Object> oneData = new HashMap<String, Object>();
            oneData.put("localDir"  , localDir);
            oneData.put("remoteDir" , remoteDir);
            resultData.add(oneData);
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }
        return "json";
    }


    //Local 폴더의 파일 삭제
    @RequestMapping(value= {"rmLocalFile"})
    public String rmLocalFile(@RequestParam Map<String, Object> param, Model model) {

        boolean result = true;
        String dir     = null;   //접근할 폴더가 위치할 경로
        String fileName= null;   //ex. "test.txt"
        String fullFile= null;

        logger.debug("SftpServController.rmLocalFile param [{}]", param);

        dir = StringUtils.defaultString((String)param.get("dir"));
        if(dir.length() == 0) {
            result = false;
        } else {
            if( File.separator.equals(dir.substring(dir.length()-1)) == false ) {
                if( "/".equals(dir.substring(dir.length()-1)) == false ) {
                    dir = dir + "/";
                }
            }
        }
        fileName = StringUtils.defaultString((String)param.get("fileName"));
        if(fileName.length() == 0) {
            result = false;
        }
        logger.debug("rmLocalFile LocalDir [{}]", dir);
        logger.debug("rmLocalFile FileName [{}]", fileName);

        if(result) {
            fullFile = dir + fileName;
            File file = new File(fullFile);

            if ( file.delete() )  {
                logger.info("Delete successfull file[{}]", fileName);
            } else {
                result = false;
                logger.info("Delete failure file[{}]", fileName);
            }
        }

        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();
        if(result) {
            model.addAttribute("resultCd", "00");
            Map<String, Object> oneData = new HashMap<String, Object>();
            oneData.put("dir" , dir);
            oneData.put("file", fileName);
            resultData.add(oneData);
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }

        return "json";
    }

    //Remote 서버의 파일 삭제
    @RequestMapping(value= {"rmFile"})
    public String rmFile(@RequestParam Map<String, Object> param, Model model) {

        boolean result = true;
        String dir     = null;   //접근할 폴더가 위치할 경로
        String fileName= null;   //ex. "test.txt"

        logger.debug("SftpServController.rmFile param [{}]", param);

        dir = StringUtils.defaultString((String)param.get("dir"));
        if(dir.length() == 0) {
            result = false;
        } else {
            if( "/".equals(dir.substring(dir.length()-1)) == false ) {
                dir = dir + "/";
            }
        }

        fileName = StringUtils.defaultString((String)param.get("fileName"));
        if(fileName.length() == 0) {
            result = false;
        }
        logger.debug("rmFile dir[{}]", dir);
        logger.debug("rmFile fileName[{}]", fileName);

        if(result) {

            SFTPUtil sftpUtil = this.sftpServService.init(param);
            if(sftpUtil == null) {

                result = false;

            } else {

                result = sftpUtil.rmFile(dir, fileName);
                sftpUtil.disconnection();

            }
        }
        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();
        if(result) {
            model.addAttribute("resultCd", "00");
            Map<String, Object> oneData = new HashMap<String, Object>();
            oneData.put("dir" , dir);
            oneData.put("file", fileName);
            resultData.add(oneData);
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }

        return "json";
    }


    //Local PC의 파일 명칭 변경
    @RequestMapping(value= {"renameLocalFile"})
    public String renameLocalFile(@RequestParam Map<String, Object> param, Model model) {

        boolean result = true;
        String dir      = null;   //접근할 폴더가 위치할 경로
        String oldFileNm= null;   //ex. "test.txt"
        String newFileNm= null;   //ex. "test.txt"
        String fullOldFile= null;
        String fullNewFile= null;

        logger.debug("SftpServController.renameLocalFile param [{}]", param);

        dir = StringUtils.defaultString((String)param.get("dir"));
        if(dir.length() == 0) {
            result = false;
        } else {
            if( File.separator.equals(dir.substring(dir.length()-1)) == false ) {
                if( "/".equals(dir.substring(dir.length()-1)) == false ) {
                    dir = dir + "/";
                }
            }
        }
        oldFileNm = StringUtils.defaultString((String)param.get("oldFileNm"));
        if(oldFileNm.length() == 0) {
            result = false;
        }
        newFileNm = StringUtils.defaultString((String)param.get("newFileNm"));
        if(newFileNm.length() == 0) {
            result = false;
        }
        logger.debug("renameLocalFile dir[{}]", dir);
        logger.debug("renameLocalFile oldFileNm[{}]", oldFileNm);
        logger.debug("renameLocalFile newFileNm[{}]", newFileNm);

        if(result) {

            fullOldFile = dir + oldFileNm;
            fullNewFile = dir + newFileNm;
            File oldFile = new File(fullOldFile);
            File newFile = new File(fullNewFile);

            if ( oldFile.renameTo(newFile) )  {
                logger.info("Rename successfull file[{}] => [{}]", oldFileNm, newFileNm);
            } else {
                result = false;
                logger.info("Rename failure file[{}] => [{}]", oldFileNm, newFileNm);
            }

        }
        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();
        if(result) {
            model.addAttribute("resultCd", "00");
            Map<String, Object> oneData = new HashMap<String, Object>();
            oneData.put("dir" , dir);
            oneData.put("oldFileNm", oldFileNm);
            oneData.put("newFileNm", newFileNm);
            resultData.add(oneData);
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }

        return "json";
    }

    //Remote 서버의 파일 명칭 변경
    @RequestMapping(value= {"renameFile"})
    public String renameFile(@RequestParam Map<String, Object> param, Model model) {

        boolean result = true;
        String dir      = null;   //접근할 폴더가 위치할 경로
        String oldFileNm= null;   //ex. "test.txt"
        String newFileNm= null;   //ex. "test.txt"

        logger.debug("SftpServController.renameFile param [{}]", param);

        dir = StringUtils.defaultString((String)param.get("dir"));
        if(dir.length() == 0) {
            result = false;
        } else {
            if( "/".equals(dir.substring(dir.length()-1)) == false ) {
                dir = dir + "/";
            }
        }
        oldFileNm = StringUtils.defaultString((String)param.get("oldFileNm"));
        if(oldFileNm.length() == 0) {
            result = false;
        }
        newFileNm = StringUtils.defaultString((String)param.get("newFileNm"));
        if(newFileNm.length() == 0) {
            result = false;
        }
        logger.debug("renameFile dir[{}]", dir);
        logger.debug("renameFile oldFileNm[{}]", oldFileNm);
        logger.debug("renameFile newFileNm[{}]", newFileNm);

        if(result) {

            SFTPUtil sftpUtil = this.sftpServService.init(param);
            if(sftpUtil == null) {

                result = false;

            } else {

                result = sftpUtil.renameFile(dir, oldFileNm, newFileNm);
                sftpUtil.disconnection();

            }
        }
        List<Map<String, Object>> resultData = new ArrayList<Map<String, Object>>();
        if(result) {
            model.addAttribute("resultCd", "00");
            Map<String, Object> oneData = new HashMap<String, Object>();
            oneData.put("dir" , dir);
            oneData.put("oldFileNm", oldFileNm);
            oneData.put("newFileNm", newFileNm);
            resultData.add(oneData);
            model.addAttribute("resultData", resultData);
        } else {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", resultData);
        }

        return "json";
    }

}
