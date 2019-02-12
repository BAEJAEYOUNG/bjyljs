package ksid.biz.ocuuser.comm;

import java.util.Map;

public class OcuUserFunc {

    public static Map<String, Object> setSpCustParam(String cust, Map<String, Object> param) {

        if(cust.equalsIgnoreCase("sdu")) {



        } else if(cust.equalsIgnoreCase("ocucons")) {

            param.put("spCd", "P0003");
            param.put("custId", "C000022");

        }

        return param;

    }

}
