/*
 *
 */
package ksid.biz.billing.work.sftp.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class SftpServDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_SftpServ";
    }

    @Override
    protected String getMapperId() {

        return "SftpServ";
    }

}
