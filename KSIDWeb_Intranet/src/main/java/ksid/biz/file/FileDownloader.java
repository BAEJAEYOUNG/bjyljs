package ksid.biz.file;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.Charset;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * HttpServlet download
 *
 * @author 염국선
 * @since 2011. 4. 15.
 */
public class FileDownloader {

    /** 파일 확장자별 MIME 저장 */
    private MimeProvider mimes = new MimeProvider();


    /** 파일을 다운로드 한다. */
    public void download(HttpServletResponse response, String fullFileName, boolean inline, String dispositionFileName) {
        String contentType = getContentType(fullFileName);
        download(response, contentType, fullFileName, inline, dispositionFileName);
    }

    /** 파일을 다운로드 한다. */
    public void download(HttpServletResponse response, String contentType, String fullFileName, boolean inline, String dispositionFileName) {
        try {
            File file = new File(fullFileName);
            int size = (int)file.length();

            String filename = new String(dispositionFileName.getBytes("euc-kr"), "8859_1");

            response.reset();
            response.setContentType(contentType);

            response.setHeader("Content-Disposition", (inline ? "inline" : "attachment") + "; filename=\"" +filename + "\"");
            response.setHeader("Content-Transfer-Encoding", "binary");
            response.setContentLength(size);

            FileInputStream fis = new FileInputStream(file);
            BufferedInputStream bis = new BufferedInputStream(fis);
            BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());

            byte buf[] = new byte[1024*1024];//new byte[fileSize];
            int read = 0;
            while((read = bis.read(buf)) != -1) {
                bos.write(buf, 0, read);
            }
            bis.close();
            bos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /** 확장자별 mime 추가 */
    public void addContentType(String ext, String mime) {
        mimes.addMimeType(ext, mime);
    }

    /** 파일이름의 확장자로 mime 을 결정한다. */
    public String getContentType(String fileName) {
        return mimes.getMimeType(fileName);
    }

    /** html 메세지 보냄 */
    public void sendMessage(HttpServletResponse response, String title, String message) {
        try {
            response.setContentType("text/html; charset=utf-8");
            response.getWriter().println("<html>");
            response.getWriter().println("<head>");
            response.getWriter().println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            if(title != null) {
                response.getWriter().println("<title>" + title + "</title>");
            }
            response.getWriter().println("</head>");
            response.getWriter().println("<body>");
            response.getWriter().println(message);
            response.getWriter().println("</body>");
            response.getWriter().println("</html>");
            response.getWriter().println("");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
