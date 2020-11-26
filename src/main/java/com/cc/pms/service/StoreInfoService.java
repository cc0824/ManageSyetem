package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.StoreInfo;

public interface StoreInfoService {
	public List<StoreInfo> getAllStoreInfo();
	public StoreInfo getStoreInfoById(Integer id);
	public Integer addNewStoreInfo(StoreInfo storeInfo);
	public Integer deleteStoreInfoBatch(List<Integer> storeInfoIds);
	public Integer deleteStoreInfoById(Integer id);
	
	public List<StoreInfo> getDataBySearch(String searchData);

}
