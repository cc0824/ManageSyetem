package com.cc.pms.utils.decisionTreeUtil;

import static org.apache.spark.sql.types.DataTypes.DoubleType;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.spark.ml.Pipeline;
import org.apache.spark.ml.PipelineModel;
import org.apache.spark.ml.PipelineStage;
import org.apache.spark.ml.classification.DecisionTreeClassificationModel;
import org.apache.spark.ml.classification.DecisionTreeClassifier;
import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator;
import org.apache.spark.ml.feature.IndexToString;
import org.apache.spark.ml.feature.StringIndexer;
import org.apache.spark.ml.feature.StringIndexerModel;
import org.apache.spark.ml.feature.VectorAssembler;
import org.apache.spark.ml.feature.VectorIndexer;
import org.apache.spark.ml.feature.VectorIndexerModel;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.functions;


public class TrainModelUtil {

	public static void main(String[] args) throws IOException {
		
		//1.加载数据
		String path="src/main/resources/data/basicdata/irisdata.csv";
		Dataset<Row> dataset=LoadDataUtil.loadData(path);
		//2.转换格式
		List<Object> dataList=TransformDataUtil.transformData(dataset);
		Dataset<Row> data=(Dataset<Row>) dataList.get(0);
		//String path="src/main/resources/formatdata/formatirisdata";
		//Dataset<Row> data=LoadDataUtil.loadFormatData(path);
		data.select("*").show(6,false);
        //将数据分为训练和测试集（30%进行测试）
        Dataset<Row>[] splits = data.randomSplit(new double[]{0.7, 0.3});
        Dataset<Row> trainingData = splits[0];
        Dataset<Row> testData = splits[1];
        
		//3.训练模型
        PipelineModel model=trainModel(dataList,trainingData);
		//3.加载模型
		//PipelineModel model=PipelineModel.load("src/main/resources/model/model1");
		//4.预测数据
		Dataset<Row> predictions = model.transform(testData);
        //predictions.select("Features", "SpeciesNum", "prediction").show(6,false);
        //5.计算错误率
        MulticlassClassificationEvaluator evaluator = new MulticlassClassificationEvaluator()
                .setLabelCol("SpeciesIndex")
                .setPredictionCol("prediction")
                .setMetricName("accuracy");
        double accuracy = evaluator.evaluate(predictions);
        System.out.println("Test Error = " + (1.0 - accuracy));

        //6.查看决策树
        DecisionTreeClassificationModel treeModel =
                (DecisionTreeClassificationModel) (model.stages()[2]);
        System.out.println("Learned classification tree model:\n" + treeModel.toDebugString());
        
	    
		

	}
	
	public static PipelineModel trainModel(List<Object> dataList,Dataset<Row> trainingData) throws IOException{
		StringIndexerModel labelIndexer=(StringIndexerModel) dataList.get(1);
		VectorIndexerModel featureIndexer=(VectorIndexerModel) dataList.get(2);

        //3.生成决策树模型
        DecisionTreeClassifier dt = new DecisionTreeClassifier()
                .setLabelCol("SpeciesIndex")
                .setFeaturesCol("FeaturesIndex")
                .setImpurity("entropy") // Gini不纯度，entropy熵
                .setMaxBins(32) // 离散化"连续特征"的最大划分数
                .setMaxDepth(5) // 树的最大深度
                .setMinInfoGain(0.01) //一个节点分裂的最小信息增益，值为[0,1]
                .setMinInstancesPerNode(10) //每个节点包含的最小样本数
                .setSeed(123456);
        
        IndexToString labelConverter = new IndexToString()
                .setInputCol("prediction")
                .setOutputCol("predictedLabel")
                .setLabels(labelIndexer.labels());


        // Chain indexers and tree in a Pipeline.
        Pipeline pipeline = new Pipeline()
                .setStages(new PipelineStage[]{labelIndexer, featureIndexer, dt, labelConverter});

        //训练模型
        PipelineModel model = pipeline.fit(trainingData);
        
        //保存模型
        model.write().overwrite().save("src/main/resources/model/model1");
        
        return model;
		
	}


}
