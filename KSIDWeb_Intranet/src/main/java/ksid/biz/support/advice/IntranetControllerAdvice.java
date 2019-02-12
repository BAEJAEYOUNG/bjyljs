/*
 *
 */package ksid.biz.support.advice;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 *
 * @author Administrator
 */
@Controller
@ControllerAdvice
public class IntranetControllerAdvice {

    protected static final Logger logger = LoggerFactory.getLogger(IntranetControllerAdvice.class);

    private final String contextPathKey = "${contextPath}";

    @Autowired
    ServletContext context;

    @Resource(name = "context")
    public Properties prop;

    public String getContextPath() {

        return this.context.getContextPath();
    }

    public Map<String, Object> getConfig() {

        Map<String, Object> config = new HashMap<String, Object>();

        List<String> css = new ArrayList<String>();
        List<String> js = new ArrayList<String>();

        List<String> keys = new ArrayList<String>();
        keys.addAll(this.prop.stringPropertyNames());
        Collections.sort(keys);

        for (Object key : keys) {
            String value = this.prop.getProperty((String) key);

            if (((String)key).startsWith("css-")) {
                css.add(value);
                continue;
            }

            if (((String)key).startsWith("js-")) {
                js.add(value);
                continue;
            }

            config.put((String) key, StringUtils.replace(value, this.contextPathKey, getContextPath()));

            if (value.startsWith(this.contextPathKey)) {
                config.put(String.format("%sReal", (String) key)
                         , StringUtils.replace(value, this.contextPathKey, ""));
            }
        }

        config.put("css", css);
        config.put("js", js);

        return config;
    }

    @ModelAttribute
    public void addAttributes(Model model) {

        if (new Boolean(this.prop.getProperty("isNotUsedControllerAdvice"))) {
            return;
        }

        model.addAttribute("contextPath", getContextPath());
        model.addAttribute("config", getConfig());
    }
}
