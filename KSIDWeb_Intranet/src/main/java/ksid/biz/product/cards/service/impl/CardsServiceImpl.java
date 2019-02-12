package ksid.biz.product.cards.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ksid.biz.product.cards.service.CardsService;
import ksid.core.webmvc.base.service.impl.BaseDao;
import ksid.core.webmvc.base.service.impl.BaseServiceImpl;

@Service("cardsService")
public class CardsServiceImpl extends BaseServiceImpl<Map<String, Object>> implements CardsService {

    @Autowired
    private CardsDao cardsDao;

    public BaseDao<Map<String, Object>> getDao() {

        return this.cardsDao;
    }

}
