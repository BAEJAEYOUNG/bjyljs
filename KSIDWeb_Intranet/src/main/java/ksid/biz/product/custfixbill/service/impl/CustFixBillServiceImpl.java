package ksid.biz.product.custfixbill.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.product.custfixbill.service.CustFixBillService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;
import ksid.core.webmvc.util.BaseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("custFixBillService")
public class CustFixBillServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CustFixBillService {

    @Autowired
    private CustFixBillDao custFixBillDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.custFixBillDao;
    }

    @Override
    public int insDataMulti(Map<String, Object> param) {

        int rtnVal = 0;

        JSONObject jsonMap = JSONObject.fromObject(param.get("multiData"));

        JSONObject jsonMaster = JSONObject.fromObject(param.get("master"));
        JSONArray  jsonDetail = JSONArray.fromObject(param.get("detail"));

        Map<String, Object> paramMaster = BaseUtil.toMap(jsonMaster);
        List<Map<String, Object>> paramDetail = BaseUtil.toList(jsonDetail);

        Map<String, Object> objCustFixBill = this.custFixBillDao.selData(paramMaster);
        if(objCustFixBill != null) {

            rtnVal = 1;

        } else {

            BaseUtil.printMap("jsonMaster", jsonMaster);
            BaseUtil.printListMap("paramDetail", paramDetail);

            this.custFixBillDao.insData(paramMaster);

            for (int i = 0; i < paramDetail.size(); i++) {
                this.custFixBillDao.insData("insCustCaseBill", (Map<String, Object>)paramDetail.get(i));
            }

        }

        return rtnVal;
    }

    @Override
    public int updDataMulti(Map<String, Object> param) {

        int rtnVal = 0;

        JSONObject jsonMap = JSONObject.fromObject(param.get("multiData"));

        JSONObject jsonMaster = JSONObject.fromObject(param.get("master"));
        JSONArray  jsonDetail = JSONArray.fromObject(param.get("detail"));

        Map<String, Object> paramMaster = BaseUtil.toMap(jsonMaster);
        List<Map<String, Object>> paramDetail = BaseUtil.toList(jsonDetail);

        Map<String, Object> objCustFixBill = this.custFixBillDao.selData(paramMaster);
        if(objCustFixBill != null) {

            BaseUtil.printMap("jsonMaster", jsonMaster);
            BaseUtil.printListMap("paramDetail", paramDetail);

            // 정액 자료 등록
            this.custFixBillDao.updData(paramMaster);

            // 해당 건별자료 삭제 후 등록
            this.custFixBillDao.delData("delCustCaseBill", paramMaster);
            for (int i = 0; i < paramDetail.size(); i++) {
                this.custFixBillDao.insData("insCustCaseBill", (Map<String, Object>)paramDetail.get(i));
            }

            rtnVal = 1;

        }

        return rtnVal;
    }

}
