package com.cc.pms.bean;

import java.util.List;

/**
 * 用户实体类
 * @author cc
 *
 */
@SuppressWarnings("serial")
public class User {

	private Integer userId;
	private String userName;
	private String userPassword;
	private Integer storeId;
	
	//联合查询到的门店信息
	private StoreInfo storeInfo;
	
	//联合查询到的角色信息
	private List<Role> roleList;
	
	//生成有参无参构造器
	public User() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	


	public User(Integer userId, String userName, String userPassword, Integer storeId, StoreInfo storeInfo,
			List<Role> roleList) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.userPassword = userPassword;
		this.storeId = storeId;
		this.storeInfo = storeInfo;
		this.roleList = roleList;
	}




	public List<Role> getRoleList() {
		return roleList;
	}




	public void setRoleList(List<Role> roleList) {
		this.roleList = roleList;
	}




	public StoreInfo getStoreInfo() {
		return storeInfo;
	}

	public void setStoreInfo(StoreInfo storeInfo) {
		this.storeInfo = storeInfo;
	}

	public Integer getStoreId() {
		return storeId;
	}

	public void setStoreId(Integer storeId) {
		this.storeId = storeId;
	}
	
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	
	




	@Override
	public String toString() {
		return "[userName:"+userName+",userPassword:"+userPassword+",roleName:"+roleList+"]";
	}
	

}
