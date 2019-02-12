package ksid.biz.billing.work.sftp.service.impl;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jcraft.jsch.JSchException;

import ksid.biz.billing.work.sftp.service.SftpServService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("sftpServService")
public class SftpServServiceImpl extends BaseServiceImpl<Map<String, Object>> implements SftpServService {

    @Autowired
    private SftpServDao sftpServDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.sftpServDao;
    }

    //SFTP Session init
    @Override
    public SFTPUtil init(Map<String, Object> param) {

        boolean result  = true;
        String host     = null;
        String userName = null;
        String password = null;
        int    port = 0;

        host = StringUtils.defaultString((String)param.get("host"));
        if(host.length() == 0) { result = false; }

        userName = StringUtils.defaultString((String)param.get("userName"));
        if(userName.length() == 0) { result = false; }

        password = StringUtils.defaultString((String)param.get("password"));
        if(password.length() == 0) { result = false; }

        port     = Integer.parseInt((String)param.get("port"));
        if(port == 0) port = 1458;

        logger.debug("init.param [{}]", param);

        SFTPUtil sftpUtil = null;

        if(result) {

            sftpUtil = new SFTPUtil();
            try {
                sftpUtil.init(host, userName, password, port);
            } catch (JSchException e) {
                e.printStackTrace();
                result = false;
            } catch (Exception e) {
                e.printStackTrace();
                result = false;
            }
            if(!result) sftpUtil = null;
        }

        return sftpUtil;
    }

}
