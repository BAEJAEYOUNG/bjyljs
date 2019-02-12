package ksid.biz.support.message;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import ksid.biz.support.message.service.MessageService;
import ksid.core.webmvc.message.AbstractDatabaseMessageSource;

@Component("messageSource")
public class DatabaseMessageSource extends AbstractDatabaseMessageSource {

    protected static final Logger logger = LoggerFactory.getLogger(AbstractDatabaseMessageSource.class);

    @Autowired
    private MessageService messageService;

    @Override
    protected Messages getMessages() {

        Messages messages = new Messages();

        Map<String, Object> param = new HashMap<String, Object>();

        List<Map<String, Object>> dataList = this.messageService.selDataList(param);

        logger.debug("DatabaseMessageSource.getMessages dataList [{}]", dataList);

        for (Map<String, Object> data : dataList) {
            Locale locale = new Locale((String)data.get("language"), (String)data.get("country"));
            messages.addMessage((String)data.get("code"), locale, (String)data.get("message"));
        }

        logger.debug("DatabaseMessageSource.getMessages messages [{}]", messages);

        return messages;
    }
}
