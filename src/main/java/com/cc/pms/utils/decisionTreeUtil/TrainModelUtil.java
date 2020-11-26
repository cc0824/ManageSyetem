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
		
		//1.��������
		String path="src/main/resources/data/basicdata/irisdata.csv";
		Dataset<Row> dataset=LoadDataUtil.loadData(path);
		//2.ת����ʽ
		List<Object> dataList=TransformDataUtil.transformData(dataset);
		Dataset<Row> data=(Dataset<Row>) dataList.get(0);
		//String path="src/main/resources/formatdata/formatirisdata";
		//Dataset<Row> data=LoadDataUtil.loadFormatData(path);
		data.select("*").show(6,false);
        //�����ݷ�Ϊѵ���Ͳ��Լ���30%���в��ԣ�
        Dataset<Row>[] splits = data.randomSplit(new double[]{0.7, 0.3});
        Dataset<Row> trainingData = splits[0];
        Dataset<Row> testData = splits[1];
        
		//3.ѵ��ģ��
        PipelineModel model=trainModel(dataList,trainingData);
		//3.����ģ��
		//PipelineModel model=PipelineModel.load("src/main/resources/model/model1");
		//4.Ԥ������
		Dataset<Row> predictions = model.transform(testData);
        //predictions.select("Features", "SpeciesNum", "prediction").show(6,false);
        //5.���������
        MulticlassClassificationEvaluator evaluator = new MulticlassClassificationEvaluator()
                .setLabelCol("SpeciesIndex")
                .setPredictionCol("prediction")
                .setMetricName("accuracy");
        double accuracy = evaluator.evaluate(predictions);
        System.out.println("Test Error = " + (1.0 - accuracy));

        //6.�鿴������
        DecisionTreeClassificationModel treeModel =
                (DecisionTreeClassificationModel) (model.stages()[2]);
        System.out.println("Learned classification tree model:\n" + treeModel.toDebugString());
        
	    
		

	}
	
	public static PipelineModel trainModel(List<Object> dataList,Dataset<Row> trainingData) throws IOException{
		StringIndexerModel labelIndexer=(StringIndexerModel) dataList.get(1);
		VectorIndexerModel featureIndexer=(VectorIndexerModel) dataList.get(2);

        //3.���ɾ�����ģ��
        DecisionTreeClassifier dt = new DecisionTreeClassifier()
                .setLabelCol("SpeciesIndex")
                .setFeaturesCol("FeaturesIndex")
                .setImpurity("entropy") // Gini�����ȣ�entropy��
                .setMaxBins(32) // ��ɢ��"��������"����󻮷���
                .setMaxDepth(5) // ����������
                .setMinInfoGain(0.01) //һ���ڵ���ѵ���С��Ϣ���棬ֵΪ[0,1]
                .setMinInstancesPerNode(10) //ÿ���ڵ��������С������
                .setSeed(123456);
        
        IndexToString labelConverter = new IndexToString()
                .setInputCol("prediction")
                .setOutputCol("predictedLabel")
                .setLabels(labelIndexer.labels());


        // Chain indexers and tree in a Pipeline.
        Pipeline pipeline = new Pipeline()
                .setStages(new PipelineStage[]{labelIndexer, featureIndexer, dt, labelConverter});

        //ѵ��ģ��
        PipelineModel model = pipeline.fit(trainingData);
        
        //����ģ��
        model.write().overwrite().save("src/main/resources/model/model1");
        
        return model;
		
	}


}
