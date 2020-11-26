package com.cc.pms.bean;
/**
 * 	销售数据
 * @author cc
 *
 */

import java.time.LocalDate;
import java.util.Date;

public class SaleInf {
	private Integer salesId;//数据库id
	private Integer salesSize;//销售数量
	private LocalDate salesTime;//销售时间
	private Integer salesNum;//销售单编号
	private String salesPrice;//单件商品销售价格
	private Integer salesPayType;//顾客付款类型
	
	private Integer pId;//关联的商品
	private Product product;
	
	private Integer discountId;//关联的折扣
	private Discount discount;
	

	public Integer getSalesId() {
		return salesId;
	}


	public void setSalesId(Integer salesId) {
		this.salesId = salesId;
	}


	public Integer getSalesSize() {
		return salesSize;
	}


	public void setSalesSize(Integer salesSize) {
		this.salesSize = salesSize;
	}


	public LocalDate getSalesTime() {
		return salesTime;
	}


	public void setSalesTime(LocalDate salesTime) {
		this.salesTime = salesTime;
	}


	public Integer getSalesNum() {
		return salesNum;
	}


	public void setSalesNum(Integer salesNum) {
		this.salesNum = salesNum;
	}


	public String getSalesPrice() {
		return salesPrice;
	}


	public void setSalesPrice(String salesPrice) {
		this.salesPrice = salesPrice;
	}


	public Integer getSalesPayType() {
		return salesPayType;
	}


	public void setSalesPayType(Integer salesPayType) {
		this.salesPayType = salesPayType;
	}




	public Integer getpId() {
		return pId;
	}


	public void setpId(Integer pId) {
		this.pId = pId;
	}


	public Product getProduct() {
		return product;
	}


	public void setProduct(Product product) {
		this.product = product;
	}


	public Integer getDiscountId() {
		return discountId;
	}


	public void setDiscountId(Integer discountId) {
		this.discountId = discountId;
	}


	public Discount getDiscount() {
		return discount;
	}


	public void setDiscount(Discount discount) {
		this.discount = discount;
	}


	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return "salesId="+salesId+",salesSize="+salesSize+",salesTime="+salesTime
				+",salesNum="+salesNum+",salesPrice="+salesPrice+",salesPayType="+salesPayType
				+",pId="+pId+",product="+product;
	}


	public SaleInf(Integer salesId, Integer salesSize, LocalDate salesTime, Integer salesNum, String salesPrice,
			Integer salesPayType, Integer pId, Product product, Integer discountId, Discount discount) {
		super();
		this.salesId = salesId;
		this.salesSize = salesSize;
		this.salesTime = salesTime;
		this.salesNum = salesNum;
		this.salesPrice = salesPrice;
		this.salesPayType = salesPayType;
		this.pId = pId;
		this.product = product;
		this.discountId = discountId;
		this.discount = discount;
	}


	public SaleInf() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	

}
