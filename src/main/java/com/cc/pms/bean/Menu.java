package com.cc.pms.bean;

import java.util.List;

public class Menu {
	private Integer menuId;
	private String menuName;
	private String menuIcon;
	private Integer pId;//父节点
	private String menuUrl;//路径
	private Integer menuState;//访问状态
	
	private List<Role> roleList;//关联的表
	
	public Integer getMenuId() {
		return menuId;
	}
	public void setMenuId(Integer menuId) {
		this.menuId = menuId;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	public String getMenuIcon() {
		return menuIcon;
	}
	public void setMenuIcon(String menuIcon) {
		this.menuIcon = menuIcon;
	}
	public Integer getpId() {
		return pId;
	}
	public void setpId(Integer pId) {
		this.pId = pId;
	}
	public String getMenuUrl() {
		return menuUrl;
	}
	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}
	public Integer getMenuState() {
		return menuState;
	}
	public void setMenuState(Integer menuState) {
		this.menuState = menuState;
	}
	public Menu(Integer menuId, String menuName, String menuIcon, Integer pId, String menuUrl, Integer menuState) {
		super();
		this.menuId = menuId;
		this.menuName = menuName;
		this.menuIcon = menuIcon;
		this.pId = pId;
		this.menuUrl = menuUrl;
		this.menuState = menuState;
	}
	public Menu() {
		super();
	}
	
	
	public List<Role> getRoleList() {
		return roleList;
	}
	public void setRoleList(List<Role> roleList) {
		this.roleList = roleList;
	}
	
	@Override
	public String toString() {
		
		return "menuId:"+menuId+",menuName:"+menuName+",menuUrl:"+menuUrl;
	}
	
	
	
	
	
	

}
