package com.cc.pms.utils.lstmUtil;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


import com.cc.pms.bean.DailyData;

/**
 * -将sql数据转化成csv
 * @author cc
 *
 */
public class CreateCSVUtil {
	/**
	 * 1.生成csv文件
	 * @param inputs
	 */
	public static void createCSV(List<String> headList,List<DailyData> dataList) {
		String fileName = "testCSV.csv";//文件名称
		String filePath = "C:/Users/18379/Desktop/"; //文件路径
		
		File csvFile = null;
		BufferedWriter csvWtriter = null;
		try {
			csvFile = new File(filePath + fileName);
			File parent = csvFile.getParentFile();
			if (parent != null && !parent.exists()) {
				parent.mkdirs();
			}
			csvFile.createNewFile();
			
			// GB2312使正确读取分隔符","
            csvWtriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(
                    csvFile), "GB2312"), 1024);
            // 写入文件头部
            addHeadRow(headList, csvWtriter);
 
            // 写入文件内容
            addDataRow(dataList, csvWtriter);
            
            csvWtriter.flush();
		} catch (Exception e) {
         	e.printStackTrace();
        } finally {
        	try {
        		csvWtriter.close();
        	} catch (IOException e) {
        		e.printStackTrace();
            }
        }
	}
	/**
	 * 2.添加列名
	 * @throws IOException 
	 */
	public static void addHeadRow(List<String> headList, BufferedWriter csvWriter) throws IOException {
		StringBuffer sb = new StringBuffer();
		for (int i=0;i<headList.size()-1;i++) {
	        sb.append(headList.get(i)).append(",");
        }
		sb.append(headList.get(headList.size()-1));
    	csvWriter.write(sb.toString());
		csvWriter.newLine();
	}
	/**
	 * 3.添加行数据
	 */
	public static void addDataRow(List<DailyData> dataList, BufferedWriter csvWriter) throws IOException {
		for (DailyData data : dataList) {
			String temp=data.getInboundCost()+","+data.getInventorySize()+","+data.getSalesPrice()+","+
					data.getSalesSize()+","+dayOfWeek(data.getSalesTime())+
					","+dayOfYear(data.getSalesTime())+","+data.getSalesTime();
        	csvWriter.write(temp);
        	csvWriter.newLine();
        }
	}
	public static int dayOfWeek(LocalDate date) {
		String dayOfWeek=date.getDayOfWeek().toString();
		int res=0;
		switch(dayOfWeek) {
			case "SUNDAY" :{res=7;break;}
			case "MONDAY" :{res=1;break;}
			case "TUESDAY" :{res=2;break;}
			case "WEDNESDAY" :{res=3;break;}
			case "THURSDAY" :{res=4;break;}
			case "FRIDAY" :{res=5;break;}
			case "SATURDAY" :{res=6;break;}
		}
		
		return res;
		
	}
	public static int dayOfYear(LocalDate date) {
		int res=date.getDayOfYear();
		return res;
	}
	
	

}
