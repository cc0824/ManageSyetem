package com.cc.pms.bean;
/**
 * DailyData：每日数据，用于LSTM
 * @author cc
 *
 */

import java.time.LocalDate;

public class DailyData {
	private Integer salesId;
	private Integer inventorySize;//库存量
	private String inboundCost;//进货价
	private Integer salesSize;//销售量
	private String salesPrice;//销售价
	private LocalDate salesTime;//销售时间
	private Integer dayOfWeek;//星期几
	private Integer dayOfYear;//每年第几天
	public Integer getSalesId() {
		return salesId;
	}
	public void setSalesId(Integer salesId) {
		this.salesId = salesId;
	}
	public Integer getInventorySize() {
		return inventorySize;
	}
	public void setInventorySize(Integer inventorySize) {
		this.inventorySize = inventorySize;
	}
	public String getInboundCost() {
		return inboundCost;
	}
	public void setInboundCost(String inboundCost) {
		this.inboundCost = inboundCost;
	}
	public Integer getSalesSize() {
		return salesSize;
	}
	public void setSalesSize(Integer salesSize) {
		this.salesSize = salesSize;
	}
	public String getSalesPrice() {
		return salesPrice;
	}
	public void setSalesPrice(String salesPrice) {
		this.salesPrice = salesPrice;
	}
	public LocalDate getSalesTime() {
		return salesTime;
	}
	public void setSalesTime(LocalDate salesTime) {
		this.salesTime = salesTime;
	}
	
	
	public Integer getDayOfWeek() {
		return dayOfWeek;
	}
	public void setDayOfWeek(Integer dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}
	public Integer getDayOfYear() {
		return dayOfYear;
	}
	public void setDayOfYear(Integer dayOfYear) {
		this.dayOfYear = dayOfYear;
	}
	@Override
	public String toString() {
		return "[inventorySize="+inventorySize+",inboundCost="+inboundCost+",salesSize="+salesSize+
				",salesPrice="+salesPrice+",salesTime="+salesTime+",dayOfWeek="+dayOfWeek+"]";
	}
	public DailyData() {
		super();
		// TODO Auto-generated constructor stub
	}
	public DailyData(Integer inventorySize, String inboundCost, Integer salesSize, String salesPrice, Integer dayOfWeek,
			Integer dayOfYear) {
		super();
		this.inventorySize = inventorySize;
		this.inboundCost = inboundCost;
		this.salesSize = salesSize;
		this.salesPrice = salesPrice;
		this.dayOfWeek = dayOfWeek;
		this.dayOfYear = dayOfYear;
	}
	public DailyData(double inventorySize, double inboundCost, double salesSize, double salesPrice, double dayOfWeek,
			double dayOfYear) {
		super();
		this.inventorySize = (int)inventorySize;
		this.inboundCost = String.valueOf(inboundCost);
		this.salesSize = (int)salesSize;
		this.salesPrice = String.valueOf(salesPrice);
		this.dayOfWeek = (int)dayOfWeek;
		this.dayOfYear = (int)dayOfYear;
	}
	
	
	
	

}
