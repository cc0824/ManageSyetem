package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.CheckItem;
import com.cc.pms.bean.Inventory;
import com.cc.pms.bean.Product;

public interface InventoryService {
	public List<Inventory> getAllInventory();
	
	public List<Inventory> getDataBySearch(String searchData);
	
	public List<Product> getExistInventory(String inventoryName);
	
	public void addNewInventory(Inventory inventory);
	
	public void updateInventorySizeById(Integer productId,Integer size);

	public List<CheckItem> getAllCheckProductByCheckSheet(int inventoryCheckId);

	public List<CheckItem> getAllCheckInfoByCheckState(int inventoryCheckState,int inventoryCheckId);
	
	
}
