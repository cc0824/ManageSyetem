package com.cc.pms.bean;
/**
 * 	�ۿ�
 * @author cc
 *
 */
public class Discount {
	private Integer discountId;
	private Integer discountType;//�ۿ����ͣ�0�������ۿۣ�1�������ۿ�
	
	
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
