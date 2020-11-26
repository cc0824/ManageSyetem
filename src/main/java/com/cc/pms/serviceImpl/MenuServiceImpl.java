package com.cc.pms.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.Menu;
import com.cc.pms.dao.MenuDao;
import com.cc.pms.service.MenuService;

@Service("menuService")
public class MenuServiceImpl implements MenuService{
	@Autowired
	private MenuDao menuDao;
	
	/**
	 * 1.展示父菜单
	 */
	public List<Menu> getMenuByRoleId(Integer roleId) {
		return menuDao.getMenuByRoleId(roleId);
	}
	/**
	 * 2.依据pid查询对应子菜单
	 */
	public List<Menu> getMenuByParentId(Integer parentId){
		return menuDao.getMenuByParentId(parentId);
	}
	
	public List<Menu> getAllMenus(){
		return menuDao.getAllMenus();
	}
	
	public List<Menu> getSearchMenu(String searchData){
		return menuDao.getSearchMenu(searchData);
	}
}
