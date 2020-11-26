package com.cc.pms.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

import org.bytedeco.javacv.ImageTransformerCL.InputData;

import com.cc.pms.bean.LSTMModel;
import com.cc.pms.bean.LSTMModelRecord;
import com.cc.pms.bean.TreeModel;
import com.cc.pms.bean.TreeModelData;

public interface AnalyzeService {
	//1.生成决策数模型
	public void trainDecisionTreeModel() throws FileNotFoundException, IOException;
	//2.使用决策树模型
	public List<Object> predictByDecisionTreeModel() throws FileNotFoundException, IOException;
	//3.查看所有决策树模型
	public List<TreeModel> getAllTreeModel();
	public List<TreeModel> getAllTreeModelByStar();
	public List<TreeModel> getAllTreeModelBySize();
	public List<TreeModel> getAllTreeModelByLastUse();
	//4.插入lstmmodel记录
	public void insertLSTMModel(LSTMModel model);
	public void insertLSTMModelRecord(LSTMModelRecord record);
	public void updateLSTMModelById(Integer modelId);
	//5.模型推荐
	public List<LSTMModel> getAllLSTMModel();
	public List<LSTMModel> getAllLSTMModelBySize();
	public List<LSTMModel> getAllLSTMModelByLastUse();
	public List<LSTMModel> getAllLSTMModelByStar();
	public List<TreeModel> getAllTreeModelByInput(String inputData);
	//6.查找模型使用记录
	public List<LSTMModelRecord> getAllLSTMModelRecord(Integer modelId);
	//7.获取决策树数据源
	public List<TreeModelData> getTreeModelData(Integer productId);
	//8.模型评分
	public int updateDTModelStar(Integer treeModelId,Integer treeModelStar);
	//9.修改模型
	public TreeModel getDTModelById(Integer treeModelId);
	public void updateDTModelById(TreeModel model);
	

}
