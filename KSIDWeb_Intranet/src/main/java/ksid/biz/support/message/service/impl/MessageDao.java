/*
 *
 */
package ksid.biz.support.message.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import ksid.core.webmvc.base.service.impl.BaseDao;

/**
 *
 * @author Administrator
 */
@Repository
public class MessageDao extends BaseDao<Map<String, Object>> {

    @Override
    protected String getNameSpace() {

        return "NS_Message";
    }

    @Override
    protected String getMapperId() {

        return "Message";
    }

}
