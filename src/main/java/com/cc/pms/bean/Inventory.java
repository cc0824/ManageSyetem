package com.cc.pms.bean;
/**
 * 	库存记录表tb_inventory
 * @author 18379
 *
 */
public class Inventory {
	private Integer inventoryId; //主键
	private Integer productId; //关联的商品id
	private Integer inventorySize;//库存数量
	private Integer inventoryMinsize;//库存下限
	private Integer inventoryMaxsize;//库存上限
	private String inventoryArea;//库存区域
	private Integer inventoryNum;//库存编号
	
	private Product product;//一对一查询到的结果
	
	private String inventoryName;//做一个假的结果集
	public String getInventoryName() {
		return inventoryName;
	}
	public void setInventoryName(String inventoryName) {
		this.inventoryName = inventoryName;
	}
	private String inboundCost;//做一个假的结果集
	public String getInboundCost() {
		return inboundCost;
	}
	public void setInboundCost(String inboundCost) {
		this.inboundCost = inboundCost;
	}
	
	
	public Inventory(Integer inventoryId, Integer productId, Integer inventorySize, Integer inventoryMinsize,
			Integer inventoryMaxsize, String inventoryArea,Integer inventoryNum,Product product) {
		super();
		this.inventoryId = inventoryId;
		this.productId = productId;
		this.inventorySize = inventorySize;
		this.inventoryMinsize = inventoryMinsize;
		this.inventoryMaxsize = inventoryMaxsize;
		this.inventoryArea = inventoryArea;
		this.inventoryNum=inventoryNum;
		this.product=product;
	}
	
	
	public Product getProduct() {
		return product;
	}


	public void setProduct(Product product) {
		this.product = product;
	}


	public Integer getInventoryId() {
		return inventoryId;
	}
	public void setInventoryId(Integer inventoryId) {
		this.inventoryId = inventoryId;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public Integer getInventorySize() {
		return inventorySize;
	}
	public void setInventorySize(Integer inventorySize) {
		this.inventorySize = inventorySize;
	}
	public Integer getInventoryMinsize() {
		return inventoryMinsize;
	}
	public void setInventoryMinsize(Integer inventoryMinsize) {
		this.inventoryMinsize = inventoryMinsize;
	}
	public Integer getInventoryMaxsize() {
		return inventoryMaxsize;
	}
	public void setInventoryMaxsize(Integer inventoryMaxsize) {
		this.inventoryMaxsize = inventoryMaxsize;
	}
	public String getInventoryArea() {
		return inventoryArea;
	}
	public void setInventoryArea(String inventoryArea) {
		this.inventoryArea = inventoryArea;
	}
	public Inventory() {
		super();
		// TODO Auto-generated constructor stub
	}
	@Override
	public String toString() {
		return "Inventory[inventoryId=" +inventoryId+ 
				",productId=" +productId+ 
				",inventorySize=" +inventorySize+ 
				",inventoryMinsize=" +inventoryMinsize+ 
				",inventoryMaxsize=" +inventoryMaxsize+ 
				",inventoryArea=" +inventoryArea+ 
				",inventoryNum=" +inventoryNum+ 
				",inventoryName=" +inventoryName+ 
				",inboundCost=" +inboundCost+ 
				"]";
	}
	public Integer getInventoryNum() {
		return inventoryNum;
	}
	public void setInventoryNum(Integer inventoryNum) {
		this.inventoryNum = inventoryNum;
	}
	
	

}
