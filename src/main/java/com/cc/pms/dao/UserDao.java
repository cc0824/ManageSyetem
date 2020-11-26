package com.cc.pms.dao;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.User;
public interface UserDao {
	/**
	 * �û���½
	 * @param user_name
	 * @param user_password
	 * @return �ҵ�����user����û���򷵻�Null
	 */
	public User getUser(Map<String, Object> map);
	/**
	 * �û�ע��
	 * @param user
	 */
	public void addUser(User user);
	/**
	 * ͨ���û�����ѯ�û�
	 * @param userName
	 * @return
	 */
	public User getByUserName(String userName);
	
	public List<User> getEmpByStoreId(Integer id);
	
	public User getUserWithRoleById(Integer id);
	
	/**
	 * *�û�����ģ��
	 * 1.չʾ�û���Ϣ
	 */
	public List<User> getAllUserList();
	/**
	 * *�û�����ģ��
	 * 2.չʾ�û���ɫ��Ϣ
	 */
	public List<User> getAllUserListWithRole();
	
	public User getSelectUserById(Integer id);
	
	public List<User> getDataBySearch(@Param("searchData")String searchData);
	public List<String> getIPBySearch(@Param("inputData")String inputData);
	



			


}
