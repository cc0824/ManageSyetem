package com.cc.pms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.Menu;

public interface MenuDao {
	
	/**
	 * 1.չʾ�˵�
	 */
	public List<Menu> getMenuByRoleId(Integer roleId);
	/**
	 * 2.����pid��ѯ��Ӧ�Ӳ˵�
	 */
	public List<Menu> getMenuByParentId(Integer parentId);
	
	public List<Menu> getAllMenus();
	
	public List<Menu> getSearchMenu(@Param("menuName")String searchData);
	
}
