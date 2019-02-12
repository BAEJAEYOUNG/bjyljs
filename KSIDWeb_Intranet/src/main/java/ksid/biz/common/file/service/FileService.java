package ksid.biz.common.file.service;

import java.io.InputStream;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import ksid.core.webmvc.base.service.BaseService;

public interface FileService extends BaseService<Map<String, Object>> {

    /**
     * 승인전 일반파일 임시경로에 저장 및 미승인 정보 DB입력
     *
     * @param logicalFileNm: required
     * @param contentType: if null application/octet-stream
     * @param fileSize: if null calculate
     * @param inputStream: required
     * @param compCd: required
     * @param regUserId: required
     */
    public Map<String, Object> storePublicFileAsBeforeApproval(String logicalFileNm, String contentType, String contentInlineYn, long fileSize, InputStream inputStream, String compCd, String regId);

    /**
     * 승인전 일반파일정보 승인처리
     *
     * @param fileId: required
     * @param fileOwnerCd: required
     * @param fileOwnerKey1: required
     * @param fileOwnerKey2: if exist required
     * @param fileOwnerKey3: if exist required
     * @param fileOwnerType: required, default-ATTACH
     * @param fileOwnerRef: optional
     * @param modUserId: required
     *
     * @return affectedRow, if success 1
     */
    public int approvalPublicFile(Map<String, Object> params);

    /**
     *  한시간이 지난 미승인 데이터 및 파일 삭제 처리
     *
     *  @return affectedRow
     *  */
    public int erasePublicFile();

    /**
     * fileId 에 해당하는 파일 및 정보 삭제
     *
     * @return affectedRow, if success 1
     */
    public int erasePublicFile(Map<String, Object> param);

    /**
     * 파일 & 데이터 일괄 INSERT, UPDATE 처리
     * @param param
     * @return
     */
    public int updDataMulti(Map<String, Object> param);

    /**
     * DATA, FILE UPLOAD
     * @param param
     * @param files
     * @return
     */
    public Map<String, Object> insDataFiles(Map<String, Object> param, MultipartFile[] files);


}
