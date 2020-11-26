package com.cc.pms.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cc.pms.bean.Menu;
import com.cc.pms.bean.Msg;
import com.cc.pms.bean.StoreInfo;
import com.cc.pms.bean.User;
import com.cc.pms.service.StoreInfoService;
import com.cc.pms.service.UserService;

@Controller
@RequestMapping("/storeInfo")
public class StoreInfoController {
	
	@Autowired
	private StoreInfoService storeInfoService;
	@Autowired
	private UserService userService;
	/**
	 * 展示所有门店信息
	 */
	@ResponseBody
	@RequestMapping(value="/getAllStoreInfo",method = RequestMethod.GET)
	public Msg getAllStoreInfo() {
		List<StoreInfo> storeInfoList=storeInfoService.getAllStoreInfo();
		System.out.println("所有门店信息="+storeInfoList);
		return Msg.success().add("storeInfoList", storeInfoList);
	}
	/**
	 * 点击编辑按钮展示选中门店信息
	 */
	@ResponseBody
	@RequestMapping(value="/getStoreInfoById",method = RequestMethod.GET)
	public Msg getStoreInfoById(Integer id) {
		System.out.println("第一次传入id="+id);
		StoreInfo storeInfo=storeInfoService.getStoreInfoById(id);
		System.out.println("选中门店信息="+storeInfo);
		return Msg.success().add("storeInfo", storeInfo);
		
	}
	/**
	 * 点击编辑按钮展示当前门店用户信息
	 */
	@ResponseBody
	@RequestMapping(value="/getEmpByStoreId",method = RequestMethod.GET)
	public Msg getEmpByStoreId(Integer id) {
		System.out.println("第二次传入id="+id);
		List<User> userList=userService.getEmpByStoreId(id);
		System.out.println("当前门店的用户信息："+userList);
		return Msg.success().add("userList", userList);
		
	}
	/**
	 * *新增门店信息
	 */
	@ResponseBody
	@RequestMapping(value="/addNewStoreInfo",method=RequestMethod.POST)
	public Msg addNewStoreInfo(StoreInfo storeInfo) {
		storeInfoService.addNewStoreInfo(storeInfo);
		System.out.println("新增的门店信息:"+storeInfo);
		return Msg.success();
	}
	/**
	 * *删除门店信息
	 */
	/**
	 * 点击下方删除商品信息——单个删除 id:1,批量删除 ids:1-2-3
	 */
	@ResponseBody
	@RequestMapping(value="/deleteStoreInfoBatch",method = RequestMethod.DELETE)
	public Msg deleteStoreInfoBatch(String storeInfoIds) {
		System.out.println("删除门店的id："+storeInfoIds);
		//批量删除
		if(storeInfoIds.contains("-")){
			List<Integer> del_ids = new ArrayList();
			//使用-分割productIds,将分割结果拼装成数组
			String[] str_storeInfoIds = storeInfoIds.split("-");
			//遍历并组装id的集合
			for (String string : str_storeInfoIds) {
				del_ids.add(Integer.parseInt(string));
			}
			System.out.println("删除门店的idList："+del_ids);
			storeInfoService.deleteStoreInfoBatch(del_ids);
			
		}else {
			//单个删除
			//把string类型转成integer
			Integer storeInfoId = Integer.parseInt(storeInfoIds);
			storeInfoService.deleteStoreInfoById(storeInfoId);
		}		
		return Msg.success();
		
	}
	
	/**
	 * *搜索信息
	 */
	@ResponseBody
	@RequestMapping(value="/getDataBySearch",method = RequestMethod.GET)
	public Msg getDataBySearch(@RequestParam(value="searchData")String searchData) throws Exception{
		List<StoreInfo> searchDatas=storeInfoService.getDataBySearch(searchData);
		System.out.println("搜索到的结果："+searchDatas);
		return Msg.success().add("searchDatas",searchDatas);
	}
}
