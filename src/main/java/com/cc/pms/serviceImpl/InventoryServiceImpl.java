package com.cc.pms.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.CheckItem;
import com.cc.pms.bean.Inventory;
import com.cc.pms.bean.Product;
import com.cc.pms.dao.InventoryDao;
import com.cc.pms.service.InventoryService;

@Service("inventoryService")
public class InventoryServiceImpl implements InventoryService{
	@Autowired
	private InventoryDao inventoryDao;
	public List<Inventory> getAllInventory(){
		return inventoryDao.getAllInventory();
	}
	public List<Inventory> getDataBySearch(String searchData){
		return inventoryDao.getDataBySearch(searchData);
	}
	public int addInventory(Inventory inventory) {
		return inventoryDao.addInventory(inventory);
	}
	public List<Product> getExistInventory(String inventoryName){
		return inventoryDao.getExistInventory(inventoryName);
	}
	public void addNewInventory(Inventory inventory) {
		inventoryDao.addNewInventory(inventory);
	}
	public void updateInventorySizeById(Integer productId,Integer size) {
		inventoryDao.updateInventorySizeById(productId,size);
	}
	@Override
	public List<CheckItem> getAllCheckProductByCheckSheet(int inventoryCheckId) {
		return inventoryDao.getAllCheckProductByCheckSheet(inventoryCheckId);
	}
	@Override
	public List<CheckItem> getAllCheckInfoByCheckState(int inventoryCheckState,int inventoryCheckId) {
		return inventoryDao.getAllCheckInfoByCheckState(inventoryCheckState,inventoryCheckId);
	}
}
