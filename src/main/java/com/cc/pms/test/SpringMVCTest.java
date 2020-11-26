package com.cc.pms.test;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.cc.pms.bean.Product;
import com.github.pagehelper.PageInfo;

/**
 * 使用spring测试模块提供的测试请求功能，测试crud请求的正确性
 * spring4测试的时候 需要servlet3.0支持
 * @author cc
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration//用来获取web ioc容器
@ContextConfiguration(locations= {"classpath:applicationContext.xml","classpath:springmvc.xml"})
public class SpringMVCTest {
	//传入springmvc的ioc
	@Autowired
	WebApplicationContext context;
	//虚拟mvc请求，获取处理结果
	MockMvc mockMvc;
	//每次使用之前都要初始化
	@Before
	public void initMockMvc() {
		mockMvc=MockMvcBuilders.webAppContextSetup(context).build();
	}
	@Test
	public void testPage() throws Exception {
		//模拟请求.get("url").param(设置当前页码).andReturn(拿到返回值)
		MvcResult result=mockMvc.perform(MockMvcRequestBuilders.get("/product/displayProductInformation").
				param("pageNumber", "4")).andReturn();
		//请求成功后，请求域中会有pageInfo,可以取出pageinfo进行验证
		MockHttpServletRequest request=result.getRequest();
		PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
		
		//验证
		System.out.println("当前页码："+pi.getPageNum());
		System.out.println("总页码："+pi.getPages());
		System.out.println("总记录数："+pi.getTotal());
		
		System.out.println("在页面需要连续显示的页码：");
		int[] nums=pi.getNavigatepageNums();
		for(int i:nums) {
			System.out.println(""+i);
		}
		
		//获取员工数据
		System.out.println("商品数据");
		List<Product> list=pi.getList();
		for (Product product : list) {
			System.out.println("ID:"+product.getProductId()+"==>Name:"+product.getProductName());
			
		}
		

		
	}
}
