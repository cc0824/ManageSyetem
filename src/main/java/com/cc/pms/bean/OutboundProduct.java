package com.cc.pms.bean;

import java.time.LocalDateTime;

/**
 * 	出库商品记录表tb_outbound
 * @author 18379
 *
 */
public class OutboundProduct {
	private Integer outboundId;//主键
	private Integer productId;//关联的商品id
	private Integer outboundNum;//出库记录单编号—同一批出库商品该编号相同
	private float outboundCost;//出库价格—门店调货为进货价，摆上货架出售为销售价
	private Integer outboundSize;//出库商品的数量
	private float outboundTotal;//该批出库商品总金额
	private LocalDateTime outboundTime;//该批次商品的出库时间
	private Integer messageId;//关联的出库申请消息id,tb_message中messageType为消息类型 1入库  2出库
	
	
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
