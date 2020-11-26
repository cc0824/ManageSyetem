package com.cc.pms.bean;

import java.time.LocalDate;

public class TreeModelData {
	private Integer tmdId;
	private Integer pId;//商品id
	private String productName;//商品名称
	private String inboundCost;//进货价
	private Integer inboundSize;//进货量
	private Integer inventorySize;//库存量
	private String salesPrice;//销量价
	private Integer salesSize;//销售量
	private String profit;//利润
	private LocalDate time;//时间
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "TreeModelData [tmdId=" + tmdId + ", pId=" + pId + ", productName=" + productName + ", inboundCost="
				+ inboundCost + ", inboundSize=" + inboundSize + ", inventorySize=" + inventorySize + ", salesPrice="
				+ salesPrice + ", salesSize=" + salesSize + ", profit=" + profit + ", time=" + time + "]";
	}
	/**
	 * @return the tmdId
	 */
	public Integer getTmdId() {
		return tmdId;
	}
	/**
	 * @param tmdId the tmdId to set
	 */
	public void setTmdId(Integer tmdId) {
		this.tmdId = tmdId;
	}
	/**
	 * @return the pId
	 */
	public Integer getpId() {
		return pId;
	}
	/**
	 * @param pId the pId to set
	 */
	public void setpId(Integer pId) {
		this.pId = pId;
	}
	/**
	 * @return the productName
	 */
	public String getProductName() {
		return productName;
	}
	/**
	 * @param productName the productName to set
	 */
	public void setProductName(String productName) {
		this.productName = productName;
	}
	/**
	 * @return the inboundCost
	 */
	public String getInboundCost() {
		return inboundCost;
	}
	/**
	 * @param inboundCost the inboundCost to set
	 */
	public void setInboundCost(String inboundCost) {
		this.inboundCost = inboundCost;
	}
	/**
	 * @return the inboundSize
	 */
	public Integer getInboundSize() {
		return inboundSize;
	}
	/**
	 * @param inboundSize the inboundSize to set
	 */
	public void setInboundSize(Integer inboundSize) {
		this.inboundSize = inboundSize;
	}
	/**
	 * @return the inventorySize
	 */
	public Integer getInventorySize() {
		return inventorySize;
	}
	/**
	 * @param inventorySize the inventorySize to set
	 */
	public void setInventorySize(Integer inventorySize) {
		this.inventorySize = inventorySize;
	}
	/**
	 * @return the salesPrice
	 */
	public String getSalesPrice() {
		return salesPrice;
	}
	/**
	 * @param salesPrice the salesPrice to set
	 */
	public void setSalesPrice(String salesPrice) {
		this.salesPrice = salesPrice;
	}
	/**
	 * @return the salesSize
	 */
	public Integer getSalesSize() {
		return salesSize;
	}
	/**
	 * @param salesSize the salesSize to set
	 */
	public void setSalesSize(Integer salesSize) {
		this.salesSize = salesSize;
	}
	/**
	 * @return the profit
	 */
	public String getProfit() {
		return profit;
	}
	/**
	 * @param profit the profit to set
	 */
	public void setProfit(String profit) {
		this.profit = profit;
	}
	/**
	 * @return the time
	 */
	public LocalDate getTime() {
		return time;
	}
	/**
	 * @param time the time to set
	 */
	public void setTime(LocalDate time) {
		this.time = time;
	}
	public TreeModelData(Integer tmdId, Integer pId, String productName, String inboundCost, Integer inboundSize,
			Integer inventorySize, String salesPrice, Integer salesSize, String profit, LocalDate time) {
		super();
		this.tmdId = tmdId;
		this.pId = pId;
		this.productName = productName;
		this.inboundCost = inboundCost;
		this.inboundSize = inboundSize;
		this.inventorySize = inventorySize;
		this.salesPrice = salesPrice;
		this.salesSize = salesSize;
		this.profit = profit;
		this.time = time;
	}
	public TreeModelData() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	

}
