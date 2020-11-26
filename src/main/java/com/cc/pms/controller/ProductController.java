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
	 * ������Ʒ���Ʋ�ѯ��Ʒ��Ϣ 
	 * 
	 */
	//@ResponseBody
	@RequestMapping("/searchProduct")
	public void searchProduct(@RequestParam(value="productName") String productName) {
		System.out.println(productName);
		productService.getProduct(productName);
		
	}
	/**
	 * չʾ��Ʒ��Ϣ1����ҳ��ѯ��
	 * @RequestParam(value="pageNumber",defaultValue="1"),ǰ̨û�д�����pageNumber����������Ĭ��ֵΪ��һҳ	
	 */
//	@RequestMapping("/displayProductInformation")
//	public String displayProductInformation(@RequestParam(value="pn",defaultValue="1")Integer pn,
//			Model model) {
//		//�ⲻ��һ����ҳ��ѯ��û����ҳ��ʾ
//		//List<Product> product =productService.getAllProduct();
//		//����Ҫ����pagehelper��ҳ���
//		//�ڲ�ѯ֮ǰֻ��Ҫ���������������������ҳ�룬�Լ�ÿҳ�Ĵ�С
//		PageHelper.startPage(pn, 10);
//		//����startPage����Ĳ�ѯ���Ƿ�ҳ��ѯ
//		List<Product> product =productService.getAllProduct();
//		//�ⲿ�ֲο�pagehelperʹ���ĵ���ʹ��pageinfo��װ��ѯ��ķ�ҳ�����ֻ��Ҫ��pageinfo����ҳ�棬ʹ��model����map��Щ���߰�װpageinfo
//		//������ѯ���������ݣ�����������ʾҳ��
//		PageInfo page=new PageInfo(product,5);
//		model.addAttribute("pageInfo", page);
//		return "views/productInformation";
//		
//	}
	/**
	 * չʾ��Ʒ��Ϣ2����JSON��ʽ����
	 * ��Ҫ����jackson����֧�֣��������Զ�ת����json�ַ���
	 * json��ʽ{"key1":"value1","key2":"value2"}
	 * ����Pageinfo������ͨ���ԣ��������޸�ɾ�����޷���ȡ����״̬��Ϣ
	 */
//	@ResponseBody
//	@RequestMapping("/displayProductInformation")
//	public PageInfo displayProductInfWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn,
//			Model model) {
//		//�ⲻ��һ����ҳ��ѯ��û����ҳ��ʾ
//		//List<Product> product =productService.getAllProduct();
//		//����Ҫ����pagehelper��ҳ���
//		//�ڲ�ѯ֮ǰֻ��Ҫ���������������������ҳ�룬�Լ�ÿҳ�Ĵ�С
//		PageHelper.startPage(pn, 10);
//		//����startPage����Ĳ�ѯ���Ƿ�ҳ��ѯ
//		List<Product> product =productService.getAllProduct();
//		//�ⲿ�ֲο�pagehelperʹ���ĵ���ʹ��pageinfo��װ��ѯ��ķ�ҳ�����ֻ��Ҫ��pageinfo����ҳ�棬ʹ��model����map��Щ���߰�װpageinfo
//		//������ѯ���������ݣ�����������ʾҳ��
//		PageInfo page=new PageInfo(product,5);
//		return page;
//		
//	}
	/**
	 * չʾ��Ʒ��Ϣ3��ʹ��ajax��������JSON��ʽ���أ�����Ϣͳһ����msgʵ���װ
	 * ����url="product/displayProductInformation.do"�鿴json���ݸ�ʽ
	 */
	
	@ResponseBody
	@RequestMapping("/displayProductInformation")
	@LogAnnotation(value="��Ʒ��ѯ...")
	public Msg displayProductInfWithJsonMsg(@RequestParam(value="pn",defaultValue="1")Integer pn,HttpServletRequest request) {

		HttpSession session=request.getSession();
		User user=(User) session.getAttribute("user");
		Role role=(Role) session.getAttribute("role");
		try {
			PageHelper.startPage(pn, 10);
			List<Product> product =productService.getAllProduct();
			PageInfo page=new PageInfo(product,5);
//			LogMessage logmsg=new LogMessage(null, user.getUserName(),role.getRoleName(), "��Ʒ��ѯ", 
//					DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now()), 
//					"�ɹ�", IPUtil.getIpAddress());
//			//System.out.println(logmsg);
//			logService.addLog(logmsg);
			return Msg.success().add("pageInfo", page);
		} catch (Exception e) {
			//�����־
//			LogMessage logmsg=new LogMessage(null, user.getUserName(),role.getRoleName(), "��Ʒ��ѯ", 
//					DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now()), 
//					"ʧ��", IPUtil.getIpAddress());
//			//System.out.println(logmsg);
//			logService.addLog(logmsg);
			return Msg.fail();
		}
	}
	
	/**
	 * ������Ʒ��Ϣ
	 * ʵ��������ͱ�name������һ�����Զ���װ��ʵ����
	 */
	@ResponseBody
	@RequestMapping(value="/addNewProduct",method=RequestMethod.POST)
	public Msg addNewProduct(Product product) {
		productService.addProduct(product);
		return Msg.success();
		
		
	}
	/**
	 * �޸���Ʒ��Ϣ
	 * 1������idѡ����Ʒ��Ϣ,����Ϣչʾ��form��
	 * ���������ͨ��·�����Σ���@PathVariableע��
	 */
	@ResponseBody
	@RequestMapping(value="/getProductById",method = RequestMethod.GET)
	public Msg getProduct(Integer id) {
		System.out.println(id);
		Product product=productService.getSelectProduct(id);
		return Msg.success().add("product", product);
	}
	/**
	 * �޸���Ʒ��Ϣ
	 * 2������Ϣ���浽���ݿ���
	 */
	@ResponseBody
	@RequestMapping(value="/updateProduct",method = RequestMethod.PUT)
	public Msg updateProduct(Product product,HttpServletRequest request) {
		System.out.println("��Ҫ���µ����ݣ�"+product);
		productService.updateSelectProduct(product);
		return Msg.success().add("product", product);
	}
	/**
	 * ��ѯ��Ʒ��Ϣ
	 * 1������nameѡ����Ʒ��Ϣ,����Ϣչʾ��form��
	 * ���������ͨ��·�����Σ���@PathVariableע��
	 */
	@ResponseBody
	@RequestMapping(value="/getProductByName",method = RequestMethod.GET)
	public Msg getProductByName(String productName) {
		System.out.println(productName);
		Product product=productService.getProduct(productName);
		return Msg.success().add("product", product);
	}
	
	/**
	 * ����Ҳ�ɾ����Ʒ��Ϣ��������ɾ��
	 */
	@ResponseBody
	@RequestMapping(value="/deleteProduct",method = RequestMethod.DELETE)
	public Msg deleteProductById(Integer productId) {
		//System.out.println(productId);
		productService.deleteProductById(productId);
		return Msg.success();
		
	}
	/**
	 * ����·�ɾ����Ʒ��Ϣ��������ɾ�� id:1,����ɾ�� ids:1-2-3
	 */
	@ResponseBody
	@RequestMapping(value="/deleteProductBatch",method = RequestMethod.DELETE)
	public Msg deleteProduct(String productIds) {
		System.out.println(productIds);
		//����ɾ��
		if(productIds.contains("-")){
			List<Integer> del_ids = new ArrayList();
			//ʹ��-�ָ�productIds,���ָ���ƴװ������
			String[] str_productIds = productIds.split("-");
			//��������װid�ļ���
			for (String string : str_productIds) {
				del_ids.add(Integer.parseInt(string));
			}
			productService.deleteProductByIds(del_ids);
			
		}else {
			//����ɾ��
			//��string����ת��integer
			Integer productId = Integer.parseInt(productIds);
			productService.deleteProductById(productId);
		}		
		return Msg.success();
		
	}
	
	/**
	 * *������Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getDataBySearch",method = RequestMethod.GET)
	public Msg getDataBySearch(@RequestParam(value="searchData")String searchData,@RequestParam(value="pn",defaultValue="1")Integer pn) throws Exception{
		List<Product> searchDatas=productService.getDataBySearch(searchData);
		System.out.println("�������Ľ����"+searchDatas);
		PageHelper.startPage(pn, 10);
		PageInfo page=new PageInfo(searchDatas,5);
		return Msg.success().add("pageInfo",page);
	}
	
	/**
	 * *ͨ���Ѿ����������չʾ�����Ʒ
	 */
	@ResponseBody
	@RequestMapping(value="/displayProductInSelect",method = RequestMethod.GET)
	public Msg displayProductInSelect(@RequestParam(value="inputData")String inputData) throws Exception{
		System.out.println("�Ѿ�����Ľ����"+inputData);
		List<Product> searchDatas=productService.getDataBySearch(inputData);
		System.out.println("��ѯ���Ľ����"+searchDatas);
		return Msg.success().add("searchDatas",searchDatas);
		
	}
	
	
	
	
	
	

	
	

}
