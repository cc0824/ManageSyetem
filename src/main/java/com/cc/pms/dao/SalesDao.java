package com.cc.pms.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.DailyData;
import com.cc.pms.bean.SaleInf;

public interface SalesDao {
	//条件搜索
	public List<SaleInf> selectSaleInfByCondition(@Param("params")Map<String,Object> searchMap);
	//新增销售信息
	public int addSaleInf(SaleInf saleInf);
	//年度利润
	public List<String> getAndComputeYearProfit(int year);
	//指定商品销量
	public List<Integer> getSelectProductSalesSize(Integer productId);
	//指定商品销售情况
	public List<SaleInf> getSelectProductSaleInf(Integer productId);
	//查询所有销售信息
	public List<SaleInf> getAllSaleInf();
	//查询所有销售信息 salesId
	public SaleInf getSelectProductSaleInfBySalesId(Integer salesId);
	//更新销售数据
	public Integer updateSaleInf(SaleInf saleInf);
	//lstm
	public List<DailyData> getDailyDataByProductId(Integer productId);

}
