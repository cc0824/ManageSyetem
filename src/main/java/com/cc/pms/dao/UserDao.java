package com.cc.pms.dao;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.User;
public interface UserDao {
	/**
	 * 用户登陆
	 * @param user_name
	 * @param user_password
	 * @return 找到返回user对象，没有则返回Null
	 */
	public User getUser(Map<String, Object> map);
	/**
	 * 用户注册
	 * @param user
	 */
	public void addUser(User user);
	/**
	 * 通过用户名查询用户
	 * @param userName
	 * @return
	 */
	public User getByUserName(String userName);
	
	public List<User> getEmpByStoreId(Integer id);
	
	public User getUserWithRoleById(Integer id);
	
	/**
	 * *用户管理模块
	 * 1.展示用户信息
	 */
	public List<User> getAllUserList();
	/**
	 * *用户管理模块
	 * 2.展示用户角色信息
	 */
	public List<User> getAllUserListWithRole();
	
	public User getSelectUserById(Integer id);
	
	public List<User> getDataBySearch(@Param("searchData")String searchData);
	public List<String> getIPBySearch(@Param("inputData")String inputData);
	



			


}
