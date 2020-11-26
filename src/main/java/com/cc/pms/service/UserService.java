package com.cc.pms.service;

import java.util.List;
import java.util.Map;

import com.cc.pms.bean.User;

public interface UserService{

	/**
	 * 登陆 返回实体
	 * 多个参数用map封装
	 * @param map
	 * @return
	 */
	public User getUser(Map<String,Object> map);
	/**
	 * 注册
	 * @param user
	 * @return
	 */
	public void addUser(User user);
	/**
	 * 通过用户名查询用户是否存在
	 * 
	 */
	public User getByUserName(String userName);
	
	public List<User> getEmpByStoreId(Integer id);
	
	public User getUserWithRoleById(Integer id);
	
	/**
	 * *用户管理模块
	 */
	public List<User> getAllUserList();
	
	public List<User> getAllUserListWithRole();
	
	public User getSelectUserById(Integer id);

	public List<User> getDataBySearch(String searchData);
	public List<String> getIPBySearch(String inputData);
}
