package com.cc.pms.bean;

import java.util.List;

/**
 * �ŵ���Ϣʵ��
 * @author 18379
 *
 */
public class StoreInfo {
	private Integer Id;//������
	private Integer storeNum;//�ŵ���
	private String storeName;//�ŵ�����
	private String storeAddress;//�ŵ��ַ
	private Integer storePostCode;//�ŵ��ʱ�
	
	private List<User> employee;//���ŵ���Ϣͬʱ��ѯ��Ա����Ϣ
	
	
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
		return "��ǰ�ŵ���Ϣ��Id="+Id+",storeNum="+storeNum+",storeName="+storeName+",storeAddress="+storeAddress
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
