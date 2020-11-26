package com.cc.pms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.StoreInfo;

public interface StoreInfoDao {
	
	//չʾ�����ŵ��б�
	public List<StoreInfo> getAllStoreInfo();
	//չʾѡ���ŵ���Ϣ
	public StoreInfo getStoreInfoById(Integer id);
	//�����ŵ���Ϣ
	public Integer addNewStoreInfo(StoreInfo storeInfo);
	//����ɾ���ŵ���Ϣ
	public Integer deleteStoreInfoBatch(List<Integer> storeInfoIds);
	//����ɾ���ŵ���Ϣ
	public Integer deleteStoreInfoById(Integer id);
	//ģ�������ŵ���Ϣ
	public List<StoreInfo> getDataBySearch(@Param("searchData")String searchData);
}
