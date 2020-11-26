package com.cc.pms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.CheckItem;
import com.cc.pms.bean.Inventory;
import com.cc.pms.bean.Product;


public interface InventoryDao {

	public List<Inventory> getAllInventory(); 
	/**
	 * -报错：there is no getter method for searchData
	 * -原因：使用${}而不是#{},javabean里面没有searchData这个属性，需要使用注解进行注入
	 * -解决：添加：@Param("searchData")
	 * @param searchData
	 * @return
	 */
	public List<Inventory> getDataBySearch(@Param("searchData")String searchData);
	
	public List<Product> getExistInventory(@Param("inventoryName")String inventoryName);
	
	public int addInventory(Inventory inventory);
	
	public void addNewInventory(Inventory inventory);
	
	public void updateInventorySizeById(@Param("productId")Integer productId,@Param("size")Integer size);
	
	public List<CheckItem> getAllCheckProductByCheckSheet(int inventoryCheckId);
	
	public List<CheckItem> getAllCheckInfoByCheckState(@Param("inventoryCheckState")int inventoryCheckState,@Param("inventoryCheckId")int inventoryCheckId);
}
