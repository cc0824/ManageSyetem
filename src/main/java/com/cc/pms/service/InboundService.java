package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.InboundProduct;

public interface InboundService {
	public void addInbound(InboundProduct iProduct);
	
	public void updateInbooundFlag();
	
	public List<InboundProduct> getInbooundWithFlag();
	
	public void updateMessageIdByFlag(Integer messageId);
}
