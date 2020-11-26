package com.cc.pms.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.StoreInfo;
import com.cc.pms.dao.StoreInfoDao;
import com.cc.pms.service.StoreInfoService;
@Service("storeInfoService")
public class StoreInfoServiceImpl implements StoreInfoService{
	
	@Autowired
	private StoreInfoDao storeInfoDao;
	
	public List<StoreInfo> getAllStoreInfo(){
		return storeInfoDao.getAllStoreInfo();
	}
	public StoreInfo getStoreInfoById(Integer id) {
		return storeInfoDao.getStoreInfoById(id);
	}
	public Integer addNewStoreInfo(StoreInfo storeInfo) {
		return storeInfoDao.addNewStoreInfo(storeInfo);
	}
	public Integer deleteStoreInfoBatch(List<Integer> storeInfoIds) {
		return storeInfoDao.deleteStoreInfoBatch(storeInfoIds);
	}
	public Integer deleteStoreInfoById(Integer id) {
		return storeInfoDao.deleteStoreInfoById(id);
	}
	public List<StoreInfo> getDataBySearch(String searchData){
		return storeInfoDao.getDataBySearch(searchData);
	}

}
