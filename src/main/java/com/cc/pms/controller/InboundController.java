package com.cc.pms.controller;
/**
 * 库存管理
 * @author cc
 *
 */

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cc.pms.bean.InboundProduct;
import com.cc.pms.bean.Inventory;
import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.service.InboundService;
import com.cc.pms.service.ProductService;
import com.cc.pms.utils.TimeUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;



@Controller
@RequestMapping("/inbound")
public class InboundController {
	@Autowired
	private InboundService inboundService;
	@Autowired
	private ProductService productService;
	/**
	 * 商品入库，将库存变动情况保存到数据库tb_inbound
	 */
	@ResponseBody
	@RequestMapping(value="/addInbound",method = RequestMethod.POST)
	public Msg addInbound(Inventory inventory) throws Exception{
		System.out.println("inventory:"+inventory);
		Product newProduct2=productService.getProductIdByName(inventory.getInventoryName());
		//手动封装InboundProduct实体
		//inventory:Inventory[inventoryId=null,productId=null,inventorySize=7,inventoryMinsize=null,inventoryMaxsize=null,
		//	inventoryArea=null,inventoryNum=null,inventoryName=牛奶3,inboundCost=3.5]
		InboundProduct iProduct=new InboundProduct();
		iProduct.setInboundCost(inventory.getInboundCost());
		iProduct.setInboundSize(inventory.getInventorySize());
		iProduct.setProductId(newProduct2.getProductId());
		String total=Float.valueOf(Float.parseFloat(inventory.getInboundCost())*inventory.getInventorySize()).toString();
		iProduct.setInboundTotal(total);
		iProduct.setInboundTime(TimeUtil.getFormatTime());
		iProduct.setInboundFlag(0);
		System.out.println(iProduct);
		//Inbound[inboundId=null,productId=86,inBoundNum=null,inboundCost=1.85,
		//	inboundSize=11,inboundTotal=20.35,inboundTime=null,messageIdnull]
		inboundService.addInbound(iProduct);
		return Msg.success();
		
	} 
	
	/*
	 * 	改变InboundFlag状态
	 */
	@ResponseBody
	@RequestMapping(value="/changeInbooundFlag",method = RequestMethod.POST)
	public Msg changeInbooundFlag() throws Exception{
		inboundService.updateInbooundFlag();
		return Msg.success();
		
	}
	/*
	 * 	查询InboundFlag=0的数据
	 */
	@ResponseBody
	@RequestMapping(value="/getInbooundWithFlag",method = RequestMethod.GET)
	public Msg getInbooundWithFlag(@RequestParam(value="pn",defaultValue="1")Integer pn) throws Exception{
		List<InboundProduct> inboundList=inboundService.getInbooundWithFlag();
		PageHelper.startPage(pn, 10);
		PageInfo page=new PageInfo(inboundList,5);
		return Msg.success().add("pageInfo", page);
	}
	/**
	 * 	为inboundFlag=0的数据赋值message_id
	 */
	@ResponseBody
	@RequestMapping(value="/updateMessageIdByFlag",method = RequestMethod.POST)
	public Msg updateMessageIdByFlag(@RequestParam(value="messageId")Integer messageId) throws Exception{
		System.out.println(messageId);
		inboundService.updateMessageIdByFlag(messageId);
		return Msg.success();
	}

}
