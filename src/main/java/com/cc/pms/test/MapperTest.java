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
 * 测试dao层的工作，能否与数据库连接
 * 
 * @author cc  
 * 0、传统：
 * 1、创建SpringIOC容器
 * ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
 * 2、从容器中获取mapper 
 * UserMapper bean = ioc.getBean(UserMapper.class);
 * 0、推荐Spring的项目就可以使用Spring的单元测试，可以自动注入我们需要的组件 
 * 1、导入SpringTest模块
 * 2、@ContextConfiguration指定Spring配置文件的位置，自动创建ioc容器
 * 3、@RunWith指定用哪种注解形式
 * 4、直接autowired要使用的组件即可
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
		//1、测试crud
		//System.out.println(productDao);
		//System.out.println(productDao.getSelectProduct(8));
		//System.out.println(productDao.getProduct("牛奶"));
		//productDao.addProduct(new Product(2,"方便面",5,6,"北京"));
		//productDao.updateProduct(new Product(6,"刀削面",7,17,"山西"));
		//productDao.updateProduct(new Product(2,"方便面",5,11,"北京"));
		//productDao.deleteProduct("方便面");
		//productDao.getSelectProduct(5);
		//productDao.deleteProductById(10);

		//System.out.println(productDao.updateSelectProduct(new Product(9,"雪碧2",2,3,"天津")));
		
		//2、测试批量插入 使用可以执行批量操作的sqlSession
		//修改applicationContext.xml批量执行的sqlSession
//		ProductDao pro=sqlSession.getMapper(ProductDao.class);
//		for(int i = 0;i<30;i++){
//			String uid = UUID.randomUUID().toString().substring(0,5)+i;
//			pro.addProduct(new Product(null,uid,3,4,null));
//
//		}
//		System.out.println("批量完成");
		
	}

}
