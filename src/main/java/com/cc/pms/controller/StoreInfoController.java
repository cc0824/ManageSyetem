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
	 * չʾ�����ŵ���Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getAllStoreInfo",method = RequestMethod.GET)
	public Msg getAllStoreInfo() {
		List<StoreInfo> storeInfoList=storeInfoService.getAllStoreInfo();
		System.out.println("�����ŵ���Ϣ="+storeInfoList);
		return Msg.success().add("storeInfoList", storeInfoList);
	}
	/**
	 * ����༭��ťչʾѡ���ŵ���Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getStoreInfoById",method = RequestMethod.GET)
	public Msg getStoreInfoById(Integer id) {
		System.out.println("��һ�δ���id="+id);
		StoreInfo storeInfo=storeInfoService.getStoreInfoById(id);
		System.out.println("ѡ���ŵ���Ϣ="+storeInfo);
		return Msg.success().add("storeInfo", storeInfo);
		
	}
	/**
	 * ����༭��ťչʾ��ǰ�ŵ��û���Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getEmpByStoreId",method = RequestMethod.GET)
	public Msg getEmpByStoreId(Integer id) {
		System.out.println("�ڶ��δ���id="+id);
		List<User> userList=userService.getEmpByStoreId(id);
		System.out.println("��ǰ�ŵ���û���Ϣ��"+userList);
		return Msg.success().add("userList", userList);
		
	}
	/**
	 * *�����ŵ���Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/addNewStoreInfo",method=RequestMethod.POST)
	public Msg addNewStoreInfo(StoreInfo storeInfo) {
		storeInfoService.addNewStoreInfo(storeInfo);
		System.out.println("�������ŵ���Ϣ:"+storeInfo);
		return Msg.success();
	}
	/**
	 * *ɾ���ŵ���Ϣ
	 */
	/**
	 * ����·�ɾ����Ʒ��Ϣ��������ɾ�� id:1,����ɾ�� ids:1-2-3
	 */
	@ResponseBody
	@RequestMapping(value="/deleteStoreInfoBatch",method = RequestMethod.DELETE)
	public Msg deleteStoreInfoBatch(String storeInfoIds) {
		System.out.println("ɾ���ŵ��id��"+storeInfoIds);
		//����ɾ��
		if(storeInfoIds.contains("-")){
			List<Integer> del_ids = new ArrayList();
			//ʹ��-�ָ�productIds,���ָ���ƴװ������
			String[] str_storeInfoIds = storeInfoIds.split("-");
			//��������װid�ļ���
			for (String string : str_storeInfoIds) {
				del_ids.add(Integer.parseInt(string));
			}
			System.out.println("ɾ���ŵ��idList��"+del_ids);
			storeInfoService.deleteStoreInfoBatch(del_ids);
			
		}else {
			//����ɾ��
			//��string����ת��integer
			Integer storeInfoId = Integer.parseInt(storeInfoIds);
			storeInfoService.deleteStoreInfoById(storeInfoId);
		}		
		return Msg.success();
		
	}
	
	/**
	 * *������Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getDataBySearch",method = RequestMethod.GET)
	public Msg getDataBySearch(@RequestParam(value="searchData")String searchData) throws Exception{
		List<StoreInfo> searchDatas=storeInfoService.getDataBySearch(searchData);
		System.out.println("�������Ľ����"+searchDatas);
		return Msg.success().add("searchDatas",searchDatas);
	}
}
