package com.cc.pms.bean;

import java.util.List;

public class Role {
	private Integer roleId;
	private String roleName;//角色名称
	
	private List<Menu> menuList;//关联的表
	
	
	public List<Menu> getMenuList() {
		return menuList;
	}
	public void setMenuList(List<Menu> menuList) {
		this.menuList = menuList;
	}
	
	
	public Integer getRoleId() {
		return roleId;
	}
	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}
	public String getRoleName() {
		return roleName;
	}
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	
	
	
	
	
	public Role(Integer roleId, String roleName) {
		super();
		this.roleId = roleId;
		this.roleName = roleName;
	}
	public Role() {
		super();
	}
	
	
	@Override
	public String toString() {
		return "[roleName="+roleName+"]";
	}
	
	
	
	
	
	
	
	
	
}
