package com.cc.pms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.InboundProduct;

public interface InboundDao {
	public void addInbound(InboundProduct iProduct);
	
	public void updateInbooundFlag();
	
	public List<InboundProduct> getInbooundWithFlag();
	
	public void updateMessageIdByFlag(@Param("messageId")Integer messageId);

}
