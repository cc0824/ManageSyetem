package com.cc.pms.serviceImpl;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.apache.spark.ml.PipelineModel;
import org.apache.spark.ml.classification.DecisionTreeClassificationModel;
import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.cc.pms.bean.LSTMModel;
import com.cc.pms.bean.LSTMModelRecord;
import com.cc.pms.bean.TreeModel;
import com.cc.pms.bean.TreeModelData;
import com.cc.pms.dao.AnalyzeDao;
import com.cc.pms.service.AnalyzeService;
import com.cc.pms.utils.decisionTreeUtil.LoadDataUtil;
import com.cc.pms.utils.decisionTreeUtil.ParseJsonUtil;
import com.cc.pms.utils.decisionTreeUtil.TrainModelUtil;
import com.cc.pms.utils.decisionTreeUtil.TransformDataUtil;

@Service("analyzeService")
public class AnalyzeServiceImpl implements AnalyzeService{
	@Autowired
	private AnalyzeDao analyzeDao;

	@Override
	public void trainDecisionTreeModel() throws FileNotFoundException,IOException {
		//1.加载数据
		String path="D:/Eclipse_Workspace/SSM-PMS/src/main/resources/data/basicdata/irisdata.csv";
		Dataset<Row> dataset=LoadDataUtil.loadData(path);
		
		//2.转换数据格式，并保存格式化后的数据文件
		List<Object> dataList=TransformDataUtil.transformData(dataset);
		Dataset<Row> data=(Dataset<Row>) dataList.get(0);
		
        //将数据分为训练和测试集（70%进行训练）
        Dataset<Row>[] splits = data.randomSplit(new double[]{0.7, 0.3});
        Dataset<Row> trainingData = splits[0];
        
		//3.训练并保存模型
        TrainModelUtil.trainModel(dataList,trainingData);
		
	}

	@Override
	public List<Object> predictByDecisionTreeModel() {
		//1.加载数据
		String path="src/main/resources/formatdata/formatirisdata";
		Dataset<Row> data=LoadDataUtil.loadFormatData(path);
		
        //将数据分为训练和测试集（30%进行测试）
        Dataset<Row>[] splits = data.randomSplit(new double[]{0.7, 0.3});
        Dataset<Row> testData = splits[1];
        
		//2.加载模型
		PipelineModel model=PipelineModel.load("src/main/resources/model/model1");
		
		//3.预测数据
		Dataset<Row> predictions = model.transform(testData);
		
        //4.计算错误率
        MulticlassClassificationEvaluator evaluator = new MulticlassClassificationEvaluator()
                .setLabelCol("SpeciesIndex")
                .setPredictionCol("prediction")
                .setMetricName("accuracy");
        double accuracy = evaluator.evaluate(predictions);
        System.out.println("Test Error = " + (1.0 - accuracy));

        //5.查看决策树
        DecisionTreeClassificationModel treeModel =
                (DecisionTreeClassificationModel) (model.stages()[2]);
        System.out.println("Learned classification tree model:\n" + treeModel.toDebugString());
        
        
        List<Object> result=new ArrayList<>();
		result.add(0, String.valueOf(1.0 - accuracy)+'\n');
		String tree=ParseJsonUtil.parseTreeToJson(treeModel.toDebugString());
		JSONObject treeJson = JSON.parseObject(tree);
		System.out.println(treeJson);
		result.add(1,treeJson);
		
		//添加到数据库
		TreeModel mymodel=new TreeModel();
		int id=analyzeDao.getLastModelId();
		String newNameId=String.format("%03d", id+1);
		mymodel.setTreeModelNum("TreeModel"+newNameId);
		mymodel.setTreeModelError(1.0 - accuracy);
		mymodel.setTreeModelResult(treeModel.toDebugString());
		analyzeDao.addTreeModel(mymodel);
		result.add(2,id+1);
		
		return result;
	}
	@Override
	public List<TreeModel> getAllTreeModelByInput(String inputData) {
		return analyzeDao.getAllTreeModelByInput(inputData);
	}
	@Override
	public List<TreeModel> getAllTreeModel() {
		return analyzeDao.getAllTreeModel();
	}
	@Override
	public List<TreeModel> getAllTreeModelByStar() {
		// TODO Auto-generated method stub
		return analyzeDao.getAllTreeModelByStar();
	}
	@Override
	public List<TreeModel> getAllTreeModelBySize() {
		// TODO Auto-generated method stub
		return analyzeDao.getAllTreeModelBySize();
	}
	@Override
	public List<TreeModel> getAllTreeModelByLastUse() {
		// TODO Auto-generated method stub
		return analyzeDao.getAllTreeModelByLastUse();
	}
	
	
	
	@Override
	public void insertLSTMModel(LSTMModel model) {
		analyzeDao.insertLSTMModel(model);
		int id=model.getModelId();
		LSTMModelRecord record=new LSTMModelRecord(id,LocalDateTime.now());
		analyzeDao.insertLSTMModelRecord(record);
	}
	@Override
	public List<LSTMModel> getAllLSTMModel() {
		// TODO Auto-generated method stub
		return analyzeDao.getAllLSTMModel();
	}
	@Override
	public List<LSTMModel> getAllLSTMModelByLastUse() {
		// TODO Auto-generated method stub
		return analyzeDao.getAllLSTMModelByLastUse();
	}
	@Override
	public List<LSTMModel> getAllLSTMModelBySize() {
		// TODO Auto-generated method stub
		return analyzeDao.getAllLSTMModelBySize();
	}
	@Override
	public List<LSTMModel> getAllLSTMModelByStar() {
		// TODO Auto-generated method stub
		return analyzeDao.getAllLSTMModelByStar();
	}
	@Override
	public List<LSTMModelRecord> getAllLSTMModelRecord(Integer modelId) {
		// TODO Auto-generated method stub
		return analyzeDao.getAllLSTMModelRecord(modelId);
	}
	@Override
	public void insertLSTMModelRecord(LSTMModelRecord record) {
		// TODO Auto-generated method stub
		analyzeDao.insertLSTMModelRecord(record);
	}
	@Override
	public void updateLSTMModelById(Integer modelId) {
		// TODO Auto-generated method stub
		analyzeDao.updateLSTMModelById(modelId);
	}
	@Override
	public List<TreeModelData> getTreeModelData(Integer productId) {
		if(productId==0) {
			return analyzeDao.getAllProductTreeModelData();
		}else {
			return analyzeDao.getOneProductTreeModelData(productId);
		}
	}
	@Override
	public int updateDTModelStar(Integer treeModelId, Integer treeModelStar) {
		return analyzeDao.updateDTModelStar(treeModelId,treeModelStar);
	}
	@Override
	public TreeModel getDTModelById(Integer treeModelId) {
		return analyzeDao.getDTModelById(treeModelId);
	}
	@Override
	public void updateDTModelById(TreeModel model) {
		analyzeDao.updateDTModelById(model);
		
	}




	

}
