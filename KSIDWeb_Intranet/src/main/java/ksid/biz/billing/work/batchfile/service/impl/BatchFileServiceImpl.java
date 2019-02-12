package ksid.biz.billing.work.batchfile.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.billing.work.batchfile.service.BatchFileService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;
import ksid.core.webmvc.util.OsUtilLib;

@Service("batchFileService")
public class BatchFileServiceImpl extends BaseServiceImpl<Map<String, Object>> implements BatchFileService {

    @Autowired
    private BatchFileDAO batchFileDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.batchFileDao;

    }

    /** 등록일시/수정일시 를 저장하기 위한 데티터 포맷, DB특성을 피하기 위해 쿼리에서 작성하지 않고 로직에서 처리 */
    @Override
    public Map<String, Object> storePublicFileAsBeforeApproval(Map<String, Object> fileSaveMap, InputStream inputStream) {

        //TODO: fileSize 가  null이 아닐경우 제한크기 체크

        //파일ID 채번
        String fileId = (String)this.batchFileDao.selValue("selFileId", new HashMap<String, Object>());

        //임시(미승인) 경로, 존재하지 않으면 생성
        String filepath = getFilePath(fileSaveMap);

        //실제 저장이름은 fileId 사용
        String physicalFileNm = (String)fileSaveMap.get("logicalFileNm");

        String fileExt = FilenameUtils.getExtension((String)fileSaveMap.get("logicalFileNm"));

        String contentType = (String)fileSaveMap.get("contentType");

        //contentType이 없으면 설정
        if(contentType == null || contentType.isEmpty()) {
            contentType = "application/octet-stream";
        }

        //저장된 파일크기는 실제 InputStream 을 읽어서 설정 - 파라메터가 넘어오지 않을 수 있으므로
        long size = 0;
        try {
            size = storeFile(inputStream, filepath, physicalFileNm);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("파일업로드 실패:"+physicalFileNm, e);
            throw new RuntimeException("파일업로드 실패:"+physicalFileNm);
        }

        fileSaveMap.put("fileId", fileId);
        fileSaveMap.put("filePath", filepath);
        fileSaveMap.put("physicalFileNm", physicalFileNm);
        fileSaveMap.put("fileExt", fileExt);
        fileSaveMap.put("fileSize", size);
        fileSaveMap.put("contentType", contentType);
        fileSaveMap.put("approvalYn", "Y");
        fileSaveMap.put("delYn", "N");

        //TODO: fileSize  제한크기 체크 재확인

        //DB에 미승인 정보 입력
        this.batchFileDao.insData(fileSaveMap);

        return fileSaveMap;

    }

    private String getFilePath(Map<String, Object> fileSaveMap) {

        String filePath = (String)this.getDao().selValue("selFilePath", fileSaveMap);
        logger.debug("filePath [{}]", filePath);
        return filePath;

    }
    /**
     * FILE DELETE
     */
    @Override
    public void deleteFile(List<Map<String, Object>> paramDelList) {

        logger.debug("BatchFileServiceImpl > deleteFile paramDelList [{}]", paramDelList);

        for (int i = 0; i < paramDelList.size(); i++) {

            Map<String, Object> param = (Map<String, Object>)paramDelList.get(i);

            Map<String, Object> fileInfo = this.batchFileDao.selData("getPublicFileInfo", param);

            logger.debug("deleteFile > fileInfo [{}]", fileInfo);

            String fileName = (String)fileInfo.get("physicalFileNm");
            logger.debug("deleteFile > fileName [{}]", fileName);

            String fullFileName = (String)fileInfo.get("filePath") + fileName;
            logger.debug("deleteFile > fullFileName [{}]", fullFileName);

            deleteFile(fullFileName);

        }

       // 데이터삭제
        for (int i = 0; i < paramDelList.size(); i++) {

            this.batchFileDao.delData((Map<String, Object>)paramDelList.get(i));

        }

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
