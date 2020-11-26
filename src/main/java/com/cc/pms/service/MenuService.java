package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.Menu;

public interface MenuService {
	
	/**
	 * 1.չʾ���˵�
	 */
	public List<Menu> getMenuByRoleId(Integer roleId);
	/**
	 * 2.����pid��ѯ��Ӧ�Ӳ˵�
	 */
	public List<Menu> getMenuByParentId(Integer parentId);
	
	/**
	 * 3.չʾ���в˵�
	 */
	public List<Menu> getAllMenus();
	
	/**
	 * 4.��ѯ�˵�
	 */
	public List<Menu> getSearchMenu(String searchData);
}
