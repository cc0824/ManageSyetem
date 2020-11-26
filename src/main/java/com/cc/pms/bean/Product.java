package com.cc.pms.bean;

import java.util.List;

/**
 * @Document:
 * 		String indexName(); //索引库的名称，个人建议以项目的名称命名
 * 		String type() default “”; //类型，个人建议以实体的名称命名
 * 		short shards() default 5; //默认分区数
 * 		short replicas() default 1; //每个分区默认的备份数
 * 		String refreshInterval() default “1s”; //刷新间隔
 * @author cc
 *
 */
public class Product {
	private Integer productId;
	private String productName;
	private String productCost;//使用string类型接受小数，输入为null时，默认为0.0
	private String productPrice;
	private String productArea;
	
	private List<SaleInf> saleInfs;//一个商品有多个销售信息
	
	
	public List<SaleInf> getSaleInfs() {
		return saleInfs;
	}
	public void setSaleInfs(List<SaleInf> saleInfs) {
		this.saleInfs = saleInfs;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public String getProductCost() {
		return productCost;
	}
	public void setProductCost(String productCost) {
		this.productCost = productCost;
	}
	public String getProductPrice() {
		return productPrice;
	}
	public void setProductPrice(String productPrice) {
		this.productPrice = productPrice;
	}
	public String getProductArea() {
		return productArea;
	}
	public void setProductArea(String productArea) {
		this.productArea = productArea;
	}
	public Product(Integer productId, String productName, String productCost, String productPrice, String productArea) {
		super();
		this.productId = productId;
		this.productName = productName;
		this.productCost = productCost;
		this.productPrice = productPrice;
		this.productArea = productArea;
	}
	public Product() {
		super();
		// TODO Auto-generated constructor stub
	}
	@Override
	public String toString() {
		return "Product[productId=" +productId+ 
				",productName=" +productName+ 
				",productCost=" +productCost+ 
				",productPrice=" +productPrice+ 
				",productArea=" +productArea+ "]";
				
	}


}
