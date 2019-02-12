package ksid.biz.common.file.service.impl;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Repository;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import ksid.core.webmvc.base.service.impl.BaseDao;

@Repository
public class FileDAO extends BaseDao<Map<String, Object>> {


    @Override
    protected String getNameSpace() {

        return "NS_File";
    }

    @Override
    protected String getMapperId() {

        return "File";
    }

    public int updDataFile(String sqlId, Map<String, Object> param) {

        int i = 0;

        try {
            if (param instanceof Map) {
                this.setSessionData((Map<String, Object>)param);

                logger.debug("BaseDao.updData param [{}]", param);
            }

            i = getSqlSession().update(sqlId, param);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);

            throw new RuntimeException(String.format("%s 데이터 수정 오류", sqlId));
        }

        return i;

    }

    @SuppressWarnings("unchecked")
    private void setSessionData(Map<String, Object> param) {

        ServletRequestAttributes requestAttributes = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();

        if (null == requestAttributes) {
            return;
        }

        HttpSession session = requestAttributes.getRequest().getSession();

        Map<String, Object> sessionUser = (Map<String, Object>)session.getAttribute("sessionUser");
        logger.debug("sessionUser [{}]", sessionUser);

        if (sessionUser != null) {
            if (!param.containsKey("regId")) {
                param.put("regId", (String)sessionUser.get("adminId"));
            }
            if(!param.containsKey("chgId")) {
                param.put("chgId", (String)sessionUser.get("adminId"));
            }
        }
    }

}
