package com.cc.pms.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.MyMessage;
import com.cc.pms.dao.MessageDao;
import com.cc.pms.service.MessageService;

@Service("messageService")
public class MessageServiceImpl implements MessageService{
	@Autowired
	private MessageDao messageDao;
	
	public void addMessage(MyMessage myMessage) {
		messageDao.addMessage(myMessage);
	}
	public List<MyMessage>  getMessage() {
		return messageDao.getMessage();
		
	}
	public void updateDisplayState(Integer id) {
		messageDao.updateDisplayState(id);
	}
	public List<MyMessage> getAllInboundMessage(){
		return messageDao.getAllInboundMessage();
		
	}
	public void deleteMessageById(Integer id) {
		messageDao.deleteMessageById( id);
	}
	public void deleteMessageByIds(List<Integer> ids) {
		messageDao.deleteMessageByIds(ids);
	}
	public MyMessage getSelectMessageDetail(Integer id) {
		return messageDao.getSelectMessageDetail(id);
	}
	public MyMessage getLastMessageId() {
		return messageDao.getLastMessageId();
	}
	@Override
	public List<MyMessage> getMessageByUserName(String userName) {
		return messageDao.getMessageByUserName(userName);
	}
	
}
