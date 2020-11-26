package com.cc.pms.service;

import java.util.List;
import java.util.Map;

import com.cc.pms.bean.DailyData;
import com.cc.pms.bean.SaleInf;

public interface SalesService {
	//��������
	public List<SaleInf> selectSaleInfByCondition(Map<String,Object> searchMap);
	//����������Ϣ
	public int addSaleInf(SaleInf saleInf);
	//��ѯ����������������
	public List<String> getAndComputeYearProfit(int year);
	//��ѯָ����Ʒ��������Ϣ
	public List<Integer> getSelectProductSalesSize(Integer productId);
	//��ѯ����������Ϣ
	public List<SaleInf> getAllSaleInf();
	//ָ����Ʒ������� productId
	public List<SaleInf> getSelectProductSaleInf(Integer productId);
	//ָ����Ʒ�������  salesId
	public SaleInf getSelectProductSaleInfBySalesId(Integer salesId);
	//������������
	public Integer updateSaleInf(SaleInf saleInf);
	//lstm
	public List<DailyData> getDailyDataByProductId(Integer productId);

}
