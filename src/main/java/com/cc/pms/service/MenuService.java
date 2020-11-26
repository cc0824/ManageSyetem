package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.Menu;

public interface MenuService {
	
	/**
	 * 1.展示父菜单
	 */
	public List<Menu> getMenuByRoleId(Integer roleId);
	/**
	 * 2.依据pid查询对应子菜单
	 */
	public List<Menu> getMenuByParentId(Integer parentId);
	
	/**
	 * 3.展示所有菜单
	 */
	public List<Menu> getAllMenus();
	
	/**
	 * 4.查询菜单
	 */
	public List<Menu> getSearchMenu(String searchData);
}
