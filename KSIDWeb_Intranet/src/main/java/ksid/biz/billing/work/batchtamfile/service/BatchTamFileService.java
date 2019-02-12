/*
 *
 */
package ksid.biz.billing.work.batchtamfile.service;

import java.util.Map;

import ksid.core.webmvc.base.service.BaseService;

/**
 *
 * @author Administrator
 */
public interface BatchTamFileService extends BaseService<Map<String, Object>> {

    Map<String, Object> getTamFileHis(Map<String, Object> param);
}
