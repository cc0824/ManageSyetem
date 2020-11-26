package com.cc.pms.utils.decisionTreeUtil;

import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.SparkSession.Builder;

/**
 * 1.加载数据
 * @author cc
 *
 */
public class LoadDataUtil {
	public static Dataset<Row> loadData(String dataFilePath) {
		//1.启动spark
		SparkSession spark=SparkSession.builder().appName("DTModel").master("local[4]").getOrCreate();
		
		//2.加载数据
		Dataset<Row> dataset = spark.read().format("csv")
				.option("sep", ",")
				.option("inferSchema", "true")//这是自动推断属性列的数据类型
				.option("header", "true")//在csv第一行有属性"true"，没有就是"false"
				.load(dataFilePath);
		//dataset.select("*").show(6,false);
		return dataset;
		
		
	}
	public static Dataset<Row> loadFormatData(String dataFilePath) {
		//1.启动spark
		SparkSession spark=SparkSession.builder().appName("DTModel").master("local[4]").getOrCreate();
		//2.加载数据
		Dataset<Row> dataset = spark.read().parquet(dataFilePath);
		//dataset.select("*").show(6,false);
		return dataset;
	}

}
