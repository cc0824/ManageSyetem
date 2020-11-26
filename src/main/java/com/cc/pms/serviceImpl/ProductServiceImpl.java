package com.cc.pms.serviceImpl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.ProductPriceSale;
import com.cc.pms.dao.ProductDao;
import com.cc.pms.service.ProductService;

@Service("productService")
public class ProductServiceImpl implements ProductService{
	@Autowired
	private ProductDao productDao;
	
	public void addProduct(Product product) {
		productDao.addProduct(product);
	}	
	
	public void deleteProduct(String productName) {
		productDao.deleteProduct(productName);
	}
	
	public void deleteProductById(Integer productId) {
		productDao.deleteProductById(productId);
	}
	public void deleteProductByIds(List<Integer> productIds) {
		productDao.deleteProductByIds(productIds);
	}

	public Integer updateProduct(Product product) {
		return productDao.updateProduct(product);
	}
	public int updateSelectProduct(Product product) {
		return productDao.updateSelectProduct(product);
	}

	public Product getSelectProduct(Integer productId) {
		return productDao.getSelectProduct(productId);
	}

	public Product getProduct(String productName) {
		return productDao.getProduct(productName);
	}
	
	public List<Product> getAllProduct(){
		return productDao.getAllProduct();
	}

	public void deleteProductByIds(Integer productId) {
		// TODO Auto-generated method stub
		
	}
	public List<Product> getDataBySearch(String searchData){
		return productDao.getDataBySearch(searchData);
	}

	public void deleteBatch(List<Integer> productIds) {
		// TODO Auto-generated method stub
		
	}
	
	public Product getProductIdByName(String productName) {
		return productDao.getProductIdByName(productName);
	}
	
	public ProductPriceSale getSelectProductWithSale(Integer productId) {
		return new ProductPriceSale();
	}
	public Product getSelectProductWithSaleInf(Integer productId) {
		return productDao.getSelectProductWithSaleInf(productId);
	}
}


