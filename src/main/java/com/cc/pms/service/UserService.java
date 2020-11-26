package com.cc.pms.service;

import java.util.List;
import java.util.Map;

import com.cc.pms.bean.User;

public interface UserService{

	/**
	 * ��½ ����ʵ��
	 * ���������map��װ
	 * @param map
	 * @return
	 */
	public User getUser(Map<String,Object> map);
	/**
	 * ע��
	 * @param user
	 * @return
	 */
	public void addUser(User user);
	/**
	 * ͨ���û�����ѯ�û��Ƿ����
	 * 
	 */
	public User getByUserName(String userName);
	
	public List<User> getEmpByStoreId(Integer id);
	
	public User getUserWithRoleById(Integer id);
	
	/**
	 * *�û�����ģ��
	 */
	public List<User> getAllUserList();
	
	public List<User> getAllUserListWithRole();
	
	public User getSelectUserById(Integer id);

	public List<User> getDataBySearch(String searchData);
	public List<String> getIPBySearch(String inputData);
}
