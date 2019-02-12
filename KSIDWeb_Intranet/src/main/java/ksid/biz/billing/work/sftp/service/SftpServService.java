/*
 *
 */
package ksid.biz.billing.work.sftp.service;

import java.util.Map;

import ksid.biz.billing.work.sftp.service.impl.SFTPUtil;
import ksid.core.webmvc.base.service.BaseService;

/**
 *
 * @author Administrator
 */
public interface SftpServService extends BaseService<Map<String, Object>> {

    public SFTPUtil init(Map<String, Object> param);

}
