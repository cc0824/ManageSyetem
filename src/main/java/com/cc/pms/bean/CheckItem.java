package com.cc.pms.bean;

public class CheckItem {
	private Integer inventoryCheckItemId;//表id
	private Integer inventoryCheckProductId;//关联商品id
	private Integer inventoryCheckProductExpectedSize;//盘点商品预期库存
	private Integer inventoryCheckProductActualSize;//盘点商品实际库存
	private Integer inventoryCheckState;//盘点状态：正常1、盘盈3、盘亏2
	private Integer inventoryCheckId;
	
	private Product product;
	
	public Product getProduct() {
		return product;
	}
	public void setProduct(Product product) {
		this.product = product;
	}
	public Integer getInventoryCheckItemId() {
		return inventoryCheckItemId;
	}
	public void setInventoryCheckItemId(Integer inventoryCheckItemId) {
		this.inventoryCheckItemId = inventoryCheckItemId;
	}
	public Integer getInventoryCheckProductId() {
		return inventoryCheckProductId;
	}
	public void setInventoryCheckProductId(Integer inventoryCheckProductId) {
		this.inventoryCheckProductId = inventoryCheckProductId;
	}
	public Integer getInventoryCheckProductExpectedSize() {
		return inventoryCheckProductExpectedSize;
	}
	public void setInventoryCheckProductExpectedSize(Integer inventoryCheckProductExpectedSize) {
		this.inventoryCheckProductExpectedSize = inventoryCheckProductExpectedSize;
	}
	public Integer getInventoryCheckProductActualSize() {
		return inventoryCheckProductActualSize;
	}
	public void setInventoryCheckProductActualSize(Integer inventoryCheckProductActualSize) {
		this.inventoryCheckProductActualSize = inventoryCheckProductActualSize;
	}
	public Integer getInventoryCheckState() {
		return inventoryCheckState;
	}
	public void setInventoryCheckState(Integer inventoryCheckState) {
		this.inventoryCheckState = inventoryCheckState;
	}
	public Integer getInventoryCheckId() {
		return inventoryCheckId;
	}
	public void setInventoryCheckId(Integer inventoryCheckId) {
		this.inventoryCheckId = inventoryCheckId;
	}
	public CheckItem() {
		super();
		// TODO Auto-generated constructor stub
	}
	public CheckItem(Integer inventoryCheckItemId, Integer inventoryCheckProductId,
			Integer inventoryCheckProductExpectedSize, Integer inventoryCheckProductActualSize,
			Integer inventoryCheckState, Integer inventoryCheckId, Product product) {
		super();
		this.inventoryCheckItemId = inventoryCheckItemId;
		this.inventoryCheckProductId = inventoryCheckProductId;
		this.inventoryCheckProductExpectedSize = inventoryCheckProductExpectedSize;
		this.inventoryCheckProductActualSize = inventoryCheckProductActualSize;
		this.inventoryCheckState = inventoryCheckState;
		this.inventoryCheckId = inventoryCheckId;
		this.product = product;
	}
	@Override
	public String toString() {
		return "CheckItem [inventoryCheckItemId=" + inventoryCheckItemId + ", inventoryCheckProductId="
				+ inventoryCheckProductId + ", inventoryCheckProductExpectedSize=" + inventoryCheckProductExpectedSize
				+ ", inventoryCheckProductActualSize=" + inventoryCheckProductActualSize + ", inventoryCheckState="
				+ inventoryCheckState + ", inventoryCheckId=" + inventoryCheckId + ", product=" + product + "]";
	}
	
	

}
