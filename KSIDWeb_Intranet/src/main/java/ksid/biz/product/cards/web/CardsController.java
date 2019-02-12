/*
 *
 */
package ksid.biz.product.cards.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import ksid.biz.product.cards.service.CardsService;
import ksid.core.webmvc.base.web.BaseController;

/**
 *
 * @author Administrator
 */
@Controller
@RequestMapping("product/cards")
public class CardsController extends BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(CardsController.class);

    @Autowired
    private CardsService cardsService;

    @RequestMapping(value= {""})
    public String view(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CardsController.view param [{}]", param);

        return "product/cards";
    }

    @RequestMapping(value= {"list"})
    public String list(@RequestParam Map<String, Object> param, Model model) {

        logger.debug("CardsController.list param [{}]", param);

        List<Map<String, Object>> resultData = this.cardsService.selDataList(param);

        logger.debug("CardsController.list resultData [{}]", resultData);

        model.addAttribute("resultCd", "00");
        model.addAttribute("resultData", resultData);

        return "json";
    }

    @RequestMapping(value= {"get"}, consumes = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody Map<String, Object> get(@RequestBody Map<String, Object> param) {

        logger.debug("CardsController.getSerial param [{}]", param);

        Map<String, Object> rtnMap = new HashMap<String, Object>();
        Map<String, Object> cardsMap = new HashMap<String, Object>();

        try {

            if(false == param.containsKey("customer")) {
                rtnMap.put("result", "01");
                rtnMap.put("serialNo", "");
                rtnMap.put("resultMsg", "customer is required");
            } else {

                String serialNo = (String)this.cardsService.selValue("selSerialNo", param);

                rtnMap.put("result", "00");
                rtnMap.put("serialNo", serialNo);

                logger.debug("CardsController.getSerial rtnMap [{}]", rtnMap);

                if( serialNo.equals("") ) {

                    rtnMap.put("result", "02");
                    rtnMap.put("serialNo", "");
                    rtnMap.put("resultMsg", "customer code is not correct");

                } else {

                    cardsMap.put("serialNo", serialNo);
                    cardsMap.put("cardsCustCd", serialNo.substring(0, 4));
                    cardsMap.put("cardsIssueYear", "20" + serialNo.substring(4, 6));
                    cardsMap.put("cardsIssueTp", serialNo.substring(6, 8));

                    this.cardsService.insData(cardsMap);

                }

            }

            logger.debug("ClientController.insReg rtnMap [{}]", rtnMap);

        } catch (Exception e) {
            rtnMap.put("result", "99");
            rtnMap.put("serialNo", "");
            rtnMap.put("resultMsg", "error - " + e.getMessage());
            e.printStackTrace();
        }



        return rtnMap;

    }

    @RequestMapping(value= {"getWeb"})
    public @ResponseBody Map<String, Object> getWeb(@RequestParam Map<String, Object> param) {

        logger.debug("CardsController.getSerial param [{}]", param);

        Map<String, Object> rtnMap = new HashMap<String, Object>();
        Map<String, Object> cardsMap = new HashMap<String, Object>();

        try {

            if(false == param.containsKey("customer")) {
                rtnMap.put("result", "01");
                rtnMap.put("serialNo", "");
                rtnMap.put("resultMsg", "customer is required");
            } else {

                String serialNo = (String)this.cardsService.selValue("selSerialNo", param);

                rtnMap.put("result", "00");
                rtnMap.put("serialNo", serialNo);

                logger.debug("CardsController.getSerial rtnMap [{}]", rtnMap);

                if( serialNo.equals("") ) {

                    rtnMap.put("result", "02");
                    rtnMap.put("serialNo", "");
                    rtnMap.put("resultMsg", "customer code is not correct");

                } else {

                    cardsMap.put("serialNo", serialNo);
                    cardsMap.put("cardsCustCd", serialNo.substring(0, 4));
                    cardsMap.put("cardsIssueYear", "20" + serialNo.substring(4, 6));
                    cardsMap.put("cardsIssueTp", serialNo.substring(6, 8));

                    this.cardsService.insData(cardsMap);

                }

            }

            logger.debug("ClientController.insReg rtnMap [{}]", rtnMap);

        } catch (Exception e) {
            rtnMap.put("result", "99");
            rtnMap.put("serialNo", "");
            rtnMap.put("resultMsg", "error - " + e.getMessage());
            e.printStackTrace();
        }



        return rtnMap;

    }

    @RequestMapping(value= {"reg"}, consumes = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody Map<String, Object> reg(@RequestBody Map<String, Object> param) {

        logger.debug("CardsController.getSerial param [{}]", param);

        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {

            if(false == param.containsKey("serialNo")) {
                rtnMap.put("result", "01");
                rtnMap.put("resultMsg", "serialNo is required");
            } else if(false == param.containsKey("cardsSt")) {
                rtnMap.put("result", "02");
                rtnMap.put("resultMsg", "cardsSt is required");
            } else {

                rtnMap.put("cardsSt", (String)param.get("cardsSt"));

                this.cardsService.updData(param);

                rtnMap.put("result", "00");
                rtnMap.put("resultMsg", "success");
            }

        } catch (Exception e) {
            rtnMap.put("result", "99");
            rtnMap.put("resultMsg", "fail - " + e.getMessage());
        }

        logger.debug("ClientController.insReg rtnMap [{}]", rtnMap);

        return rtnMap;

    }


}
