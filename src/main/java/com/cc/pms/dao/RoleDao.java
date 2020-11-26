package com.cc.pms.dao;

import java.util.List;

import com.cc.pms.bean.Role;

public interface RoleDao {
	public Role getRoleById(Integer id);
	
	public Role getRoleByUserId(Integer id);
	
	public List<Role> getAllRole();
	
	public List<Role> getAllRoleWithMenu();

}
