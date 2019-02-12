/*
 *
 */
package ksid.biz.product.custfixbill.service;

import java.util.List;
import java.util.Map;

import ksid.core.webmvc.base.service.BaseService;

/**
 *
 * @author Administrator
 */
public interface CustFixBillService extends BaseService<Map<String, Object>> {

    public int insDataMulti(Map<String, Object> param);
    public int updDataMulti(Map<String, Object> param);

}
