package com.cc.pms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cc.pms.bean.CheckItem;
import com.cc.pms.bean.Inventory;
import com.cc.pms.bean.Menu;
import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.StoreInfo;
import com.cc.pms.service.InventoryService;
import com.cc.pms.service.ProductService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
@Controller
@RequestMapping("/inventory")
public class InventoryController {
	@Autowired
	private InventoryService inventoryService;
	@Autowired
	private ProductService productService;
 	/**
	 * �ڿ��������չʾ�����Ϣ��ʹ��ajax��������JSON��ʽ���أ�����Ϣͳһ����msgʵ���װ
	 * ����url="product/displayProductInformation.do"�鿴json���ݸ�ʽ
	 */
	@ResponseBody
	@RequestMapping("/displayInventoryInformation")
	public Msg displayInventoryInformation(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 10);
		List<Inventory> inventory =inventoryService.getAllInventory();
		PageInfo page=new PageInfo(inventory,5);
		//��ʽ����
		return Msg.success().add("pageInfo", page);
		
	}
	/**
	 * *�ڿ��������������Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getDataBySearch",method = RequestMethod.GET)
	public Msg getDataBySearch(@RequestParam(value="searchData")String searchData) throws Exception{
		List<Inventory> searchDatas=inventoryService.getDataBySearch(searchData);
		System.out.println("�������Ľ����"+searchDatas);
		return Msg.success().add("searchDatas",searchDatas);
	}
	
	/**
	 * *�ڿ�����������������Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/addNewInventory",method = RequestMethod.POST)
	public Msg addNewInventory(Inventory inventory) throws Exception{
		System.out.println("�����Ŀ�棺"+inventory);
		//�����Ŀ�棺Inventory[inventoryId=null,productId=null,inventorySize=25,inventoryMinsize=null,
		//	inventoryMaxsize=null,inventoryArea=,inventoryNum=null,inventoryName=ţ��3] -->
		Inventory newInventory=new Inventory();
		newInventory.setInventoryArea(inventory.getInventoryArea());
		newInventory.setInventorySize(inventory.getInventorySize());
		Product newProduct=productService.getProductIdByName(inventory.getInventoryName());
		newInventory.setProductId(newProduct.getProductId());
		System.out.println(newInventory);
		inventoryService.addNewInventory(newInventory);
		
		return Msg.success();
	}
	/**
	 * *�ڿ�����������������Ϣǰ����Ҫ��֤�ÿ���Ӧ����Ʒ�Ƿ����
	 */
	@ResponseBody
	@RequestMapping(value="/checkNewInventoryExist",method = RequestMethod.GET)
	public Msg checkNewInventoryExist (@RequestParam(value="inventoryName")String inventoryName) throws Exception{
		System.out.println(inventoryName);
		List<Product> inventoryList=inventoryService.getExistInventory(inventoryName);
		int existFlag;
		if(inventoryList.size()==0) {
			existFlag=0;
		}else {
			existFlag=1;
		}
		return Msg.success().add("existFlag",existFlag);
	}
	/**
	 * *��ӿ����Ϣ ����-id ����
	 */
	@ResponseBody
	@RequestMapping(value="/addChangeInventory",method = RequestMethod.POST)
	public Msg addChangeInventory(Inventory inventory)throws Exception{
		System.out.println(inventory);
		Product newProduct2=productService.getProductIdByName(inventory.getInventoryName());
		Integer size=inventory.getInventorySize();
		inventoryService.updateInventorySizeById(newProduct2.getProductId(),size);
		return Msg.success();
	}
	
	@ResponseBody
	@RequestMapping(value="/getCheckProduct",method=RequestMethod.GET)
	public Msg getAllCheckProductByCheckSheet(int inventoryCheckId,@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 10);
		List<CheckItem> checkItems=inventoryService.getAllCheckProductByCheckSheet(inventoryCheckId);
		PageInfo page=new PageInfo(checkItems,5);
		return Msg.success().add("pageInfo", page);
	}
	
	@ResponseBody
	@RequestMapping(value="/getAllCheckInfoByCheckState",method=RequestMethod.GET)
	public Msg getAllCheckInfoByCheckState(int inventoryCheckId,int inventoryCheckState,@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 10);
		List<CheckItem> checkItems=inventoryService.getAllCheckInfoByCheckState(inventoryCheckState,inventoryCheckId);
		PageInfo page=new PageInfo(checkItems,5);
		return Msg.success().add("pageInfo", page);
	}
}
