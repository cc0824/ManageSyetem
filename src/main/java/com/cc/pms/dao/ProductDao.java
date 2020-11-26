package com.cc.pms.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.ProductPriceSale;
import com.cc.pms.bean.StoreInfo;

public interface ProductDao {

	public void addProduct(Product product);
	
	public void deleteProduct(String productName);
	
	public void deleteProductById(Integer productId);
	
	public void deleteProductByIds(List<Integer> productIds);
	
	public Integer updateProduct(Product product);
	
	public int updateSelectProduct(Product product);
	
	public Product getSelectProduct(Integer productId);
	
	public Product getProduct(String productName);

	public List<Product> getAllProduct();
	
	public List<Product> getDataBySearch(@Param("searchData")String searchData);
	
	public Product getProductIdByName(String productName);
	
	public Product getSelectProductWithSaleInf(Integer productId);
	







	



}
