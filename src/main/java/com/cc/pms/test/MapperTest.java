package com.cc.pms.test;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.cc.pms.bean.CheckItem;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.SaleInf;
import com.cc.pms.bean.User;
import com.cc.pms.dao.InventoryDao;
import com.cc.pms.dao.ProductDao;
import com.cc.pms.dao.SalesDao;
import com.cc.pms.dao.StoreInfoDao;
import com.cc.pms.dao.UserDao;
import com.cc.pms.utils.JdbcJsonUtil;

/**
 * ����dao��Ĺ������ܷ������ݿ�����
 * 
 * @author cc  
 * 0����ͳ��
 * 1������SpringIOC����
 * ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
 * 2���������л�ȡmapper 
 * UserMapper bean = ioc.getBean(UserMapper.class);
 * 0���Ƽ�Spring����Ŀ�Ϳ���ʹ��Spring�ĵ�Ԫ���ԣ������Զ�ע��������Ҫ����� 
 * 1������SpringTestģ��
 * 2��@ContextConfigurationָ��Spring�����ļ���λ�ã��Զ�����ioc����
 * 3��@RunWithָ��������ע����ʽ
 * 4��ֱ��autowiredҪʹ�õ��������
 */
//@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
//public class MapperTest {
//	@Autowired
//	UserDao userDao;
//	@Autowired
//	SqlSession sqlSession;
//	
//	@Test
//	public void usertest() {
//		
//		System.out.println(userDao);
//		//System.out.println(userDao.getUserData(1));
//		userDao.addUser(new User(3,"b","123"));
//	}
//
//}
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class MapperTest {
	@Autowired
	ProductDao productDao;
//	@Autowired
//	SqlSession sqlSession;
	@Autowired
	StoreInfoDao storeInfoDao;
	@Autowired
	SalesDao salesDao;
	@Autowired
	InventoryDao inventoryDao;
	
	
	@Test
	public void inventoryTest() {
		List<CheckItem> res=inventoryDao.getAllCheckProductByCheckSheet(1);
		System.out.println(res);
	}
	
	@Test
	public void analysistest() {
		//List<Integer> slist=salesDao.getSelectProductSalesSize(85);
		//[15, 13, 9, 25, 17, 21, 19, 23, 25]
		//String s=JdbcJsonUtil.listToJson(slist);
		//System.out.println(s);
	}
	
	@Test
	public void producttest() {
		//1������crud
		//System.out.println(productDao);
		//System.out.println(productDao.getSelectProduct(8));
		//System.out.println(productDao.getProduct("ţ��"));
		//productDao.addProduct(new Product(2,"������",5,6,"����"));
		//productDao.updateProduct(new Product(6,"������",7,17,"ɽ��"));
		//productDao.updateProduct(new Product(2,"������",5,11,"����"));
		//productDao.deleteProduct("������");
		//productDao.getSelectProduct(5);
		//productDao.deleteProductById(10);

		//System.out.println(productDao.updateSelectProduct(new Product(9,"ѩ��2",2,3,"���")));
		
		//2�������������� ʹ�ÿ���ִ������������sqlSession
		//�޸�applicationContext.xml����ִ�е�sqlSession
//		ProductDao pro=sqlSession.getMapper(ProductDao.class);
//		for(int i = 0;i<30;i++){
//			String uid = UUID.randomUUID().toString().substring(0,5)+i;
//			pro.addProduct(new Product(null,uid,3,4,null));
//
//		}
//		System.out.println("�������");
		
	}

}
