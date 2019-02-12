/*
 *
 */
package ksid.biz.billing.work.sftp.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;

/**
* SFTP 프로토콜을 접속 모듈
* 파일 업로드, 다운로드 기능 제공.
*/
public class SFTPUtil{

    protected static final Logger logger = LoggerFactory.getLogger(SFTPUtil.class);

    private Session session = null;

    private Channel channel = null;

    private ChannelSftp channelSftp = null;


    /**
     * 서버와 연결에 필요한 값들을 가져와 초기화 시킴
     *
     * @param host
     *            서버 주소
     * @param userName
     *            접속에 사용될 아이디
     * @param password
     *            비밀번호
     * @param port
     *            포트번호
     */
    public void init(String host, String userName, String password, int port) throws JSchException,Exception  {

        logger.debug("init host    [{}] port[{}]", host, port);
        logger.debug("init userName[{}] password[{}]", userName, password);

        JSch jsch = new JSch();
        try {
            session = jsch.getSession(userName, host, port);
            session.setPassword(password);

            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);
            session.connect();

            channel = session.openChannel("sftp");
            channel.connect();
            logger.debug("Connected !");
        } catch (JSchException e) {
            logger.debug(e.toString());
        }

        channelSftp = (ChannelSftp) channel;

    }


    /**
     * 서버의 디렉토리의 파일정보 조회
     *
     * @param path
     *            검색할 서버 디렉토리
     */
    @SuppressWarnings("unchecked")
    public Vector<ChannelSftp.LsEntry> getFileList(String path) {

        Vector<ChannelSftp.LsEntry> list = null;

//        logger.debug("getFileList serverDir [{}]", path);

        try {
            channelSftp.cd(path);
            logger.debug("pwd  serverDir [{}]", channelSftp.pwd());

            list = channelSftp.ls(".");

        } catch (SftpException e) {
            logger.debug(e.toString());
            logger.debug("SftpException found while ls serverDirectory.");
        }

        return list;
    }


    /**
     * 단일 파일을 업로드
     *
     * @param dir
     *            저장시킬 주소(서버)
     * @param file
     *            저장할 파일 경로
     */
    public boolean upload(String dir, String filePath) throws Exception{

        boolean result = true;
        FileInputStream in = null;

//        logger.debug("upload serverDir [{}]", dir);
//        logger.debug("upload filePath  [{}]", filePath);

        try {
            File file = new File(filePath);
            String fileName = file.getName();
            //fileName = URLEncoder.encode(fileName,"EUC-KR");

            in = new FileInputStream(file);

            channelSftp.cd(dir);
            channelSftp.put(in, fileName);
            logger.info("Upload successfull [{}]", fileName);
        } catch (Exception e) {
            logger.debug(e.toString());
            logger.debug("Exception found while tranfer the response.");
            result = false;
        } finally {
            try {
                in.close();
            } catch (IOException e) {
                logger.debug(e.toString());
                logger.debug("IOException found while disconnect & close.");
            }
        }

        return result;
    }



    /**
     * 단일 파일 다운로드
     *
     * @param dir
     *            저장할 경로(서버)
     * @param fileName
     *            다운로드할 파일
     * @param path
     *            저장될 공간
     */
    public boolean download(String dir, String fileName, String path) {

        boolean result = true;
        InputStream in = null;
        FileOutputStream out = null;

//        logger.debug("download serverDir [{}]", dir);
//        logger.debug("download fileName  [{}]", fileName);
//        logger.debug("download saveFile  [{}]", path);

        try {
            channelSftp.cd(dir);
            in = channelSftp.get(fileName);
        } catch (SftpException e) {
            logger.debug(e.toString());
            logger.debug("SftpException found while get fileName.");
            result = false;
        }

        try {
            out = new FileOutputStream(new File(path));
            int data, total=0;;
            byte b[] = new byte[2048];

            while((data = in.read(b, 0, 2048)) != -1) {
                total += data;
                out.write(b, 0, data);
                out.flush();
            }
            logger.info("Download successfull [{}] total[{}]", fileName, total);
        } catch (IOException e) {
            logger.debug(e.toString());
            logger.debug("IOException found while read fileName.");
            result = false;
        } finally {
            try {
                out.close();
                in.close();
            } catch (IOException e) {
                logger.debug(e.toString());
                logger.debug("IOException found while disconnect & close.");
            }
        }
        return result;
    }


    /**
     * 단일 파일 삭제
     *
     * @param dir
     *            삭제할 경로(서버)
     * @param fileName
     *            삭제할 파일
     */
    public boolean rmFile(String dir, String fileName) {

        boolean result = true;
        String  path   = null;

        path = dir + fileName;
//        logger.debug("rmFile serverDir [{}]", dir);
//        logger.debug("rmFile fileName  [{}]", fileName);

        try {
            channelSftp.rm(path);
            logger.info("Delete successfull [{}]", fileName);
        } catch (SftpException e) {
            logger.debug(e.toString());
            logger.debug("SftpException found while rm File.");
            result = false;
        }
        return result;
    }


    /**
     * 단일 파일 명칭 변경
     *
     * @param dir
     *            변경할 경로(서버)
     * @param orgFileName
     *            원본 파일
     * @param chgFileName
     *            변경할 파일
     */
    public boolean renameFile(String dir, String oldFileNm, String newFileNm) {

        boolean result = true;
        String  oldPath   = null;
        String  newPath   = null;

        oldPath = dir + oldFileNm;
        newPath = dir + newFileNm;
//        logger.debug("renameFile serverDir [{}]", dir);
//        logger.debug("renameFile oldFileNm [{}]", oldFileNm);
//        logger.debug("renameFile oldFileNm [{}]", newFileNm);

        try {
            channelSftp.rename(oldPath, newPath);
            logger.info("Rename successfull file[{}] => [{}]", oldFileNm, newFileNm);
        } catch (SftpException e) {
            logger.debug(e.toString());
            logger.debug("SftpException found while rename File.");
            result = false;
        }
        return result;
    }



    /**
     * 폴더 단위 파일 업로드
     * @param sftpWorkingDir
     *              저장할 경로(서버)
     * @param folderPath
     *              업로드할 폴더 경로
     * @return
     */
    public boolean uploadFolder(String sftpWorkingDir, String folderPath) {

        boolean result = true;

        try {
            File clsFolder = new File( folderPath );
            if( clsFolder.exists() == false ) {
                logger.debug("folder[{}] is not found", folderPath);
                result = false;
            } else {
                File [] arrFile = clsFolder.listFiles();
                for( int i = 0; i < arrFile.length; ++i ) {
                    String fileFullPath = folderPath + arrFile[i].getName();

                    result = this.upload(sftpWorkingDir, fileFullPath);
                    if( result ) {
                        logger.debug("파일업로드 성공 [{}]", fileFullPath);
                    } else {
                        logger.debug("파일업로드 실패 [{}]", fileFullPath);
                    }
                }
            }
        } catch (Exception e) {
            logger.debug(e.toString());
            result = false;
        }

        return result;
    }



    /**
     * 서버와의 연결을 끊는다.
     */
    public void disconnection() {

        channelSftp.exit();
        if(channelSftp.isConnected()) {
            channelSftp.disconnect();
        }
        channelSftp.quit();

    }



    /**
     * 폴더내 파일 다운로드
     *
     * @param dir
     *            저장할 경로(서버)
     * @param path
     *            저장될 공간
     */
    @SuppressWarnings("unchecked")
    public int downloadFolder(String dir, String path) {
        int downCnt = 0;
        try {
            Vector<ChannelSftp.LsEntry> list = channelSftp.ls(dir);
            for(ChannelSftp.LsEntry entry : list) {
                String fileName = entry.getFilename();
                if( !".".equals(fileName) && !"..".equals(fileName) ) {
                    //logger.debug("downloadFolder fullPath[{}]", path+fileName);
                    boolean downResult = this.download(dir, fileName, path+fileName);
                    if( downResult ) {
                        downCnt++;
                    }
                }
            }
        } catch (SftpException e) {
            logger.debug(e.toString());
        }

        return downCnt;
    }



    /**
     * 단일 파일 즉시 업로드
     *
     * @param sftpHost
     *              SFTP 접속 주소(host:IP)
     * @param sftpUser
     *              SFTP 접속 USER
     * @param sftpPass
     *              SFTP 접속 패스워드
     * @param sftpPort
     *              SFTP 접속 포트
     * @param sftpWorkingDir
     *              SFTP 작업 경로
     * @param fileFullPath
     *              업로드할 파일 경로
     */
    public static boolean directUpload(String sftpHost, String sftpUser, String sftpPass, int sftpPort, String sftpWorkingDir, String fileFullPath) {

        boolean result = true;

        Session session = null;
        Channel channel = null;
        ChannelSftp channelSftp = null;
        logger.debug("preparing the host information for sftp.");

        try {
            JSch jsch = new JSch();
            session = jsch.getSession(sftpUser, sftpHost, sftpPort);
            session.setPassword(sftpPass);

            // Host 연결.
            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);
            session.connect();

            // sftp 채널 연결.
            channel = session.openChannel("sftp");
            channel.connect();

            // 파일 업로드 처리.
            channelSftp = (ChannelSftp) channel;
            channelSftp.cd(sftpWorkingDir);
            File f = new File(fileFullPath);
            String fileName = f.getName();
            //fileName = URLEncoder.encode(f.getName(),"UTF-8");
            channelSftp.put(new FileInputStream(f), fileName);
        } catch (Exception e) {
             logger.debug(e.toString());
             logger.debug("Exception found while tranfer the response.");
             result = false;
        } finally {
            // sftp 채널을 닫음.
            channelSftp.exit();

            // 채널 연결 해제.
            channel.disconnect();

            // 호스트 세션 종료.
            session.disconnect();
        }

        return result;
    }



}
