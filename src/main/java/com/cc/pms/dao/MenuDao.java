package com.cc.pms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.Menu;

public interface MenuDao {
	
	/**
	 * 1.展示菜单
	 */
	public List<Menu> getMenuByRoleId(Integer roleId);
	/**
	 * 2.依据pid查询对应子菜单
	 */
	public List<Menu> getMenuByParentId(Integer parentId);
	
	public List<Menu> getAllMenus();
	
	public List<Menu> getSearchMenu(@Param("menuName")String searchData);
	
}
