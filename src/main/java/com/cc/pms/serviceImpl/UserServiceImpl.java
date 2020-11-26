package com.cc.pms.serviceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.User;
import com.cc.pms.dao.UserDao;
import com.cc.pms.exception.LoginFailException;
import com.cc.pms.service.UserService;

@Service("userService")
public class UserServiceImpl implements UserService{
	@Autowired
	private UserDao userDao;	

	//�û���½
	public User getUser(Map<String,Object> map) {
		User user=userDao.getUser(map);	
		return user;
	}
	
	//�û�ע��
	public void addUser(User user) {
		userDao.addUser(user);
	}
	
	//��ѯ�û�
	public User getByUserName(String userName) {
		return userDao.getByUserName(userName);
	}
	
	public List<User> getEmpByStoreId(Integer id){
		return userDao.getEmpByStoreId(id);
	}
	
	public User getUserWithRoleById(Integer id) {
		return userDao.getUserWithRoleById(id);
	}
	/**
	 * *�û�����ģ��
	 */
	public List<User> getAllUserList(){
		return userDao.getAllUserList();
	}
	public List<User> getAllUserListWithRole(){
		return userDao.getAllUserListWithRole();
	}
	public User getSelectUserById(Integer id) {
		return userDao.getSelectUserById(id);
	}
	@Override
	public List<User> getDataBySearch(String searchData) {
		return userDao.getDataBySearch(searchData);
	}
	@Override
	public List<String> getIPBySearch(String inputData) {
		return userDao.getIPBySearch(inputData);
	}
	

}
