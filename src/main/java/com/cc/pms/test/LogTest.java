package com.cc.pms.test;

import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.cc.pms.bean.LogMessage;
import com.cc.pms.dao.LogDao;
import com.cc.pms.utils.JdbcJsonUtil;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class LogTest {
	@Autowired
	LogDao logDao;
	
//	@Test
//	public void logtest() {
//		List<LogMessage> res=logDao.getAllLogMessage();
//		PrintStream ps;
//		try {
//			ps = new PrintStream("./log.txt");
//			System.setOut(ps);
//			System.out.println(res);
//		} catch (FileNotFoundException e) {
//			e.printStackTrace();
//		}  
//	}

}
