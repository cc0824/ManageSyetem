package com.cc.pms.bean;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class MyMessage {
	private Integer messageId;
	private String messageFromUser;//������
	private String messageToUser;//�ռ���
	private Integer messageState;//��Ϣ�Ƿ�δ�� 0  �Ѷ� 1
	private String messageContent;//��Ϣ����
	private Integer messageStateDisplay;//δ����Ϣ�Ƿ���ʾ  0δչʾ  1չʾ
	private Integer messageType;//��Ϣ���� 1���  2����
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
	private Date messageTime;//����ʱ��

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
