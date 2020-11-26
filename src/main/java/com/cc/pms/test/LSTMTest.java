package com.cc.pms.test;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.cc.pms.bean.DailyData;
import com.cc.pms.bean.LSTMModel;
import com.cc.pms.bean.LSTMModelRecord;
import com.cc.pms.dao.AnalyzeDao;
import com.cc.pms.dao.SalesDao;
import com.cc.pms.utils.lstmUtil.CreateCSVUtil;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class LSTMTest {
	
	@Autowired
	private SalesDao salesDao;
	@Autowired
	private AnalyzeDao analyzeDao;
	@Test
	public void test1() {
		long start=System.currentTimeMillis();
		//测试拿到数据
		List<DailyData> dataList=salesDao.getDailyDataByProductId(3);
		System.out.println(dataList);
		//生成csv文件
		ArrayList<String> headList=new ArrayList<>();
		headList.add("inboundCost");
		headList.add("inventorySize");
		headList.add("salesPrice");
		headList.add("salesSize");
		headList.add("dayOfWeek");
		headList.add("dayOfYear");
		headList.add("salesTime");
		
		CreateCSVUtil.createCSV(headList,dataList);
		long end=System.currentTimeMillis();
		System.out.println(end-start);//6s
		//读取csv文件
		
		//插入模型记录
//		LSTMModel model=new LSTMModel("LSTMModel006",LocalDateTime.now(),1);
//		analyzeDao.insertLSTMModel(model);
//		int id=model.getModelId();
//		System.out.println(id);
//		LSTMModelRecord record =new LSTMModelRecord(id,LocalDateTime.now());
//		analyzeDao.insertLSTMModelRecord(record);
		
		//查找所有模型记录——默认排序：生成时间排序
//		List<LSTMModel> models=analyzeDao.getAllLSTMModel();
//		System.out.println(models);
		
		//查找指定模型的使用记录
//		List<LSTMModelRecord> records=analyzeDao.getAllLSTMModelRecord(2);
//		System.out.println(records);
		
		//查找所有模型记录——使用次数排序
//		List<LSTMModel> models2=analyzeDao.getAllLSTMModelBySize();
//		System.out.println(models2);
		
		//查找所有模型记录——最近一次使用时间排序
//		List<LSTMModel> models3=analyzeDao.getAllLSTMModelByLastUse();
//		System.out.println(models3);
		
		//查找所有模型记录——评分排序
//		List<LSTMModel> models4=analyzeDao.getAllLSTMModelByStar();
//		System.out.println(models4);
		
		//插入使用模型记录
//		LSTMModelRecord record=new LSTMModelRecord(2,LocalDateTime.now());
//		analyzeDao.insertLSTMModelRecord(record);
		
		
		
	}

}
