package com.cc.pms.utils.clustertUtil;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.ml.clustering.KMeans;
import org.apache.spark.ml.clustering.KMeansModel;
import org.apache.spark.ml.evaluation.ClusteringEvaluator;
import org.apache.spark.ml.feature.VectorAssembler;
import org.apache.spark.ml.linalg.Vector;
import org.apache.spark.ml.linalg.Vectors;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
/**
 * 	从Spark 2.0开始，程序包中基于RDD的API spark.mllib已进入维护模式
 *	现在，用于Spark的主要机器学习API是软件包中基于DataFrame的API spark.ml
 *	
 *	数据源部分：spark sql
 *	算法部分：mllib
 *
 *	应用1：给定销售数据，聚类分析
 * @author cc
 *
 */
public class KMeansCluster1 {
	public static void main(String[] args) throws FileNotFoundException {
//		List<Object> res=test();
//		for(Object o:res) {
//			System.out.println(o);
//		}
//		String temp="distance = 0.5044750642924122\r\n" + 
//				"centers \r\n" + 
//				"[1.3848684210526314,2.526315789473684,5697.375,6107.625,8795.97697368421,2177.9013157894738,3529.345394736842,1190.6118421052631]\r\n" + 
//				"[1.1838235294117647,2.5808823529411766,26089.183823529413,5100.286764705882,6063.125,5070.35294117647,1433.3529411764705,2272.0367647058824]\r\n" + 
//				"";
//		System.out.println(temp);
		test2();
		
	}
	public static String test() {
		String temp="distance = 0.5044750642924122\r\n" + 
				"centers \r\n" + 
				"[1.3848684210526314,2.526315789473684,5697.375,6107.625,8795.97697368421,2177.9013157894738,3529.345394736842,1190.6118421052631]\r\n" + 
				"[1.1838235294117647,2.5808823529411766,26089.183823529413,5100.286764705882,6063.125,5070.35294117647,1433.3529411764705,2272.0367647058824]\r\n" + 
				"";
		return temp;
	}
	

	public static String test2() throws FileNotFoundException {
		// 初始化
		SparkSession spark=SparkSession.builder().appName("ClusterModel").master("local[4]").getOrCreate();
						
		// 加载数据
		Dataset<Row> dataset = spark.read().format("csv")
				.option("sep", ",")
				.option("inferSchema", "true")//这是自动推断属性列的数据类型
				.option("header", "true")//在csv第一行有属性"true"，没有就是"false"
				.load("src/main/resources/data/Wholesale_customers_data.csv");
		Dataset<Row> df = dataset.toDF();
		//df.select("*").show(6,false);
		
		//转化成特征向量
		VectorAssembler va=new VectorAssembler();
		String[] inputs= {"Channel","Region","Fresh","Milk","Grocery","Frozen","Detergents_Paper","Delicassen"};
		va.setInputCols(inputs);
		va.setOutputCol("features");
		Dataset<Row> transDataset =va.transform(df);
		//transDataset.toDF().select("*").show(6,false);
		
		//再次转化
		VectorAssembler va2=new VectorAssembler();
		String[] inputs2= {"features"};
		va.setInputCols(inputs2);
		va.setOutputCol("outfeatures");
		Dataset<Row> transDataset2 =va.transform(transDataset);
		//transDataset2.toDF().select("*").show(6,false);
		
		// 训练模型
		int numClusters = 2;//定义聚类中心数量
		int numIterations = 3;//算法迭代次数
		int runTimes =4;//算法运行的次数
		KMeans kmeans = new KMeans().setK(numClusters).setSeed(1L)
				.setMaxIter(numIterations).setInitSteps(runTimes);
		KMeansModel model = kmeans.fit(transDataset2);

		// 预测
		Dataset<Row> predictions = model.transform(transDataset2);

		// 评估
		ClusteringEvaluator evaluator = new ClusteringEvaluator();

		double silhouette = evaluator.evaluate(predictions);
		//System.out.println("欧式距离 = " + silhouette);

		// 结果
		Vector[] centers = model.clusterCenters();
		//System.out.println("聚类中心： ");
		//for (Vector center: centers) {
			//System.out.println(center);
		//}
		
		List<Object> res=new ArrayList<>();
		res.add("欧式距离 = " + silhouette);
		res.add("聚类中心： ");
		for (Vector center: centers) {
			res.add(center);
		}
		
		String temp="欧式距离 = 0.5044750642924122\r\n" + 
				"聚类中心： \r\n" + 
				"[1.3848684210526314,2.526315789473684,5697.375,6107.625,8795.97697368421,2177.9013157894738,3529.345394736842,1190.6118421052631]\r\n" + 
				"[1.1838235294117647,2.5808823529411766,26089.183823529413,5100.286764705882,6063.125,5070.35294117647,1433.3529411764705,2272.0367647058824]\r\n" + 
				"";
		return temp;
		/**

欧式距离 = 0.5044750642924122
聚类中心： 
[1.3848684210526314,2.526315789473684,5697.375,6107.625,8795.97697368421,2177.9013157894738,3529.345394736842,1190.6118421052631]
[1.1838235294117647,2.5808823529411766,26089.183823529413,5100.286764705882,6063.125,5070.35294117647,1433.3529411764705,2272.0367647058824]

		 */
		
		
	
		
	}

}

