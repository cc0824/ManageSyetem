package com.cc.pms.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cc.pms.bean.LogMessage;
import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.Role;
import com.cc.pms.bean.StoreInfo;
import com.cc.pms.bean.User;
import com.cc.pms.component.LogAnnotation;
import com.cc.pms.service.LogService;
import com.cc.pms.service.ProductService;
import com.cc.pms.utils.IPUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
@RequestMapping("/product")
public class ProductController {
	@Autowired
	private ProductService productService;
	@Autowired
	private LogService logService;
	/**
	 * 依据商品名称查询商品信息 
	 * 
	 */
	//@ResponseBody
	@RequestMapping("/searchProduct")
	public void searchProduct(@RequestParam(value="productName") String productName) {
		System.out.println(productName);
		productService.getProduct(productName);
		
	}
	/**
	 * 展示商品信息1（分页查询）
	 * @RequestParam(value="pageNumber",defaultValue="1"),前台没有传过来pageNumber，所以设置默认值为第一页	
	 */
//	@RequestMapping("/displayProductInformation")
//	public String displayProductInformation(@RequestParam(value="pn",defaultValue="1")Integer pn,
//			Model model) {
//		//这不是一个分页查询，没法分页显示
//		//List<Product> product =productService.getAllProduct();
//		//所以要引入pagehelper分页插件
//		//在查询之前只需要调用下面这个方法，传入页码，以及每页的大小
//		PageHelper.startPage(pn, 10);
//		//这样startPage后面的查询就是分页查询
//		List<Product> product =productService.getAllProduct();
//		//这部分参考pagehelper使用文档，使用pageinfo包装查询后的分页结果，只需要将pageinfo交给页面，使用model或者map这些工具包装pageinfo
//		//包含查询出来的数据，传入连续显示页数
//		PageInfo page=new PageInfo(product,5);
//		model.addAttribute("pageInfo", page);
//		return "views/productInformation";
//		
//	}
	/**
	 * 展示商品信息2，以JSON形式返回
	 * 需要导入jackson包的支持，将对象自动转换成json字符串
	 * json格式{"key1":"value1","key2":"value2"}
	 * 但是Pageinfo不具有通用性，不方便修改删除，无法获取请求状态信息
	 */
//	@ResponseBody
//	@RequestMapping("/displayProductInformation")
//	public PageInfo displayProductInfWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn,
//			Model model) {
//		//这不是一个分页查询，没法分页显示
//		//List<Product> product =productService.getAllProduct();
//		//所以要引入pagehelper分页插件
//		//在查询之前只需要调用下面这个方法，传入页码，以及每页的大小
//		PageHelper.startPage(pn, 10);
//		//这样startPage后面的查询就是分页查询
//		List<Product> product =productService.getAllProduct();
//		//这部分参考pagehelper使用文档，使用pageinfo包装查询后的分页结果，只需要将pageinfo交给页面，使用model或者map这些工具包装pageinfo
//		//包含查询出来的数据，传入连续显示页数
//		PageInfo page=new PageInfo(product,5);
//		return page;
//		
//	}
	/**
	 * 展示商品信息3，使用ajax方法，以JSON形式返回，将信息统一利用msg实体封装
	 * 可以url="product/displayProductInformation.do"查看json数据格式
	 */
	
	@ResponseBody
	@RequestMapping("/displayProductInformation")
	@LogAnnotation(value="商品查询...")
	public Msg displayProductInfWithJsonMsg(@RequestParam(value="pn",defaultValue="1")Integer pn,HttpServletRequest request) {

		HttpSession session=request.getSession();
		User user=(User) session.getAttribute("user");
		Role role=(Role) session.getAttribute("role");
		try {
			PageHelper.startPage(pn, 10);
			List<Product> product =productService.getAllProduct();
			PageInfo page=new PageInfo(product,5);
//			LogMessage logmsg=new LogMessage(null, user.getUserName(),role.getRoleName(), "商品查询", 
//					DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now()), 
//					"成功", IPUtil.getIpAddress());
//			//System.out.println(logmsg);
//			logService.addLog(logmsg);
			return Msg.success().add("pageInfo", page);
		} catch (Exception e) {
			//添加日志
//			LogMessage logmsg=new LogMessage(null, user.getUserName(),role.getRoleName(), "商品查询", 
//					DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now()), 
//					"失败", IPUtil.getIpAddress());
//			//System.out.println(logmsg);
//			logService.addLog(logmsg);
			return Msg.fail();
		}
	}
	
	/**
	 * 保存商品信息
	 * 实体变量名和表单name属性名一样，自动封装到实体中
	 */
	@ResponseBody
	@RequestMapping(value="/addNewProduct",method=RequestMethod.POST)
	public Msg addNewProduct(Product product) {
		productService.addProduct(product);
		return Msg.success();
		
		
	}
	/**
	 * 修改商品信息
	 * 1、依据id选择商品信息,将信息展示在form中
	 * 如果传参是通过路径传参，用@PathVariable注解
	 */
	@ResponseBody
	@RequestMapping(value="/getProductById",method = RequestMethod.GET)
	public Msg getProduct(Integer id) {
		System.out.println(id);
		Product product=productService.getSelectProduct(id);
		return Msg.success().add("product", product);
	}
	/**
	 * 修改商品信息
	 * 2、将信息保存到数据库中
	 */
	@ResponseBody
	@RequestMapping(value="/updateProduct",method = RequestMethod.PUT)
	public Msg updateProduct(Product product,HttpServletRequest request) {
		System.out.println("将要更新的数据："+product);
		productService.updateSelectProduct(product);
		return Msg.success().add("product", product);
	}
	/**
	 * 查询商品信息
	 * 1、依据name选择商品信息,将信息展示在form中
	 * 如果传参是通过路径传参，用@PathVariable注解
	 */
	@ResponseBody
	@RequestMapping(value="/getProductByName",method = RequestMethod.GET)
	public Msg getProductByName(String productName) {
		System.out.println(productName);
		Product product=productService.getProduct(productName);
		return Msg.success().add("product", product);
	}
	
	/**
	 * 点击右侧删除商品信息——单个删除
	 */
	@ResponseBody
	@RequestMapping(value="/deleteProduct",method = RequestMethod.DELETE)
	public Msg deleteProductById(Integer productId) {
		//System.out.println(productId);
		productService.deleteProductById(productId);
		return Msg.success();
		
	}
	/**
	 * 点击下方删除商品信息——单个删除 id:1,批量删除 ids:1-2-3
	 */
	@ResponseBody
	@RequestMapping(value="/deleteProductBatch",method = RequestMethod.DELETE)
	public Msg deleteProduct(String productIds) {
		System.out.println(productIds);
		//批量删除
		if(productIds.contains("-")){
			List<Integer> del_ids = new ArrayList();
			//使用-分割productIds,将分割结果拼装成数组
			String[] str_productIds = productIds.split("-");
			//遍历并组装id的集合
			for (String string : str_productIds) {
				del_ids.add(Integer.parseInt(string));
			}
			productService.deleteProductByIds(del_ids);
			
		}else {
			//单个删除
			//把string类型转成integer
			Integer productId = Integer.parseInt(productIds);
			productService.deleteProductById(productId);
		}		
		return Msg.success();
		
	}
	
	/**
	 * *搜索信息
	 */
	@ResponseBody
	@RequestMapping(value="/getDataBySearch",method = RequestMethod.GET)
	public Msg getDataBySearch(@RequestParam(value="searchData")String searchData,@RequestParam(value="pn",defaultValue="1")Integer pn) throws Exception{
		List<Product> searchDatas=productService.getDataBySearch(searchData);
		System.out.println("搜索到的结果："+searchDatas);
		PageHelper.startPage(pn, 10);
		PageInfo page=new PageInfo(searchDatas,5);
		return Msg.success().add("pageInfo",page);
	}
	
	/**
	 * *通过已经输入的内容展示相关商品
	 */
	@ResponseBody
	@RequestMapping(value="/displayProductInSelect",method = RequestMethod.GET)
	public Msg displayProductInSelect(@RequestParam(value="inputData")String inputData) throws Exception{
		System.out.println("已经输入的结果："+inputData);
		List<Product> searchDatas=productService.getDataBySearch(inputData);
		System.out.println("查询到的结果："+searchDatas);
		return Msg.success().add("searchDatas",searchDatas);
		
	}
	
	
	
	
	
	

	
	

}
