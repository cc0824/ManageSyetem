package com.cc.pms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.CheckItem;
import com.cc.pms.bean.Inventory;
import com.cc.pms.bean.Product;


public interface InventoryDao {

	public List<Inventory> getAllInventory(); 
	/**
	 * -����there is no getter method for searchData
	 * -ԭ��ʹ��${}������#{},javabean����û��searchData������ԣ���Ҫʹ��ע�����ע��
	 * -�������ӣ�@Param("searchData")
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
