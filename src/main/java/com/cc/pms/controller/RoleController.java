package com.cc.pms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Role;
import com.cc.pms.bean.User;
import com.cc.pms.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
@RequestMapping("/role")
public class RoleController {
	@Autowired
	private RoleService roleService;
	
	/**
	 * *角色管理中查询到所有角色种类
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/getAllRole",method=RequestMethod.GET)
	public Msg getAllRole() throws Exception{
		List<Role> roleList=roleService.getAllRole();
		return Msg.success().add("roleList",roleList);
	}
	
	/**
	 * *展示所有角色及对应权限信息
	 * 
	 */
	@ResponseBody
	@RequestMapping(value="/getAllRoleWithMenu",method=RequestMethod.GET)
	public Msg getAllRoleWithMenu(@RequestParam(value="pn",defaultValue="1")Integer pn) throws Exception{
		PageHelper.startPage(pn, 10);
		List<Role> roleListWithMenu = roleService.getAllRoleWithMenu();
		System.out.println(roleListWithMenu);
		PageInfo page=new PageInfo(roleListWithMenu,5);
		return Msg.success().add("pageInfo", page);
	}

}
