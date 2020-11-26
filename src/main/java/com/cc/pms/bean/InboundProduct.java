package com.cc.pms.bean;

import java.time.LocalDateTime;

/**
 * 	入库商品记录表tb_inbound
 * @author 18379
 *
 */
public class InboundProduct {
	private Integer inboundId;//主键
	private Integer productId;//关联的商品id
	private Integer inboundNum;//入库记录单编号—同一批出库商品该编号相同
	private String inboundCost;//入库价格—统一为进货价

	private Integer inboundSize;//入库商品的数量
	private String inboundTotal;//该批入库商品总金额
	private String inboundTime;//该批次商品的入库时间
	private Integer messageId;//关联的入库申请消息id,tb_message中messageType为消息类型 1入库  2出库
	
	private Integer inboundFlag;//标志位，0表示没有完成库存变动操作，1表示已完成
	
	private Product product;//关联查询到
	
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
