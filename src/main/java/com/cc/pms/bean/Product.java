package com.cc.pms.bean;

import java.util.List;

/**
 * @Document:
 * 		String indexName(); //����������ƣ����˽�������Ŀ����������
 * 		String type() default ����; //���ͣ����˽�����ʵ�����������
 * 		short shards() default 5; //Ĭ�Ϸ�����
 * 		short replicas() default 1; //ÿ������Ĭ�ϵı�����
 * 		String refreshInterval() default ��1s��; //ˢ�¼��
 * @author cc
 *
 */
public class Product {
	private Integer productId;
	private String productName;
	private String productCost;//ʹ��string���ͽ���С��������Ϊnullʱ��Ĭ��Ϊ0.0
	private String productPrice;
	private String productArea;
	
	private List<SaleInf> saleInfs;//һ����Ʒ�ж��������Ϣ
	
	
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
