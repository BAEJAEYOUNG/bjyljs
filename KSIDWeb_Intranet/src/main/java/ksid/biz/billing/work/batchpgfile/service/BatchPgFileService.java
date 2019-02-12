/*
 *
 */
package ksid.biz.billing.work.batchpgfile.service;

import java.util.Map;

import ksid.core.webmvc.base.service.BaseService;

/**
 *
 * @author Administrator
 */
public interface BatchPgFileService extends BaseService<Map<String, Object>> {

    Map<String, Object> getPgFileHis(Map<String, Object> param);
}
