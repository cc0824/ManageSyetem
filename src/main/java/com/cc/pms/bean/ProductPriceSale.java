package com.cc.pms.bean;

/**
 * @Document:智能分析模块使用
 * @author cc
 *
 */
public class ProductPriceSale {
	private Integer productId;
	private String productName;
	private String productCost;//进货价
	private Integer productCostSale;//进货量
	private String productPrice;//销售价
	private Integer productPriceSale;//销售量
	
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
