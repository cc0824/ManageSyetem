package com.cc.pms.bean;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class LSTMModel {
	private Integer modelId;
	private String modelNum;//模型编号
	private LocalDateTime modelTime;//模型生成时间
	private Integer modelSize;//模型使用次数
	private Integer modelStar;//模型评分 1最差 5最好
	private LocalDateTime modelLastTime;//最后一次使用时间
	
	private List<LSTMModelRecord> records;//关联的模型使用次数
	
	public LSTMModel(String modelNum, LocalDateTime modelTime, Integer modelSize) {
		super();
		this.modelNum = modelNum;
		this.modelTime = modelTime;
		this.modelSize = modelSize;
	}
	public LSTMModel(String modelNum, LocalDateTime modelTime, Integer modelSize,Integer modelStar) {
		super();
		this.modelNum = modelNum;
		this.modelTime = modelTime;
		this.modelSize = modelSize;
		this.modelStar = modelStar;
	}
	public LSTMModel(String modelNum, LocalDateTime modelTime, Integer modelSize,Integer modelStar,LocalDateTime modelLastTime) {
		super();
		this.modelNum = modelNum;
		this.modelTime = modelTime;
		this.modelSize = modelSize;
		this.modelStar = modelStar;
		this.modelLastTime=modelLastTime;
	}

	public LSTMModel() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	

	/**
	 * @return the modelLastTime
	 */
	public LocalDateTime getModelLastTime() {
		return modelLastTime;
	}
	/**
	 * @param modelLastTime the modelLastTime to set
	 */
	public void setModelLastTime(LocalDateTime modelLastTime) {
		this.modelLastTime = modelLastTime;
	}
	/**
	 * @return the modelStar
	 */
	public Integer getModelStar() {
		return modelStar;
	}

	/**
	 * @param modelStar the modelStar to set
	 */
	public void setModelStar(Integer modelStar) {
		this.modelStar = modelStar;
	}

	public Integer getModelId() {
		return modelId;
	}

	public void setModelId(Integer modelId) {
		this.modelId = modelId;
	}

	public String getModelNum() {
		return modelNum;
	}

	public void setModelNum(String modelNum) {
		this.modelNum = modelNum;
	}

	public LocalDateTime getModelTime() {
		return modelTime;
	}

	public void setModelTime(LocalDateTime modelTime) {
		this.modelTime = modelTime;
	}

	public Integer getModelSize() {
		return modelSize;
	}

	public void setModelSize(Integer modelSize) {
		this.modelSize = modelSize;
	}

	public List<LSTMModelRecord> getRecords() {
		return records;
	}

	public void setRecords(List<LSTMModelRecord> records) {
		this.records = records;
	}
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return "[modelNum="+modelNum+",modelTime="+modelTime+",modelSize="+modelSize+",modelStar="+modelStar+"]";
	}
	
	
	

}
