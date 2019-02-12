/*
 *
 */
package ksid.biz.registration.user.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ksid.biz.devauth.mobileauth.service.impl.MobileAuthDao;
import ksid.biz.registration.user.service.UserService;
import ksid.core.webmvc.base.web.BaseController;
import ksid.core.webmvc.util.ConstantDefine;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("registration/user")
public class UserController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private MobileAuthDao mobileAuthDao;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.view param [{}]", param);

        return "registration/user";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.userService.selDataList(param);

        logger.debug("UserController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"sel"})
    public String sel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.sel param [{}]", param);

        Map<String, Object> resultData = this.userService.selData(param);

        logger.debug("UserController.sel resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"ins"})
    public String ins(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.ins param [{}]", param);

        int resultData = this.userService.insData(param);

        logger.debug("UserController.ins resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "insert success !");

        return "json";
    }

    @RequestMapping(value= {"upd"})
    public String upd(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.upd param [{}]", param);

        int resultData = this.userService.updData(param);

        logger.debug("UserController.upd resultData {}", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", "update success !");

        return "json";
    }

    @RequestMapping(value= {"del"})
    public String del(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.del param {}", param);

        //금결원데모사용자 가입
        String mpNo = StringUtils.defaultString((String)param.get("mpNo"));
        //OCU데모사용자가입
        String mpNoStr = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

        if(mpNo.length() < 10 && mpNoStr.length() > 0 ) {
            param.put("mpNo", mpNoStr);
        }

        String strResult = this.userService.callProc("deleteUserAll", param);

        logger.debug("UserController.del deleteUserAll strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "delete success !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }


//    ------------------------------------------------------------------------------------------------------
//    PROCEDURE             Mapper           URL          기능 및 파일
//    ------------------------------------------------------------------------------------------------------
//    P_USER_CANCEL     : cancelUser     : deregUser    : 가입해지 요청
//    P_USER_JOIN_AFTER : joinUserAfter  : reg          : 후불가입 + 서비스 가입 요청  (user.jsp) 팝업
//    P_USER_JOIN_PAYPG : joinUserPayPg  : reg          : 선불가입 요청                (user.jsp) 팝업
//    P_USER_DEL        : deleteUser     : delUser      : 고객사의 사용자 삭제 요청
//    P_SERV_JOIN_PAYPG : joinServPayPg  : regServPg    : 선불가입 요청                (user.jsp) 팝업
//    P_SERV_DEL        : deleteServ     : delServ      : 서비스삭제 요청 (custproduserbill.jsp)
//    P_USER_CANCEL_ALL : cancelUserAll  : cancel       : 사용자 해지 요청 (user.jsp)
//    P_SERV_CANCEL_ALL : cancelServAll  : deregServ    : 서비스해지 요청 (custproduserbill.jsp)
//    P_USER_DEL_ALL    : deleteUserAll  : del          : 사용자 삭제 요청 (user.jsp)
//    ------------------------------------------------------------------------------------------------------

    @RequestMapping(value= {"cancel"})
    public String cancel(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.cancel param {}", param);

        //jiyun : change procedure
        //int resultData = this.userService.delData(param);
        //logger.debug("UserController.del resultData {}", resultData);
        //model.addAttribute("resultCd", "00");
        //model.addAttribute("resultData", "termination success !");

        //금결원데모사용자 가입
        String mpNo = StringUtils.defaultString((String)param.get("mpNo"));
        //OCU데모사용자가입
        String mpNoStr = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

        if(mpNo.length() < 10 && mpNoStr.length() > 0 ) {
            param.put("mpNo", mpNoStr);
        }

        String strResult = this.userService.callProc("cancelUserAll", param);

        logger.debug("UserController.cancel cancelUserAll strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "termination success !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }

    //사용자 가입 (선불일경우 사용자 정보만 등록, 후불일경우 사용자와 서비스상품 등록)
    @RequestMapping(value= {"reg"})
    public String reg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.reg param [{}]", param);

        String strResult = null;
        String servId = null;

        //선불,후불 가입 체크 필요 2017-04-19 추가
        servId = StringUtils.defaultString((String)param.get("servId"));
        if(servId.length() == 0) {
            model.addAttribute( "resultCd", ConstantDefine.SQL_RFAIL );
            model.addAttribute("resultData", "서비스아이디 길이 에러");
            return "json";
        } else {
            Map<String, Object> custFixBillData = this.userService.selectCustFixBill(param);
            if(custFixBillData == null) {
                model.addAttribute( "resultCd", ConstantDefine.SQL_RFAIL );
                model.addAttribute("resultData", "고객사 서비스 상품 미존재");
                return "json";
            } else {

                //금결원데모사용자 가입
                String mpNo = StringUtils.defaultString((String)param.get("mpNo"));
                //OCU데모사용자가입
                String mpNoStr = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

                if(mpNo.length() < 10 && mpNoStr.length() > 0 ) {
                    param.put("mpNo", mpNoStr);
                }

                //핸드폰 OS
                String phoneOs = StringUtils.defaultString((String)param.get("phoneOs"));
                if(phoneOs.length() < 1) {
                    param.put("phoneOs", "");
                }

                String payFg = StringUtils.defaultString((String)custFixBillData.get("payFg"));
                //P:선불, A:후불
                if( "P".equals(payFg) ) {
                    logger.debug("UserController.reg 선불 서비스 가입 [{}]", payFg);
                    strResult = this.userService.callProc("joinUserPayPg", param);
                } else {
                    logger.debug("UserController.reg 후불 서비스 가입 [{}]", payFg);
                    strResult = this.userService.callProc("joinUserAfter", param);
                }
            }
        }

        logger.debug("UserController.reg strResult : {}", strResult);

        // 모바일 장비 인증 삭제 2017-04-10 추가
//        String rstStr = mobileAuthDao.mobileAuthDelJob(param);
//        if( rstStr.equals(ConstantDefine.SQL_ROK ) ) {
//            model.addAttribute("resultCd", ConstantDefine.SQL_ROK );
//            model.addAttribute("resultData", "인증번호 삭제 성공");
//        }
//        else {
//            model.addAttribute("resultCd", ConstantDefine.SQL_RFAIL );
//            model.addAttribute("resultData", "인증번호 삭제 실패");
//        }

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "정상처리 되었습니다 !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }


    //선불 가입자에 결제한 서비스 상품 등록
    @RequestMapping(value= {"regServPg"})
    public String regServPg(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.regServPg param [{}]", param);

        String strResult = null;
        String servId = null;

        //선불,후불 가입 체크 필요 2017-04-19 추가
        servId = StringUtils.defaultString((String)param.get("servId"));
        if(servId.length() == 0) {
            model.addAttribute( "resultCd", ConstantDefine.SQL_RFAIL );
            model.addAttribute("resultData", "서비스아이디 길이 에러");
            return "json";
        } else {
            Map<String, Object> custFixBillData = this.userService.selectCustFixBill(param);
            if(custFixBillData == null) {
                model.addAttribute( "resultCd", ConstantDefine.SQL_RFAIL );
                model.addAttribute("resultData", "고객사 서비스 상품 미존재");
                return "json";
            } else {
                //금결원데모사용자 가입
                String mpNo = StringUtils.defaultString((String)param.get("mpNo"));
                //OCU데모사용자가입
                String mpNoStr = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

                if(mpNo.length() < 10 && mpNoStr.length() > 0 ) {
                    param.put("mpNo", mpNoStr);
                }

                strResult = this.userService.callProc("joinServPayPg", param);
            }
        }

        logger.debug("UserController.regServPg strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "정상처리 되었습니다 !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }

    //결제한 서비스 상품 해지
    @RequestMapping(value= {"deregServ"})
    public String deregServ(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.deregServ param [{}]", param);

        String strResult = null;
        String servId = null;

        servId = StringUtils.defaultString((String)param.get("servId"));
        if(servId.length() == 0) {
            model.addAttribute( "resultCd", ConstantDefine.SQL_RFAIL );
            model.addAttribute("resultData", "서비스아이디 길이 에러");
            return "json";
        } else {
            Map<String, Object> custFixBillData = this.userService.selectCustFixBill(param);
            if(custFixBillData == null) {
                model.addAttribute( "resultCd", ConstantDefine.SQL_RFAIL );
                model.addAttribute("resultData", "고객사 서비스 상품 미존재");
                return "json";
            } else {
                //금결원데모사용자 가입
                String mpNo = StringUtils.defaultString((String)param.get("mpNo"));
                //OCU데모사용자가입
                String mpNoStr = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

                if(mpNo.length() < 10 && mpNoStr.length() > 0 ) {
                    param.put("mpNo", mpNoStr);
                }

                strResult = this.userService.callProc("cancelServAll", param);
            }
        }

        logger.debug("UserController.deregServ strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "정상처리 되었습니다 !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }

    //가입자 해지 처리
    @RequestMapping(value= {"deregUser"})
    public String deregUser(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.deregUser param [{}]", param);

        //금결원데모사용자 가입
        String mpNo = StringUtils.defaultString((String)param.get("mpNo"));
        //OCU데모사용자가입
        String mpNoStr = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

        if(mpNo.length() < 10 && mpNoStr.length() > 0 ) {
            param.put("mpNo", mpNoStr);
        }

        String strResult = this.userService.callProc("cancelUser", param);

        logger.debug("UserController.deregUser strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "정상처리 되었습니다 !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }

    //가입자 삭제 처리
    @RequestMapping(value= {"delUser"})
    public String delUser(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.delUser param [{}]", param);

        //금결원데모사용자 가입
        String mpNo = StringUtils.defaultString((String)param.get("mpNo"));
        //OCU데모사용자가입
        String mpNoStr = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

        if(mpNo.length() < 10 && mpNoStr.length() > 0 ) {
            param.put("mpNo", mpNoStr);
        }

        List<Map<String, Object>> selListData1 = mobileAuthDao.selDataList( "selUserRegCheck", param );
        if( selListData1.size() != 1  ) {
            logger.debug("UserId Select Fail");
            return( ConstantDefine.SQL_RFAIL );
        }

        param.put( "userId", StringUtils.defaultString((String)selListData1.get(0).get("userId")) );

        logger.debug("param UserId : [{}]",     param.get("userId"));
        logger.debug("param custUserNo : [{}]", param.get("custUserNo"));

        String strResult = this.userService.callProc("deleteUser", param);

        logger.debug("UserController.delUser strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
            model.addAttribute("resultData", "정상처리 되었습니다 !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }

    //서비스 삭제 처리
    @RequestMapping(value= {"delServ"})
    public String delServ(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("UserController.delServ param [{}]", param);

        //금결원데모사용자 가입
        String mpNo = StringUtils.defaultString((String)param.get("mpNo"));
        //OCU데모사용자가입
        String mpNoStr = (String) param.get("spNo") + (String) param.get("kookBun") + (String) param.get("junBun");

        if(mpNo.length() < 10 && mpNoStr.length() > 0 ) {
            param.put("mpNo", mpNoStr);
        }

        String strResult = this.userService.callProc("deleteServ", param);

        logger.debug("UserController.delServ strResult {}", strResult);

        String[] arrResult = strResult.split("\\|");

        if( "00".equals(arrResult[0]) ) {
            model.addAttribute("resultCd", "00");
//            model.addAttribute("resultData", "정상처리 되었습니다 !");
        } else {
            model.addAttribute("resultCd", arrResult[0]);
            model.addAttribute("resultData", arrResult[1]);
        }

        return "json";
    }

    @RequestMapping(value= {"excel"})
    public void excel(HttpServletRequest request, HttpServletResponse response) {
        try {
            this.userService.excelDownload(request, response, "selUserList");
        } catch(Exception e) {

        }
    }
}
