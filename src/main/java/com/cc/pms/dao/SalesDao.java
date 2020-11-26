package com.cc.pms.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.DailyData;
import com.cc.pms.bean.SaleInf;

public interface SalesDao {
	//��������
	public List<SaleInf> selectSaleInfByCondition(@Param("params")Map<String,Object> searchMap);
	//����������Ϣ
	public int addSaleInf(SaleInf saleInf);
	//�������
	public List<String> getAndComputeYearProfit(int year);
	//ָ����Ʒ����
	public List<Integer> getSelectProductSalesSize(Integer productId);
	//ָ����Ʒ�������
	public List<SaleInf> getSelectProductSaleInf(Integer productId);
	//��ѯ����������Ϣ
	public List<SaleInf> getAllSaleInf();
	//��ѯ����������Ϣ salesId
	public SaleInf getSelectProductSaleInfBySalesId(Integer salesId);
	//������������
	public Integer updateSaleInf(SaleInf saleInf);
	//lstm
	public List<DailyData> getDailyDataByProductId(Integer productId);

}
