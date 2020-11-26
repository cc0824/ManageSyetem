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
 * ʹ��spring����ģ���ṩ�Ĳ��������ܣ�����crud�������ȷ��
 * spring4���Ե�ʱ�� ��Ҫservlet3.0֧��
 * @author cc
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration//������ȡweb ioc����
@ContextConfiguration(locations= {"classpath:applicationContext.xml","classpath:springmvc.xml"})
public class SpringMVCTest {
	//����springmvc��ioc
	@Autowired
	WebApplicationContext context;
	//����mvc���󣬻�ȡ������
	MockMvc mockMvc;
	//ÿ��ʹ��֮ǰ��Ҫ��ʼ��
	@Before
	public void initMockMvc() {
		mockMvc=MockMvcBuilders.webAppContextSetup(context).build();
	}
	@Test
	public void testPage() throws Exception {
		//ģ������.get("url").param(���õ�ǰҳ��).andReturn(�õ�����ֵ)
		MvcResult result=mockMvc.perform(MockMvcRequestBuilders.get("/product/displayProductInformation").
				param("pageNumber", "4")).andReturn();
		//����ɹ����������л���pageInfo,����ȡ��pageinfo������֤
		MockHttpServletRequest request=result.getRequest();
		PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
		
		//��֤
		System.out.println("��ǰҳ�룺"+pi.getPageNum());
		System.out.println("��ҳ�룺"+pi.getPages());
		System.out.println("�ܼ�¼����"+pi.getTotal());
		
		System.out.println("��ҳ����Ҫ������ʾ��ҳ�룺");
		int[] nums=pi.getNavigatepageNums();
		for(int i:nums) {
			System.out.println(""+i);
		}
		
		//��ȡԱ������
		System.out.println("��Ʒ����");
		List<Product> list=pi.getList();
		for (Product product : list) {
			System.out.println("ID:"+product.getProductId()+"==>Name:"+product.getProductName());
			
		}
		

		
	}
}
