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
	//1.���ɾ�����ģ��
	public void trainDecisionTreeModel() throws FileNotFoundException, IOException;
	//2.ʹ�þ�����ģ��
	public List<Object> predictByDecisionTreeModel() throws FileNotFoundException, IOException;
	//3.�鿴���о�����ģ��
	public List<TreeModel> getAllTreeModel();
	public List<TreeModel> getAllTreeModelByStar();
	public List<TreeModel> getAllTreeModelBySize();
	public List<TreeModel> getAllTreeModelByLastUse();
	//4.����lstmmodel��¼
	public void insertLSTMModel(LSTMModel model);
	public void insertLSTMModelRecord(LSTMModelRecord record);
	public void updateLSTMModelById(Integer modelId);
	//5.ģ���Ƽ�
	public List<LSTMModel> getAllLSTMModel();
	public List<LSTMModel> getAllLSTMModelBySize();
	public List<LSTMModel> getAllLSTMModelByLastUse();
	public List<LSTMModel> getAllLSTMModelByStar();
	public List<TreeModel> getAllTreeModelByInput(String inputData);
	//6.����ģ��ʹ�ü�¼
	public List<LSTMModelRecord> getAllLSTMModelRecord(Integer modelId);
	//7.��ȡ����������Դ
	public List<TreeModelData> getTreeModelData(Integer productId);
	//8.ģ������
	public int updateDTModelStar(Integer treeModelId,Integer treeModelStar);
	//9.�޸�ģ��
	public TreeModel getDTModelById(Integer treeModelId);
	public void updateDTModelById(TreeModel model);
	

}
