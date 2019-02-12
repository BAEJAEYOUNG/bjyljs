package ksid.biz.support.message.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.support.message.service.MessageService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("messageService")
public class MessageServiceImpl extends BaseServiceImpl<Map<String, Object>> implements MessageService {

    @Autowired
    private MessageDao messageDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.messageDao;
    }

}
