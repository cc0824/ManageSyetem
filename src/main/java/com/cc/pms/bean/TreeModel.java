package com.cc.pms.bean;

import java.time.LocalDateTime;
import java.util.List;

public class TreeModel {
	public Integer treeModelId;
	public String treeModelNum;//模型编号
	public String treeModelPath;//模型保存路径
	public double treeModelError;//测试结果
	public String treeModelResult;//模型json数据
	private LocalDateTime treeModelTime;//模型生成时间
	private Integer treeModelSize;//模型使用次数
	private Integer treeModelStar;//模型评分 1最差 5最好
	private LocalDateTime treeModelLastTime;//最后一次使用时间
	
	
	@Override
	public String toString() {
		return "TreeModel["+"treeModelNum="+treeModelNum+",treeModelTime="+treeModelTime
				+",treeModelSize="+treeModelSize+",treeModelStar="+treeModelStar+
				",treeModelLastTime="+treeModelLastTime;
	}	
	
	
	public TreeModel(Integer treeModelId, String treeModelNum, String treeModelPath, double treeModelError,
			String treeModelResult, LocalDateTime treeModelTime, Integer treeModelSize, Integer treeModelStar,
			LocalDateTime treeModelLastTime) {
		super();
		this.treeModelId = treeModelId;
		this.treeModelNum = treeModelNum;
		this.treeModelPath = treeModelPath;
		this.treeModelError = treeModelError;
		this.treeModelResult = treeModelResult;
		this.treeModelTime = treeModelTime;
		this.treeModelSize = treeModelSize;
		this.treeModelStar = treeModelStar;
		this.treeModelLastTime = treeModelLastTime;
	}


	/**
	 * @return the treeModelNum
	 */
	public String getTreeModelNum() {
		return treeModelNum;
	}
	/**
	 * @param treeModelNum the treeModelNum to set
	 */
	public void setTreeModelNum(String treeModelNum) {
		this.treeModelNum = treeModelNum;
	}
	/**
	 * @return the treeModelTime
	 */
	public LocalDateTime getTreeModelTime() {
		return treeModelTime;
	}
	/**
	 * @param treeModelTime the treeModelTime to set
	 */
	public void setTreeModelTime(LocalDateTime treeModelTime) {
		this.treeModelTime = treeModelTime;
	}
	/**
	 * @return the treeModelSize
	 */
	public Integer getTreeModelSize() {
		return treeModelSize;
	}
	/**
	 * @param treeModelSize the treeModelSize to set
	 */
	public void setTreeModelSize(Integer treeModelSize) {
		this.treeModelSize = treeModelSize;
	}
	/**
	 * @return the treeModelStar
	 */
	public Integer getTreeModelStar() {
		return treeModelStar;
	}
	/**
	 * @param treeModelStar the treeModelStar to set
	 */
	public void setTreeModelStar(Integer treeModelStar) {
		this.treeModelStar = treeModelStar;
	}
	/**
	 * @return the treeModelLastTime
	 */
	public LocalDateTime getTreeModelLastTime() {
		return treeModelLastTime;
	}
	/**
	 * @param treeModelLastTime the treeModelLastTime to set
	 */
	public void setTreeModelLastTime(LocalDateTime treeModelLastTime) {
		this.treeModelLastTime = treeModelLastTime;
	}
	public TreeModel() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getTreeModelResult() {
		return treeModelResult;
	}
	public void setTreeModelResult(String treeModelResult) {
		this.treeModelResult = treeModelResult;
	}
	public Integer getTreeModelId() {
		return treeModelId;
	}
	public void setTreeModelId(Integer treeModelId) {
		this.treeModelId = treeModelId;
	}
	public String getTreeModelPath() {
		return treeModelPath;
	}
	public void setTreeModelPath(String treeModelPath) {
		this.treeModelPath = treeModelPath;
	}
	public double getTreeModelError() {
		return treeModelError;
	}
	public void setTreeModelError(double treeModelError) {
		this.treeModelError = treeModelError;
	}
	
	
}
