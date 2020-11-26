package com.cc.pms.controller;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cc.pms.bean.Menu;
import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Role;
import com.cc.pms.service.MenuService;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;


@Controller
@RequestMapping("/menu")
public class MenuController {
	
	@Autowired
	private MenuService menuService;
	
	/**
	 * *依据角色查询到所有菜单信息，遍历得到菜单id
	 * @param roleId
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/getMenu",method=RequestMethod.GET)
	public Msg getMenu(Integer parentId,Integer roleId,HttpSession session)throws Exception {
		Role currentRole=(Role) session.getAttribute("role");
		roleId=currentRole.getRoleId();
		List<Menu> allMenuList=menuService.getMenuByRoleId(roleId);
		//List<Integer> menuIdList=new LinkedList<Integer>();
		//for(Menu menu:allMenuList){
		//	menuIdList.add(menu.getMenuId());
		//}
		//System.out.println("当前角色的所有菜单id menuIdList===>"+menuIdList.toString());
		//依据parentId查询所有子菜单
		//List content=getAllMenuByParentId(parentId,menuIdList);
		return Msg.success().add("menuList",allMenuList);
		
	}
	public List getAllMenuByParentId(Integer parentId,List<Integer> menuIdList) {
		List<Menu> menuList=menuService.getMenuByParentId(parentId);
		System.out.println("依据pid查询子菜单menuList===>pid="+parentId+";子菜单："+menuList.toString());
		getMenuChildByParentId(parentId,menuList);
		return menuList;
	}
	public void getMenuChildByParentId(Integer parentId,List<Menu> menuList) {
		List<Menu> menuChildList=new ArrayList<Menu>();
		for(int i=0;i<menuList.size();i++) {
			//System.out.println(menuList.get(i).toString());
			parentId=menuList.get(i).getMenuId();
			menuChildList.addAll(menuService.getMenuByParentId(parentId));
		}
		System.out.println("依据pid查询子菜单menuChildList===>pid="+parentId+";子菜单："+menuChildList.toString());
		
		
	}
	
	/**
	 * *所有菜单信息
	 */
	@ResponseBody
	@RequestMapping(value="/getAllMenu",method=RequestMethod.GET)
	public Msg getAllMenu() throws Exception {
		List<Menu> allMenus=menuService.getAllMenus();
		return Msg.success().add("allMenus",allMenus);
		
	}
	/**
	 * *搜索菜单功能
	 */
	@ResponseBody
	@RequestMapping(value="/getSearchMenu",method=RequestMethod.GET)
	public Msg getSearchMenu(@RequestParam(value="searchData")String searchData) throws Exception {
		List<Menu> searchMenus=menuService.getSearchMenu(searchData);
		System.out.println("搜索到的结果："+searchMenus);
		return Msg.success().add("searchMenus",searchMenus);
	}
	
	
	

}
