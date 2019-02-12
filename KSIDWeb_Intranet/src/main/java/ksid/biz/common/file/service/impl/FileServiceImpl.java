package ksid.biz.common.file.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import ksid.biz.common.file.service.FileService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;
import ksid.core.webmvc.util.BaseUtil;
import ksid.core.webmvc.util.OsUtilLib;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("fileService")
public class FileServiceImpl extends BaseServiceImpl<Map<String, Object>> implements FileService {

    @Autowired
    private FileDAO fileDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.fileDao;
    }

    /** 등록일시/수정일시 를 저장하기 위한 데티터 포맷, DB특성을 피하기 위해 쿼리에서 작성하지 않고 로직에서 처리 */


    @Override
    public Map<String, Object> insDataFiles(Map<String, Object> param, MultipartFile[] files) {

        logger.debug("FileServiceImpl.insDataFiles param [{}]", param);

        String compCd = (String)param.get("compCd");
        String fileOwnerCd = (String)param.get("fileOwnerCd");
        String regDtm = DateFormatUtils.format(Calendar.getInstance(), "yyyyMMddHHmmss");

        String filePath = FILE_PATH_ROOT + compCd + File.separator + fileOwnerCd + File.separator + regDtm.substring(0, 6) + File.separator;
        if( param.containsKey("filePath") ) {

        }

        for (int i = 0; i < files.length; i++) {

            Map<String, Object> fileMap = new HashMap<String, Object>();

            MultipartFile file = files[i];

            //파일ID 채번
            String fileId = (String)this.fileDao.selValue("selFileId", new HashMap<String, Object>());

            fileMap.put("fileId", fileId);                                                      // 파일고유아이디
            fileMap.put("filePath", filePath);                                                  // 저장경로
            fileMap.put("physicalFileNm", fileId);                                              // 저장되는파일명(저장용)
            fileMap.put("logicalFileNm", file.getOriginalFilename());                           // 실제파일명(보여주기용)
            fileMap.put("fileExt", FilenameUtils.getExtension(file.getOriginalFilename()));     // 파일확장자
            fileMap.put("fileSize", file.getSize());                                            // 파일 크기
            fileMap.put("contentType", file.getContentType());                                  // 파일 컨텐츠
            fileMap.put("contentInlineYn", 'N');                                                // inline 여부(지금은 사용하지 않음(편집기 사용시 사용)
            fileMap.put("compCd", compCd);                                                      // 회사코드
            fileMap.put("approvalYn", "Y");                                                     // 승인여부(추가되거ㄴ
            fileMap.put("delYn", "N");



        }

        return null;
    }

    @Override
    public Map<String, Object> storePublicFileAsBeforeApproval(String logicalFileNm, String contentType, String contentInlineYn, long fileSize, InputStream inputStream, String compCd, String regId) {

        //TODO: fileSize 가  null이 아닐경우 제한크기 체크

        Map<String, Object> fileMap = new HashMap<String, Object>();

        //파일ID 채번
        String fileId = (String)this.fileDao.selValue("selFileId", new HashMap<String, Object>());

        //임시(미승인) 경로, 존재하지 않으면 생성
        String tempPath = FILE_PATH_ROOT + "temp" + File.separator;

        //실제 저장이름은 fileId 사용
        String physicalFileNm = fileId + "";

        String fileExt = FilenameUtils.getExtension(logicalFileNm);

        //contentType이 없으면 설정
        if(contentType == null || contentType.isEmpty()) {
            contentType = "application/octet-stream";
        }

        //저장된 파일크기는 실제 InputStream 을 읽어서 설정 - 파라메터가 넘어오지 않을 수 있으므로
        long size = 0;
        try {
            size = storeFile(inputStream, tempPath, physicalFileNm);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("파일업로드 실패:"+logicalFileNm, e);
            throw new RuntimeException("파일업로드 실패:"+logicalFileNm);
        }

        fileMap.put("fileId", fileId);
        fileMap.put("filePath", tempPath);
        fileMap.put("physicalFileNm", physicalFileNm);
        fileMap.put("logicalFileNm", logicalFileNm);
        fileMap.put("fileExt", fileExt);
        fileMap.put("fileSize", size);
        fileMap.put("contentType", contentType);
        fileMap.put("contentInlineYn", contentInlineYn);
        fileMap.put("compCd", compCd);
        fileMap.put("approvalYn", "N");     // 미승인
        fileMap.put("delYn", "N");
        fileMap.put("regId", regId);

        //TODO: fileSize  제한크기 체크 재확인

        //DB에 미승인 정보 입력
        this.fileDao.insData(fileMap);

        return fileMap;

    }

    /**]
     * 승인파일 저장치러
     */
    @Override
    public int approvalPublicFile(Map<String, Object> param) {

        String fileId = (String)param.get("fileId");
        String fileOwnerCd = (String)param.get("fileOwnerCd");


        Map<String, Object> fileInfo = this.fileDao.selData("getPublicFileInfo", param);

        if(fileInfo == null) {
            throw new RuntimeException("해당 일반파일정보를 확인할 수 없습니다:"+fileId);
        }

        String compCd = (String)fileInfo.get("compCd");
        String regDtm = (String)fileInfo.get("regDtm");
        String approvalYn = (String)fileInfo.get("approvalYn");
        String delYn = (String)fileInfo.get("delYn");

        if("Y".equals(approvalYn)) {
            throw new RuntimeException("이미 승인된 일반파일입니다:"+fileId);
        }

        if("Y".equals(delYn)) {
            throw new RuntimeException("이미 삭제된 일반파일입니다:"+fileId);
        }

        String filePath = FILE_PATH_ROOT + compCd + File.separator + fileOwnerCd + File.separator + regDtm.substring(0, 6) + File.separator;
        String fileName = (String)fileInfo.get("physicalFileNm");
        String tempFullFileName = (String)fileInfo.get("filePath") + fileName;

        try {
            copyFile(tempFullFileName, filePath, fileName);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("파일승인 복사 실패 : " + tempFullFileName, e);
            throw new RuntimeException("파일승인 복사 실패:"+tempFullFileName, e);
        }

        param.put("filePath", filePath);
        int affectedRow = fileDao.updData("updatePublicFileAsApproval", param);

        if(affectedRow == 1) {
            // 정상적으로 저장되었다면 임시파일을 삭제한다.
            try {
                deleteFile(tempFullFileName);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return 0;
    }

    @Override
    public int erasePublicFile() {

        // TODO Auto-generated method stub
        return 0;
    }

    @Override
    public int erasePublicFile(Map<String, Object> param) {

        Map<String, Object> fileInfo = this.fileDao.selData("getPublicFileInfo", param);

        String fileId = (String)param.get("fileId");

        if(fileInfo == null) {
            throw new RuntimeException("해당 일반파일정보를 확인할 수 없습니다:"+fileId);
        }

        int affectedRow = this.fileDao.delData(param);

        String fileName = (String)fileInfo.get("physicalFileNm");
        String fullFileName = (String)fileInfo.get("filePath") + fileName;

        if(affectedRow == 1) {
            deleteFile(fullFileName);
        }

        return affectedRow;
    }

    @SuppressWarnings("unchecked")
    @Override
    public int updDataMulti(Map<String, Object> param) {

        int rtnVal = 0;

        String strMultiData = (String)param.get("param");

        logger.debug("strMultiData [{}]", strMultiData);

        JSONObject multiData = JSONObject.fromObject(strMultiData);

        // 파일이외의 data 처리 자료가 존재한다면 해당 자료에 대한 처리를 한다.
        if(multiData.containsKey("data")) {

            JSONObject paramsData = multiData.getJSONObject("data");

            Map<String, Object> params = BaseUtil.toMap(paramsData);  // { "data":map or array , "file":array }

            Iterator<String> it = paramsData.keys(); //쿼리 넣은 순서대로 쓰기위해 사용 이거 건너뛰고 바로 멥에서 키셋꺼내서 사용시 순서 엉킴

            while(it.hasNext()) {

                String sqlId = it.next();

                Object paramsObj = params.get(sqlId);

                if(paramsObj instanceof List) {

                    List<Map<String, Object>> paramsList = (List<Map<String, Object>>) paramsObj;

                    for(Map<String, Object> paramsMap : paramsList) {

                        this.fileDao.updDataFile(sqlId, paramsMap);
                    }

                } else {

                    Map<String, Object> paramsMap = (Map<String, Object>)paramsObj;

                    this.fileDao.updDataFile(sqlId, paramsMap);

                }

            }

        }


        // 파일 update 처리를 한다.
        JSONArray paramsFile = multiData.getJSONArray("file");

        List<Map<String, Object>> fileList = null;

        for (int i = 0; i < paramsFile.size(); i++) {

            fileList = BaseUtil.toList(paramsFile.getJSONArray(i));

            for(Map<String, Object> map : fileList) {

                logger.debug("fileList > map [{}]", map);

                // 삭제처리가 되어있는 파일을 테이블에 적용한다.
                if("Y".equals(map.get("delYn"))) {
                    rtnVal += this.erasePublicFile(map);
                            //.updData("updatePublicFileWidthDelFlag", map);
                }

                // 승인이 안되어 있는 파일은 파일을 복사하고 승인처리 한다.
                if("N".equals(map.get("approvalYn"))) {
                    rtnVal += this.approvalPublicFile(map);
                }

            }

        }

        return rtnVal;
    }





    private static final String FILE_PATH_ROOT = getResourcePath();

    private static String getResourcePath() {
        String resourcePath = null;

        switch (OsUtilLib.getOS()) {
            case WINDOWS:
                logger.info("=====> getOS WINDOWS");
                resourcePath = "C:" + File.separator + "temp" + File.separator + "multifile" + File.separator;
                break;
            case MAC:
            case LINUX:
            default :
                resourcePath = File.separator + "tmp" + File.separator + "multifile" + File.separator;
                break;
        }
        return resourcePath;
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
            fos = new FileOutputStream(file);
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

    /**
     * 파일을 복사한다
     *      - 폴더가 없으면 생성한다
     * @return file size
     */
    public static long copyFile(String sourceFullFilename, String path, String fileName) {
        long size = 0;
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(sourceFullFilename);
            size = storeFile(fis, path, fileName);
        } catch (Exception e) {
            throw new RuntimeException("파일 복사 실패:" + path + fileName + " --> " + sourceFullFilename, e);
        } finally {
            //resource release
            if(fis != null) {
                try {
                    fis.close();
                } catch(Exception e) {

                }
            }
        }

        return size;
    }

    /**
     * 파일을 삭제한다
     * @return if success true
     */
    public static boolean deleteFile(String fullFilename) {
        File file = new File(fullFilename);
        if(file.exists()) {
            return file.delete();
        }
        //이미 삭제되었으면 성공
        return true;
    }


}
