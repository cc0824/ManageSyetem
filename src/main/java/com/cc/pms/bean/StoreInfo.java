package com.cc.pms.bean;

import java.util.List;

/**
 * 门店信息实体
 * @author 18379
 *
 */
public class StoreInfo {
	private Integer Id;//表主键
	private Integer storeNum;//门店编号
	private String storeName;//门店名称
	private String storeAddress;//门店地址
	private Integer storePostCode;//门店邮编
	
	private List<User> employee;//查门店信息同时查询到员工信息
	
	
	public List<User> getEmployee() {
		return employee;
	}
	public void setEmployee(List<User> employee) {
		this.employee = employee;
	}
	
	public StoreInfo(Integer id, Integer storeNum, String storeName, String storeAddress, Integer storePostCode,
			List<User> employee) {
		super();
		Id = id;
		this.storeNum = storeNum;
		this.storeName = storeName;
		this.storeAddress = storeAddress;
		this.storePostCode = storePostCode;
		this.employee = employee;
	}
	@Override
	public String toString() {
		return "当前门店信息：Id="+Id+",storeNum="+storeNum+",storeName="+storeName+",storeAddress="+storeAddress
				+",storePostCode="+storePostCode;
	}
	public Integer getId() {
		return Id;
	}
	public void setId(Integer id) {
		Id = id;
	}
	public Integer getStoreNum() {
		return storeNum;
	}
	public void setStoreNum(Integer storeNum) {
		this.storeNum = storeNum;
	}
	public String getStoreName() {
		return storeName;
	}
	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}
	public String getStoreAddress() {
		return storeAddress;
	}
	public void setStoreAddress(String storeAddress) {
		this.storeAddress = storeAddress;
	}
	public Integer getStorePostCode() {
		return storePostCode;
	}
	public void setStorePostCode(Integer storePostCode) {
		this.storePostCode = storePostCode;
	}
	public StoreInfo(Integer id, Integer storeNum, String storeName, String storeAddress, Integer storePostCode) {
		super();
		Id = id;
		this.storeNum = storeNum;
		this.storeName = storeName;
		this.storeAddress = storeAddress;
		this.storePostCode = storePostCode;
	}
	public StoreInfo() {
		super();
	}
	
	
	

}
