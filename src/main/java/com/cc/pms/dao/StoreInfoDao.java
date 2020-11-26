package com.cc.pms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.StoreInfo;

public interface StoreInfoDao {
	
	//展示所有门店列表
	public List<StoreInfo> getAllStoreInfo();
	//展示选中门店信息
	public StoreInfo getStoreInfoById(Integer id);
	//新增门店信息
	public Integer addNewStoreInfo(StoreInfo storeInfo);
	//批量删除门店信息
	public Integer deleteStoreInfoBatch(List<Integer> storeInfoIds);
	//单个删除门店信息
	public Integer deleteStoreInfoById(Integer id);
	//模糊搜索门店信息
	public List<StoreInfo> getDataBySearch(@Param("searchData")String searchData);
}
