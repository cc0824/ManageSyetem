package com.cc.pms.dao;

import java.util.List;

import com.cc.pms.bean.MyMessage;

public interface MessageDao {
	public void addMessage(MyMessage myMessage);
	public List<MyMessage> getMessage();
	public void updateDisplayState(Integer id); 
	public List<MyMessage> getAllInboundMessage();
	public void deleteMessageById(Integer id);
	public void deleteMessageByIds(List<Integer> ids);
	public MyMessage getSelectMessageDetail(Integer id);
	public MyMessage getLastMessageId();
	public List<MyMessage> getMessageByUserName(String userName);
}
