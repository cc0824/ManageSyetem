package com.cc.pms.bean;

import java.time.LocalDateTime;

/**
 * 	������Ʒ��¼��tb_outbound
 * @author 18379
 *
 */
public class OutboundProduct {
	private Integer outboundId;//����
	private Integer productId;//��������Ʒid
	private Integer outboundNum;//�����¼����š�ͬһ��������Ʒ�ñ����ͬ
	private float outboundCost;//����۸��ŵ����Ϊ�����ۣ����ϻ��ܳ���Ϊ���ۼ�
	private Integer outboundSize;//������Ʒ������
	private float outboundTotal;//����������Ʒ�ܽ��
	private LocalDateTime outboundTime;//��������Ʒ�ĳ���ʱ��
	private Integer messageId;//�����ĳ���������Ϣid,tb_message��messageTypeΪ��Ϣ���� 1���  2����
	
	
	public Integer getOutboundId() {
		return outboundId;
	}
	public void setOutBoundId(Integer outboundId) {
		this.outboundId = outboundId;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public Integer getOutboundNum() {
		return outboundNum;
	}
	public void setOutboundNum(Integer outboundNum) {
		this.outboundNum = outboundNum;
	}
	public float getOutboundCost() {
		return outboundCost;
	}
	public void setOutboundCost(float outboundCost) {
		this.outboundCost = outboundCost;
	}
	public Integer getOutboundSize() {
		return outboundSize;
	}
	public void setOutboundSize(Integer outboundSize) {
		this.outboundSize = outboundSize;
	}
	public float getOutboundTotal() {
		return outboundTotal;
	}
	public void setOutboundTotal(float inboundTotal) {
		this.outboundTotal = inboundTotal;
	}
	public Integer getMessageId() {
		return messageId;
	}
	public void setMessageId(Integer messageId) {
		this.messageId = messageId;
	}
	public OutboundProduct(Integer outboundId, Integer productId, Integer outboundNum, float outboundCost,
			Integer outboundSize, float outboundTotal, Integer messageId) {
		super();
		this.outboundId = outboundId;
		this.productId = productId;
		this.outboundNum = outboundNum;
		this.outboundCost = outboundCost;
		this.outboundSize = outboundSize;
		this.outboundTotal = outboundTotal;
		this.messageId = messageId;
	}
	public OutboundProduct() {
		super();
	}
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return "["+ ",outboundId"+outboundId+",outboundNum"+outboundNum
				+",outboundCost"+outboundCost+",outboundSize"+outboundSize
				+",outboundTotal"+outboundTotal+",productId"+productId
				+"messageId"+messageId+"]";
	}
	
	

}
