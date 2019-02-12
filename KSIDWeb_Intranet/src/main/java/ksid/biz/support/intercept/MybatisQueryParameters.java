package ksid.biz.support.intercept;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

@Intercepts({ @Signature(type = Executor.class, method = "query", args = { MappedStatement.class, Object.class,
        RowBounds.class, ResultHandler.class }) })
public class MybatisQueryParameters implements Interceptor {

    protected static final Logger logger = LoggerFactory.getLogger(MybatisQueryParameters.class);

    @SuppressWarnings("unchecked")
    @Override
    public Object intercept(Invocation invocation) throws Throwable {

        logger.debug("MybatisQueryParameters.intercept invocation[{}]", invocation);

        Object oldParameter = invocation.getArgs()[1];

        Map<String, Object> newParameter = null;

        if (oldParameter instanceof java.util.Map) {
            newParameter = (Map<String, Object>) oldParameter;
        } else {
            newParameter = new HashMap<String, Object>();

            if (oldParameter != null) {
                newParameter.put("default", oldParameter);
            }
        }

        ServletRequestAttributes requestAttributes = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();
        logger.debug("MybatisQueryParameters.intercept requestAttributes [{}]", requestAttributes);

        if (ObjectUtils.allNotNull(requestAttributes)) {
            String language = RequestContextUtils.getLocale(requestAttributes.getRequest()).getLanguage();
            logger.debug("MybatisQueryParameters.intercept language [{}]", language);
            newParameter.put("language", "kr");

            HttpSession session = requestAttributes.getRequest().getSession();

            Map<String, Object> sessionUser = (Map<String, Object>)session.getAttribute("sessionUser");
            logger.debug("MybatisQueryParameters.intercept sessionUser [{}]", sessionUser);

            if (ObjectUtils.allNotNull(sessionUser)) {
                if(!newParameter.containsKey("regId")) {
                    newParameter.put("regId", (String)sessionUser.get("adminId"));
                }
                if(!newParameter.containsKey("chgId")) {
                    newParameter.put("chgId", (String)sessionUser.get("adminId"));
                }
            }
        }

        invocation.getArgs()[1] = newParameter;

        return invocation.proceed();
    }

    @Override
    public Object plugin(Object target) {

        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {

    }
}