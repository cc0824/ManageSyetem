package com.cc.pms.bean;
/**
 * 	ÕÛ¿Û
 * @author cc
 *
 */
public class Discount {
	private Integer discountId;
	private Integer discountType;//ÕÛ¿ÛÀàĞÍ£º0ÊÇÂú¼õÕÛ¿Û£¬1ÊÇÂòÔùÕÛ¿Û
	
	
	public Integer getDiscountId() {
		return discountId;
	}
	public void setDiscountId(Integer discountId) {
		this.discountId = discountId;
	}
	public Integer getDiscountType() {
		return discountType;
	}
	public void setDiscountType(Integer discountType) {
		this.discountType = discountType;
	}
	
	@Override
	public String toString() {
		return "discountId="+discountId+",discountType="+discountType;
	}
	
	

}
