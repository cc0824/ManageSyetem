package com.cc.pms.bean;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class MyMessage {
	private Integer messageId;
	private String messageFromUser;//发件人
	private String messageToUser;//收件人
	private Integer messageState;//消息是否未读 0  已读 1
	private String messageContent;//消息内容
	private Integer messageStateDisplay;//未读消息是否显示  0未展示  1展示
	private Integer messageType;//消息类型 1入库  2出库
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
	private Date messageTime;//操作时间

	public MyMessage() {
		super();
	}

	public MyMessage(Integer messageId, String messageFromUser, String messageToUser, Integer messageState,
			String messageContent, Integer messageStateDisplay, Integer messageType,Date messageTime) {
		super();
		this.messageId = messageId;
		this.messageFromUser = messageFromUser;
		this.messageToUser = messageToUser;
		this.messageState = messageState;
		this.messageContent = messageContent;
		this.messageStateDisplay = messageStateDisplay;
		this.messageType = messageType;
		this.messageTime=messageTime;
	}
	
	public Date getMessageTime() {
		return messageTime;
	}

	public void setMessageTime(Date messageTime) {
		this.messageTime = messageTime;
	}



	public Integer getMessageId() {
		return messageId;
	}

	public void setMessageId(Integer messageId) {
		this.messageId = messageId;
	}

	public String getMessageFromUser() {
		return messageFromUser;
	}

	public void setMessageFromUser(String messageFromUser) {
		this.messageFromUser = messageFromUser;
	}

	public String getMessageToUser() {
		return messageToUser;
	}

	public void setMessageToUser(String messageToUser) {
		this.messageToUser = messageToUser;
	}

	public Integer getMessageState() {
		return messageState;
	}

	public void setMessageState(Integer messageState) {
		this.messageState = messageState;
	}

	public String getMessageContent() {
		return messageContent;
	}

	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
	}

	public Integer getMessageStateDisplay() {
		return messageStateDisplay;
	}

	public void setMessageStateDisplay(Integer messageStateDisplay) {
		this.messageStateDisplay = messageStateDisplay;
	}

	public Integer getMessageType() {
		return messageType;
	}

	public void setMessageType(Integer messageType) {
		this.messageType = messageType;
	}

	@Override
	public String toString() {
		return "messageId:"+messageId+",state:"+messageState+",content:"+messageContent+
				",statedisplay:"+messageStateDisplay+",messageType:"+messageType+",messageDate:"+messageTime
				+",messageFromUser:"+messageFromUser+",messageToUser:"+messageToUser;
	}
	

	
	
	

}
