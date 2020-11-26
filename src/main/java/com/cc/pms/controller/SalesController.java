package com.cc.pms.controller;

import java.text.DateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.SaleInf;
import com.cc.pms.service.SalesService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/sales")
public class SalesController {
	
	@Autowired
	private SalesService salesService;
	
	/**
	 * 1.新增销售信息
	 * @param saleInf
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/addSaleInf",method=RequestMethod.POST)
	public Msg addSaleInf(SaleInf saleInf) throws Exception{
		System.out.println(saleInf);
		Integer item=Integer.valueOf(salesService.addSaleInf(saleInf));
		return Msg.success().add("item", item);
	}
	/**
	 * 2.筛选销售信息
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/selectSalesHistory",method=RequestMethod.GET)
	public Msg selectSalesHistory(HttpServletRequest request) throws Exception{
		String startTime1=request.getParameter("startTime1");
		String endTime1=request.getParameter("endTime1");
		LocalDate startTime=LocalDate.now();
		LocalDate endTime=LocalDate.now();
		if(startTime1!=null&&startTime1!="") {
			startTime=LocalDate.parse(startTime1,DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		}
		if(endTime1!=null&&endTime1!="") {
			endTime=LocalDate.parse(request.getParameter("endTime1"),DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		}
		String searchCondition=request.getParameter("searchCondition");
		System.out.println("startTime:"+startTime);
		System.out.println("endTime:"+endTime);
		System.out.println("searchCondition:"+searchCondition);
		Map<String,Object> searchMap=new HashMap<>();
		searchMap.put("startTime", startTime);
		searchMap.put("endTime", endTime);
		searchMap.put("searchCondition", searchCondition);
		List<SaleInf> saleInfs=salesService.selectSaleInfByCondition(searchMap);
		System.out.println(saleInfs);
		return Msg.success().add("saleInfs",saleInfs);
	}
	
	/**
	 * 3.获取年度利润
	 */
	@ResponseBody
	@RequestMapping("/getYearProfit")
	public Msg getYearProfit(int year) {
		System.out.println(year);
		List<String> yearProfits=new ArrayList<>();
		yearProfits=salesService.getAndComputeYearProfit(year);
		System.out.println(yearProfits);
		
		
		Map<String,Object> mmap=new HashMap<>();
		mmap.put("a", 90);
		mmap.put("b", 120);
		mmap.put("c", 180);
		mmap.put("d", 170);
		mmap.put("e", 110);
		mmap.put("f", 140);
		//net.sf.json.JSONObject 将Map转换为JSON方法
		JSONObject json = JSONObject.fromObject(mmap);
		System.out.println(json);
		return Msg.success().add("json", json);
	}
	/**
	 * 4.查询所有or指定商品销售信息
	 * @param request  productId
	 */
	@ResponseBody
	@RequestMapping(value="/getSelectProductSaleInf",method = RequestMethod.GET)
	public Msg getSelectProductSaleInf(HttpServletRequest req,@RequestParam(value="pn",defaultValue="1")Integer pn) throws Exception{
		PageHelper.startPage(pn, 10);
		List<SaleInf> sales=new ArrayList<>();
		if(req.getParameter("productId")==null) {
			sales=salesService.getAllSaleInf();
			System.out.println("sales="+sales);
		}else {
			Integer productId=Integer.parseInt(req.getParameter("productId"));
			sales=salesService.getSelectProductSaleInf(productId);
			System.out.println("sales="+sales);
		}
		PageInfo page=new PageInfo(sales,5);
		return Msg.success().add("pageInfo",page);
	}
	/**
	 * 4.1查询指定销售信息
	 * @param request  salesId
	 */
	@ResponseBody
	@RequestMapping(value="/getSelectProductSaleInfBySalesId",method = RequestMethod.GET)
	public Msg getSelectProductSaleInfBySalesId(HttpServletRequest req) throws Exception{
		Integer salesId= Integer.parseInt(req.getParameter("salesId"));
		SaleInf sale=salesService.getSelectProductSaleInfBySalesId(salesId);
		System.out.println("sales="+sale);
		return Msg.success().add("saleInfo",sale);
	}
	/**
	 * 4.2查询指定商品销售信息
	 * @param request  productId
	 */
	@ResponseBody
	@RequestMapping(value="/getSelectProductAllSaleInfByProductId",method = RequestMethod.GET)
	public Msg getSelectProductAllSaleInfByProductId(HttpServletRequest req) throws Exception{
		Integer productId= Integer.parseInt(req.getParameter("productId"));
		List<SaleInf> sales=salesService.getSelectProductSaleInf(productId);
		System.out.println("salelist="+sales);
		return Msg.success().add("salelist",sales);
	}
	
	
	/**
	 * 5.修改销售信息
	 * @param salesId
	 */
	@ResponseBody
	@RequestMapping(value="/updateSaleInf",method = RequestMethod.PUT)
	public Msg updateSaleInf(SaleInf saleInf) throws Exception{
		System.out.println("将要更新的数据："+saleInf);
		Integer num=salesService.updateSaleInf(saleInf);
		return Msg.success().add("更新个数=",num);
	}

}
