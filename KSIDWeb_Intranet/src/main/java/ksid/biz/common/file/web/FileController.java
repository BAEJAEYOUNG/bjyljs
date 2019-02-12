/*
 *
 */
package ksid.biz.common.file.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import ksid.biz.common.file.service.FileService;
import ksid.biz.file.FileDownloader;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping(value= {"common/file"})
public class FileController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(FileController.class);

    private String uploadPath;
    private String fileViewPath;

    @Autowired
    ServletContext servletContext;

    @Autowired
    @Qualifier("context")
    private Properties props;

    @Autowired
    private FileService fileService;

    @Override
    public void initialize() {

        this.uploadPath = this.props.getProperty(String.format("%s-uploadPath", System.getProperty("server.type")));
    }

    @RequestMapping(value= {"uploader"})
    public String uploader(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FileController.uploader param [{}]", param);

        return "common/file/uploader";
    }

    @RequestMapping(value= {"upload"}, method = RequestMethod.POST, produces = "application/json; charset=utf-8")
    public String upload(@RequestParam Map<String, Object> param, HttpServletRequest request,
            @RequestParam(value = "file", required = false) MultipartFile file, Model model) {

        logger.debug("FileController.upload param [{}] model [{}]", param, model);
        logger.debug("FileController.upload file [{}]", file);

        model.addAttribute("resultCd", "00");

        StringBuffer resultMsg = new StringBuffer();

        try {
            // 파일명을 받는다 - 일반 원본파일명
            String fileName = file.getOriginalFilename();

            logger.debug("FileController.upload fileName [{}]", fileName);

            // 파일 확장자
            String fileNameExt = FilenameUtils.getExtension(fileName).toLowerCase();
            // 이미지 검증 배열변수
            String[] allowFileExts = {"jpg", "png", "bmp", "gif"};

            // 이미지가 아님
            if (!Arrays.asList(allowFileExts).contains(fileNameExt)) {
                resultMsg.append("NOTALLOW_").append(fileName);
                model.addAttribute("resultCd", "01");
            } else {
                // 이미지이므로 신규 파일로 디렉토리 설정 및 업로드
                // 파일 경로
                StringBuffer sbFilePath = new StringBuffer();
                //sbFilePath.append(request.getSession().getServletContext().getRealPath("/"));
                sbFilePath.append(this.uploadPath);

                File filePath = new File(sbFilePath.toString());
                if (!filePath.exists()) {
                    filePath.mkdirs();
                }

                StringBuffer sbFileName = new StringBuffer();
                sbFileName.append(new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
                sbFileName.append(UUID.randomUUID().toString());
                sbFileName.append(".").append(fileNameExt);

                //FileUtils.writeByteArrayToFile(new File(filePath, sbFileName.toString()), file.getBytes());
                FileUtils.writeByteArrayToFile(new File(this.uploadPath, sbFileName.toString()), file.getBytes());

                // 정보 출력
                resultMsg.append("|bNewLine:true");
                // img 태그의 title 속성을 원본파일명으로 적용시켜주기 위함
                resultMsg.append("|sFileName:").append(fileName);
                resultMsg.append("|sFileURL:").append(this.fileViewPath)
                                              .append("?filepath=photo&filename=")
                                              .append(sbFileName.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        logger.debug("FileController.upload resultMsg [{}]", resultMsg);

        model.addAttribute("resultMsg", resultMsg.toString());

        return "json";
    }

    @RequestMapping(value= {"view"}, produces = "application/download; utf-8")
    @ResponseBody
    public void view(@RequestParam(value = "filepath", required = false) String filepath,
            @RequestParam("filename") String filename, HttpServletResponse response) {

        logger.debug("FileController.view filepath [{}]", filepath);
        logger.debug("FileController.view filename [{}]", filename);

        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary");

        File filePath = new File(this.uploadPath, StringUtils.defaultString(filepath));

        logger.debug("FileController.view filePath [{}]", filePath.getAbsoluteFile());

        try {
            IOUtils.copy(new FileInputStream(new File(filePath, filename)), response.getOutputStream());
            response.flushBuffer();
        } catch (FileNotFoundException fnfe) {
            fnfe.printStackTrace();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
    }

    @RequestMapping(value= {"delete"})
    @ResponseBody
    public void delete(@RequestParam(value = "filepath", required = false) String filepath,
            @RequestParam("filename") String filename, HttpServletResponse response) {

        logger.debug("FileController.delete filepath [{}]", filepath);
        logger.debug("FileController.delete filename [{}]", filename);

        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary");

        File filePath = new File(this.uploadPath, StringUtils.defaultString(filepath));

        logger.debug("FileController.delete filePath [{}]", filePath.getAbsoluteFile());

        try {
            FileUtils.forceDelete(new File(filePath, filename));
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
    }

    /**
     * 소유자에 대한 파일목록 조회
     *
     * @return json, code(성공 코드:00, 실패시 99), message, FileVO list
     */
    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("FileController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.fileService.selDataList(param);

        logger.debug("FileController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param,
                        @RequestParam(value = "filesToUpload[]", required = false) MultipartFile[] files, Model model, HttpServletRequest request) {

        logger.debug("FileController.ins param [{}]", param);

        HttpSession session = request.getSession();
        Map<String, Object> sessionUser = (Map<String, Object>)session.getAttribute("sessionUser");
        logger.debug("sessionUser [{}]", sessionUser);

        param.put("regId", (String)sessionUser.get("adminId"));
        param.put("chgId", (String)sessionUser.get("adminId"));

        Map<String, Object> resultData = new HashMap<String, Object>();

        try {
            resultData = this.fileService.insDataFiles(param, files);

            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "insert success !");
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", e.getCause().getMessage());
        }

        logger.debug("DataController.ins resultData {}", resultData);

        return "json";
    }


    @RequestMapping(value= {"updDataMulti"})
    public String updDataMulti(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CustFixBillController.upd param [{}]", param);

        int cntExist = this.fileService.updDataMulti(param);

        if( 0 == cntExist ) {
            model.addAttribute("resultCd", "01");
            model.addAttribute("resultData", "해당 데이터가 존재하지 않습니다 !");
        } else {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "update success !");
        }

        return "json";
    }



    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        try {

            this.fileService.erasePublicFile(param);

            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "file delete success !");

        } catch (Exception e) {

            e.printStackTrace();

            model.addAttribute("resultCd", "99");
            model.addAttribute("resultData", e.getCause().getMessage());

        }

        return "json";

    }



    /**
     * 파일업로드
     * @param request
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value= {"upload_"})
    public String upload_(HttpServletRequest request, Model model) {

        //첨부된 파일정보 목록
        List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();

        try {

            MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest)request;
            List<MultipartFile> mFiles = this.getMultipartFiles(mRequest);

            String compCd = mRequest.getParameter("compCd");
            String userId = mRequest.getParameter("userId");
            String contentInlineYn = mRequest.getParameter("contentInlineYn");

            //회사코드는 파라메터 처리 되지 않으면 기본 KSID 으로
            if(compCd == null || compCd.isEmpty()) {
                compCd = "KSID";
            }

            //TODO: 무조건 세션으로....
            //사용자ID 파라메터 처리 되지 않으면(기본적으로 로긴 상테에서 만 가능함)...
            if(userId == null || userId.isEmpty()) {

                HttpSession session = request.getSession();
                Map<String, Object> sessionUser = (Map<String, Object>)session.getAttribute("sessionUser");
                logger.debug("sessionUser [{}]", sessionUser);

                if (sessionUser != null) {
                    userId = (String)sessionUser.get("adminId");
                } else {
                    throw new Exception("첨부 등록자ID를 확인 할 수 없습니다");
                }
            }

            if(mFiles.size() == 0) {
                model.addAttribute("resultCd", "99");
                model.addAttribute("resultMsg", "첨부할 파일 정보가 없습니다");
            } else {
                for(MultipartFile mFile : mFiles) {

                    Map<String, Object> fileMap = fileService.storePublicFileAsBeforeApproval(mFile.getOriginalFilename(), mFile.getContentType(), contentInlineYn, mFile.getSize(), mFile.getInputStream(), compCd, userId);

                    // 파일정보 중 보안관련 정보(경로) 제거
                    fileMap.put("filePath", null);

                    fileList.add(fileMap);
                }
            }

            model.addAttribute("resultCd", "00");
            model.addAttribute("resultMsg", "");
            model.addAttribute("resultData", fileList);

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

        Map<String, Object> fileMap = fileService.selData("getPublicFileInfo", param);

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
}
