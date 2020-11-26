package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.Role;

public interface RoleService {
	public Role getRoleById(Integer id);
	
	public Role getRoleByUserId(Integer id);
	
	public List<Role> getAllRole();
	
	public List<Role> getAllRoleWithMenu();

}
