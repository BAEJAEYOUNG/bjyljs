/*
 *
 */
package ksid.biz.billing.work.batchfile.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import ksid.biz.billing.work.batchfile.service.BatchFileService;
import ksid.biz.file.FileDownloader;
import ksid.core.webmvc.base.web.BaseController;
import ksid.core.webmvc.util.OsUtilLib;
import ksid.core.webmvc.util.OsUtilLib.OS;


@Controller
@RequestMapping("/billing/work/batchfile")
public class BatchFileController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BatchFileController.class);

    @Autowired
    private BatchFileService batchFileService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BatchFileController.view param [{}]", param);

        return "billing/work/batchfile";
    }

    /**
     * 소유자에 대한 파일목록 조회
     *
     * @return json, code(성공 코드:00, 실패시 99), message, FileVO list
     */
    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("BatchFileController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.batchFileService.selDataList(param);

        logger.debug("BatchFileController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    /**
     * 파일업로드
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value= {"upload"}, method = RequestMethod.POST, produces = "application/json; charset=utf-8")
    public String upload(@RequestParam Map<String, Object> param, HttpServletRequest request,
            @RequestParam(value = "file", required = false) MultipartFile file, Model model) {

        logger.debug("FileController.upload param [{}] model [{}]", param, model);
        logger.debug("FileController.upload file [{}]", file);

        model.addAttribute("resultCd", "00");

        try {

            Map<String, Object> fileSaveMap  = new HashMap<String, Object>();

            fileSaveMap.putAll(param);

            if( !param.containsKey("compCd") || (String)param.get("compCd") == null || (String)param.get("compCd") == "" ) {
                fileSaveMap.put("compCd", "KSID");
            }

            String userId;

            //TODO: 무조건 세션으로....
            //사용자ID 파라메터 처리 되지 않으면(기본적으로 로긴 상테에서 만 가능함)...
            if( !param.containsKey("userId") || (String)param.get("userId") == null || (String)param.get("userId") == "" ) {
                HttpSession session = request.getSession();
                Map<String, Object> sessionUser = (Map<String, Object>)session.getAttribute("sessionUser");
                logger.debug("sessionUser [{}]", sessionUser);

                if (sessionUser != null) {
                    userId = (String)sessionUser.get("adminId");
                } else {
                    throw new Exception("첨부 등록자ID를 확인 할 수 없습니다");
                }
            } else {
                userId = (String)param.get("userId");
            }

            // 서버타입
            String serverTp = (OsUtilLib.getOS() == OS.WINDOWS) ? "PC" : "SERVER";
            fileSaveMap.put("serverTp", serverTp);

            String fileId = (String)this.batchFileService.selValue("selFileId", new HashMap<String, Object>());

            //임시(미승인) 경로, 존재하지 않으면 생성
            String filepath = getFilePath(fileSaveMap);

            //원본파일명
            String logicalFileNm = file.getOriginalFilename();

            //저장파일명

            String physicalFileNm = logicalFileNm;


            String fileExt = FilenameUtils.getExtension(logicalFileNm);

            fileSaveMap.put("contentType", file.getContentType());

            long size = 0;
            try {
                size = storeFile(file.getInputStream(), filepath, physicalFileNm);  // 첨부파일 저장
            } catch (Exception e) {
                e.printStackTrace();
                logger.error("파일업로드 실패:"+physicalFileNm, e);
                throw new RuntimeException("파일업로드 실패:"+physicalFileNm);
            }


            fileSaveMap.put("fileId", fileId);
            fileSaveMap.put("filePath", filepath);

            fileSaveMap.put("logicalFileNm", physicalFileNm);
            fileSaveMap.put("physicalFileNm", physicalFileNm);
            fileSaveMap.put("fileExt", fileExt);
            fileSaveMap.put("fileSize", size);
            fileSaveMap.put("approvalYn", "Y");
            fileSaveMap.put("delYn", "N");
            fileSaveMap.put("regId", userId);

            // 첨부파일정보 db 저장
            this.batchFileService.insData(fileSaveMap);

            logger.debug("fileSaveMap [{}]", fileSaveMap);

            model.addAttribute("resultCd", "00");
            model.addAttribute("resultMsg", "");
            model.addAttribute("resultData", "success save");

        } catch (Exception e) {

            e.printStackTrace();
            logger.error("첨부파일 저장시 오류발생 [{}]", e);
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultMsg", "파일저장시 오류가 발생하였습니다");

        }

        return "json";
    }

    /**
     * 파일 다운로드
     *      - 미승인 파일은 파일ID로 다운로드 가능하나 승인 파일은 관련정보로 검증 절차를 거침
     */
    @RequestMapping(value= {"download"})
    public void download(@RequestParam Map<String, Object> param, HttpServletResponse response) {

        String fileId = (String)param.get("fileId");

        boolean inline = "true".equalsIgnoreCase((String)param.get("inline"));

        Map<String, Object> fileMap = batchFileService.selData("getPublicFileInfo", param);

        if(fileMap == null) {
            sendTextMessage(response, "파일정보를 확인 할 수 없습니다:"+fileId);
            return;
        }

        String delYn = (String)fileMap.get("delYn");

        //삭제여부 확인
        if("Y".equals(delYn)) {
            sendTextMessage(response, "삭제된 파일정보 입니다:"+fileId);
            return;
        }

        String approvalYn = (String)fileMap.get("approvalYn");
        String fileOwnerCd = (String)fileMap.get("fileOwnerCd");
        String fileOwnerKey1 = (String)fileMap.get("fileOwnerKey1");
        String fileOwnerKey2 = (String)fileMap.get("fileOwnerKey2");
        String fileOwnerKey3 = (String)fileMap.get("fileOwnerKey3");

        //승인된 파일은 기타 파일정보와 대조, 보안을 위해
        if("Y".equals(approvalYn)) {
            if(!fileOwnerCd.equals((String)param.get("fileOwnerCd"))
                    || !fileOwnerKey1.equals((String)param.get("fileOwnerKey1"))
                    || (fileOwnerKey2 != null && !"".equals(fileOwnerKey2) && !fileOwnerKey2.equals((String)param.get("fileOwnerKey2")))
                    || (fileOwnerKey3 != null && !"".equals(fileOwnerKey3) && !fileOwnerKey3.equals((String)param.get("fileOwnerKey3")))) {

                sendTextMessage(response, "파일정보를 확인 할 권한이 없습니다:"+fileId);
                return;
            }
        }

        String filePath = (String)fileMap.get("filePath");
        String physicalFileNm = (String)fileMap.get("physicalFileNm");
        String logicalFileNm = (String)fileMap.get("logicalFileNm");

        //파일 다운로드
        FileDownloader fileDownloader = new FileDownloader();
        fileDownloader.download(response, filePath + physicalFileNm, inline, logicalFileNm);

    }

    @RequestMapping(value= {"delete"})
    public String delete(@RequestBody List<Map<String, Object>> param, Model model) {

        logger.debug("BasicPromoController.delete param [{}]", param);

        try {
            this.batchFileService.deleteFile(param);

            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "delete success !");
        } catch (Exception e) {
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", "delete fail ! - " + e.getMessage());
        }

        return "json";
    }

    /** MultipartHttpServletRequest 에서 첨부된 파일정보(MultipartFile) 목록 반환 */
    private List<MultipartFile> getMultipartFiles(MultipartHttpServletRequest mRequest) {
        List<MultipartFile> mFiles = new ArrayList<MultipartFile>();

        Iterator<String> it = mRequest.getFileNames();
        while(it.hasNext()) {
            String name = it.next();
            MultipartFile mFile = mRequest.getFile(name);
            mFiles.add(mFile);
        }

        return mFiles;
    }

    /** text/plain 형식으로 메세지를 작성하여 보낸다
     * @throws Exception */
    private void sendTextMessage(HttpServletResponse response, String msg) {
        response.setContentType("text/plain; charset=utf-8");
        try {
            response.getWriter().println(msg);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String getFilePath(Map<String, Object> param) {

        String filePath = (String)this.batchFileService.selValue("selFilePath", param);
        logger.debug("filePath [{}]", filePath);
        return filePath;

    }

    /**
     * InputStream 을 파일로 저장한다.
     *      - 폴더가 없으면 생성한다
     * @return file size
     */
    private static long storeFile(InputStream inputStream, String path, String filename) {
        long size = 0;
        FileOutputStream fos = null;
        try {
            //폴더가 없으면 생성한다
            File folder = new File(path);
            if(!folder.exists()) {
                folder.mkdirs();
            }

            //파일생성
            File file = new File(path + filename);
            fos = new FileOutputStream(file , false); // ( true:이어쓰기, false:덮어쓰기, 파일이없을경우 새로 생성 )
            byte[] readBuf = new byte[40960];
            int readLen = 0;
            //파일복사
            while((readLen = inputStream.read(readBuf)) > 0) {
                fos.write(readBuf, 0, readLen);
                size += readLen;
            }
        } catch (Exception e) {
            throw new RuntimeException("파일저장 실패:" + path + filename, e);
        } finally {
            //resource release
            if(fos != null) {
                try {
                    fos.flush();
                    fos.close();
                } catch(Exception e) {
                    e.printStackTrace();
                }
            }
        }

        return size;
    }
}

