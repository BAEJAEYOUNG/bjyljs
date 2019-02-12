/*
 *
 */package ksid.biz.support.advice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 *
 * @author Administrator
 */
@Controller
@RestControllerAdvice
public class IntranetRestControllerAdvice {

    protected static final Logger logger = LoggerFactory.getLogger(IntranetRestControllerAdvice.class);
}
