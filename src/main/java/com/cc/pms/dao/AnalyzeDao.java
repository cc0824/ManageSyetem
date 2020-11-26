package com.cc.pms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.cc.pms.bean.LSTMModel;
import com.cc.pms.bean.LSTMModelRecord;
import com.cc.pms.bean.TreeModel;
import com.cc.pms.bean.TreeModelData;

public interface AnalyzeDao {
	public void addTreeModel(TreeModel model);
	public List<TreeModel> getAllTreeModel();
	public List<TreeModel> getAllTreeModelByStar();
	public List<TreeModel> getAllTreeModelBySize();
	public List<TreeModel> getAllTreeModelByLastUse();
	public int getLastModelId();
	public void insertLSTMModel(LSTMModel model);
	public void insertLSTMModelRecord(LSTMModelRecord record);
	public void updateLSTMModelById(Integer modelId);
	public List<LSTMModel> getAllLSTMModel();
	public List<LSTMModel> getAllLSTMModelBySize();
	public List<LSTMModel> getAllLSTMModelByLastUse();
	public List<LSTMModel> getAllLSTMModelByStar();
	public List<LSTMModelRecord> getAllLSTMModelRecord(Integer modelId);
	public List<TreeModelData> getAllProductTreeModelData();
	public List<TreeModelData> getOneProductTreeModelData(Integer productId);
	public int updateDTModelStar(Integer treeModelId, Integer treeModelStar);
	public TreeModel getDTModelById(Integer treeModelId);
	public void updateDTModelById(TreeModel model);
	public List<TreeModel> getAllTreeModelByInput(@Param("inputData")String inputData);

}
