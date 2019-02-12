package ksid.biz.file;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;

/**
 * 확장자별 MIME
 *
 * @author 염국선
 * @since 2011. 4. 15.
 */
public class MimeProvider {

    /** 파일 확장자별 MIME 저장 */
    private Map<String, String> mimes;


    /** MIME 정보 맵 설정 */
    public void setMimes(Map<String, String> mimes) {
        this.mimes = mimes;
    }

    /** 확장자별 mime 추가 */
    public void addMimeType(String ext, String mime) {
        if(mimes == null) {
            loadDefaultMimes();
        }
        mimes.put(ext.toLowerCase(), mime);
    }

    /** 파일이름의 확장자로 mime 을 결정한다. */
    public String getMimeType(String fileName) {
        String ext = FilenameUtils.getExtension(fileName).toLowerCase();
        String contentType = null;
        if(mimes == null) {
            loadDefaultMimes();
        }
        Iterator<String> it = mimes.keySet().iterator();
        while(it.hasNext()) {
            String key = it.next();
            if(key.equals(ext)) {
                contentType = mimes.get(key);
                break;
            }
        }
        return contentType;
    }

    /** 기본 mime 값 저장 */
    public void loadDefaultMimes() {
        if(mimes == null) {
            mimes = new HashMap<String, String>();
        }
        //text/* 는 disposition type의 attachemnt를 위해 제외
        loadImageMimes();
        loadDocMimes();
    }

    /** 문서 mime 값 저장 */
    public void loadDocMimes() {
        if(mimes == null) {
            mimes = new HashMap<String, String>();
        }
        mimes.put("pdf", "application/pdf");
        mimes.put("ppt", "application/x-mspowerpoint");
        mimes.put("xls", "application/vnd.ms-excel");
        mimes.put("pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation");
        mimes.put("xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        mimes.put("docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
    }

    /** image관련 mime 값 저장 */
    public void loadImageMimes() {
        if(mimes == null) {
            mimes = new HashMap<String, String>();
        }
        mimes.put("bmp", "image/bmp");
        mimes.put("gif", "image/gif");
        mimes.put("ief", "image/ief");
        mimes.put("jfif", "image/pipeg");
        mimes.put("jpe", "image/jpeg");
        mimes.put("jpg", "image/jpeg");
        mimes.put("jpeg", "image/jpeg");
        mimes.put("png", "image/png");
        mimes.put("tif", "image/tiff");
        mimes.put("tiff", "image/tiff");
        mimes.put("ico", "image/x-icon");
        mimes.put("rgb", "image/x-rgb");
        mimes.put("xwd", "image/x-xwindowdump");
    }

}
