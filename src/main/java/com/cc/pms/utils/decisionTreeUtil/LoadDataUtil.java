package com.cc.pms.utils.decisionTreeUtil;

import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.SparkSession.Builder;

/**
 * 1.��������
 * @author cc
 *
 */
public class LoadDataUtil {
	public static Dataset<Row> loadData(String dataFilePath) {
		//1.����spark
		SparkSession spark=SparkSession.builder().appName("DTModel").master("local[4]").getOrCreate();
		
		//2.��������
		Dataset<Row> dataset = spark.read().format("csv")
				.option("sep", ",")
				.option("inferSchema", "true")//�����Զ��ƶ������е���������
				.option("header", "true")//��csv��һ��������"true"��û�о���"false"
				.load(dataFilePath);
		//dataset.select("*").show(6,false);
		return dataset;
		
		
	}
	public static Dataset<Row> loadFormatData(String dataFilePath) {
		//1.����spark
		SparkSession spark=SparkSession.builder().appName("DTModel").master("local[4]").getOrCreate();
		//2.��������
		Dataset<Row> dataset = spark.read().parquet(dataFilePath);
		//dataset.select("*").show(6,false);
		return dataset;
	}

}
