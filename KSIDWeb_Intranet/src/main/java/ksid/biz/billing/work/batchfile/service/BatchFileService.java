package ksid.biz.billing.work.batchfile.service;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import ksid.core.webmvc.base.service.BaseService;

public interface BatchFileService extends BaseService<Map<String, Object>> {

    /**
     * 파일저장
     * @param batchTp
     *
     * @param logicalFileNm: required
     * @param contentType: if null application/octet-stream
     * @param fileSize: if null calculate
     * @param inputStream: required
     * @param compCd: required
     * @param regUserId: required
     */
    public Map<String, Object> storePublicFileAsBeforeApproval(Map<String, Object> fileSaveMap, InputStream inputStream);

    /**
     * 파일삭제
     * @param param
     */
    public void deleteFile(List<Map<String, Object>> param);

}
