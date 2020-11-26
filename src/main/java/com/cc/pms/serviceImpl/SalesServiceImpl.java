package com.cc.pms.serviceImpl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.DailyData;
import com.cc.pms.bean.SaleInf;
import com.cc.pms.dao.SalesDao;
import com.cc.pms.service.SalesService;

@Service("salesService")
public class SalesServiceImpl implements SalesService{
	@Autowired
	private SalesDao salesDao;
	//条件搜索
	public List<SaleInf> selectSaleInfByCondition(Map<String,Object> searchMap){
		return salesDao.selectSaleInfByCondition(searchMap);
	}
	//新增销售信息
	public int addSaleInf(SaleInf saleInf) {
		return salesDao.addSaleInf(saleInf);
	}
	//年度利润
	public List<String> getAndComputeYearProfit(int year){
		//return salesDao.getAndComputeYearProfit(year);
		List<String> lists=new ArrayList<String>();
		lists.add("5");
		lists.add("6");
		return lists;
	}
	@Override
	public List<Integer> getSelectProductSalesSize(Integer productId) {
		return salesDao.getSelectProductSalesSize(productId);
	}
	//指定商品销售情况
	@Override
	public List<SaleInf> getSelectProductSaleInf(Integer productId){
		return salesDao.getSelectProductSaleInf(productId);
	}
	@Override
	public List<SaleInf> getAllSaleInf() {
		return salesDao.getAllSaleInf();
	}
	@Override
	public SaleInf getSelectProductSaleInfBySalesId(Integer salesId) {
		return salesDao.getSelectProductSaleInfBySalesId(salesId);
	}
	@Override
	public Integer updateSaleInf(SaleInf saleInf) {
		return salesDao.updateSaleInf(saleInf);
	}
	@Override
	public List<DailyData> getDailyDataByProductId(Integer productId) {
		return salesDao.getDailyDataByProductId(productId);
	}


}
