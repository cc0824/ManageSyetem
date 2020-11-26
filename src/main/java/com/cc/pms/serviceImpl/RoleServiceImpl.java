package com.cc.pms.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.Role;
import com.cc.pms.dao.RoleDao;
import com.cc.pms.service.RoleService;
@Service("roleService")
public class RoleServiceImpl implements RoleService{
	@Autowired
	private RoleDao roleDao;
	
	public Role getRoleById(Integer id) {
		return roleDao.getRoleById(id);
	}
	public Role getRoleByUserId(Integer id) {
		return roleDao.getRoleByUserId(id);
	}
	
	public List<Role> getAllRole(){
		return roleDao.getAllRole();
	}
	
	public List<Role> getAllRoleWithMenu(){
		return roleDao.getAllRoleWithMenu();
	}

}
