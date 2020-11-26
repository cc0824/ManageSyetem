package com.cc.pms.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.ProductPriceSale;
import com.cc.pms.bean.StoreInfo;

public interface ProductService {

	public void addProduct(Product product);

	public void deleteProduct(String productName);
	
	public void deleteProductById(Integer productId);
	
	public void deleteProductByIds(List<Integer> productIds);
	
	public Integer updateProduct(Product product);
	
	public int updateSelectProduct(Product product);
	
	public Product getSelectProduct(Integer productId);	
	
	public Product getProduct(String productName);

	public List<Product> getAllProduct();

	public void deleteBatch(List<Integer> productIds);
	
	public List<Product> getDataBySearch(String searchData);
	
	public Product getProductIdByName(String productName);
	
	public ProductPriceSale getSelectProductWithSale(Integer productId);
	
	public Product getSelectProductWithSaleInf(Integer productId);
	
}
