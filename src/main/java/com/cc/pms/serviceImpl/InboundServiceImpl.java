package com.cc.pms.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.InboundProduct;
import com.cc.pms.dao.InboundDao;
import com.cc.pms.service.InboundService;

@Service("inboundService")
public class InboundServiceImpl implements InboundService{
	@Autowired
	private InboundDao inboundDao;
	
	public void addInbound(InboundProduct iProduct) {
		inboundDao.addInbound(iProduct);
	}
	public void updateInbooundFlag() {
		inboundDao.updateInbooundFlag();
	}
	public List<InboundProduct> getInbooundWithFlag(){
		return inboundDao.getInbooundWithFlag();
	}
	public void updateMessageIdByFlag(Integer messageId) {
		inboundDao.updateMessageIdByFlag(messageId);
	}
}
