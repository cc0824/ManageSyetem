package com.cc.pms.bean;

import java.time.LocalDateTime;

/**
 * 	�����Ʒ��¼��tb_inbound
 * @author 18379
 *
 */
public class InboundProduct {
	private Integer inboundId;//����
	private Integer productId;//��������Ʒid
	private Integer inboundNum;//����¼����š�ͬһ��������Ʒ�ñ����ͬ
	private String inboundCost;//���۸�ͳһΪ������

	private Integer inboundSize;//�����Ʒ������
	private String inboundTotal;//���������Ʒ�ܽ��
	private String inboundTime;//��������Ʒ�����ʱ��
	private Integer messageId;//���������������Ϣid,tb_message��messageTypeΪ��Ϣ���� 1���  2����
	
	private Integer inboundFlag;//��־λ��0��ʾû����ɿ��䶯������1��ʾ�����
	
	private Product product;//������ѯ��
	
	public Product getProduct() {
		return product;
	}


	public void setProduct(Product product) {
		this.product = product;
	}


	public Integer getInboundFlag() {
		return inboundFlag;
	}


	public void setInboundFlag(Integer inboundFlag) {
		this.inboundFlag = inboundFlag;
	}


	public Integer getInboundNum() {
		return inboundNum;
	}
	
	
	public void setInboundNum(Integer inboundNum) {
		this.inboundNum = inboundNum;
	}
	
	
	public String getInboundTime() {
		return inboundTime;
	}
	
	
	public void setInboundTime(String inboundTime) {
		this.inboundTime = inboundTime;
	}
	
	
	public InboundProduct() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	public InboundProduct(Integer inboundId, Integer productId, Integer inboundNum, String inboundCost,
			Integer inboundSize, String inboundTotal, String inboundTime,Integer messageId,Integer inboundFlag) {
		super();
		this.inboundId = inboundId;
		this.productId = productId;
		this.inboundNum = inboundNum;
		this.inboundCost = inboundCost;
		this.inboundSize = inboundSize;
		this.inboundTotal = inboundTotal;
		this.inboundTime=inboundTime;
		this.messageId = messageId;
		this.inboundFlag=inboundFlag;
	}
	

	public Integer getProductId() {
		return productId;
	}


	public void setProductId(Integer productId) {
		this.productId = productId;
	}


	public Integer getInBoundNum() {
		return inboundNum;
	}


	public void setInBoundNum(Integer inBoundNum) {
		this.inboundNum = inBoundNum;
	}




	public Integer getMessageId() {
		return messageId;
	}


	public void setMessageId(Integer messageId) {
		this.messageId = messageId;
	}


	public Integer getInboundId() {
		return inboundId;
	}
	public void setInboundId(Integer inboundId) {
		this.inboundId = inboundId;
	}
	public String getInboundCost() {
		return inboundCost;
	}
	public void setInboundCost(String inboundCost) {
		this.inboundCost = inboundCost;
	}
	public Integer getInboundSize() {
		return inboundSize;
	}
	public void setInboundSize(Integer inboundSize) {
		this.inboundSize = inboundSize;
	}
	public String getInboundTotal() {
		return inboundTotal;
	}
	public void setInboundTotal(String inboundTotal) {
		this.inboundTotal = inboundTotal;
	}
	
	@Override
	public String toString() {
		return "Inbound[inboundId=" +inboundId+ 
				",productId=" +productId+ 
				",inBoundNum" + inboundNum+
				",inboundCost=" +inboundCost+ 
				",inboundSize=" +inboundSize+ 
				",inboundTotal=" +inboundTotal+ 
				",inboundTime="+inboundTime+
				",messageId"+ messageId +
				",inboundFlag"+ inboundFlag+ 
				",product"+ product +"]";
	}
	
	
	
	
	
	
	
}
