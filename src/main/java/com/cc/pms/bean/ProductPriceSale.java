package com.cc.pms.bean;

/**
 * @Document:���ܷ���ģ��ʹ��
 * @author cc
 *
 */
public class ProductPriceSale {
	private Integer productId;
	private String productName;
	private String productCost;//������
	private Integer productCostSale;//������
	private String productPrice;//���ۼ�
	private Integer productPriceSale;//������
	
	@Override
	public String toString() {
		return "Product[productId=" +productId+ 
				",productName=" +productName+ 
				",productCost=" +productCost+ 
				",productPrice=" +productPrice+ 
				"]";
				
	}

	public ProductPriceSale() {
		super();
		// TODO Auto-generated constructor stub
	}
	


}
