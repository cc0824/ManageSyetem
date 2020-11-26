package com.cc.pms.service;

import java.util.List;
import java.util.Map;

import com.cc.pms.bean.DailyData;
import com.cc.pms.bean.SaleInf;

public interface SalesService {
	//条件搜索
	public List<SaleInf> selectSaleInfByCondition(Map<String,Object> searchMap);
	//新增销售信息
	public int addSaleInf(SaleInf saleInf);
	//查询并计算年度销售情况
	public List<String> getAndComputeYearProfit(int year);
	//查询指定商品的销售信息
	public List<Integer> getSelectProductSalesSize(Integer productId);
	//查询所有销售信息
	public List<SaleInf> getAllSaleInf();
	//指定商品销售情况 productId
	public List<SaleInf> getSelectProductSaleInf(Integer productId);
	//指定商品销售情况  salesId
	public SaleInf getSelectProductSaleInfBySalesId(Integer salesId);
	//更新销售数据
	public Integer updateSaleInf(SaleInf saleInf);
	//lstm
	public List<DailyData> getDailyDataByProductId(Integer productId);

}
